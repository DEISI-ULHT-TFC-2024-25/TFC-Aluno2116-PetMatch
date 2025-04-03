import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:tinder_para_caes/models/associacao.dart';
import 'package:tinder_para_caes/screens/vizualizarAssociacaoScreen.dart';
import 'package:tinder_para_caes/models/animal.dart';
import 'package:tinder_para_caes/screens/adicionarAnimalScreen.dart';
import 'package:tinder_para_caes/screens/allAnimalsList.dart';
import 'package:tinder_para_caes/screens/allAssociacoesList.dart';
import 'package:provider/provider.dart';
import 'package:tinder_para_caes/firebaseLogic/utilizadorProvider.dart';
import 'package:geocoding/geocoding.dart';

class UtilizadorHomeScreen extends StatefulWidget {
  const UtilizadorHomeScreen({super.key});

  @override
  _UtilizadorHomeScreenState createState() => _UtilizadorHomeScreenState();
}

class _UtilizadorHomeScreenState extends State<UtilizadorHomeScreen> {
  List<Animal> animais = [];
  bool isLoading = true;//
  List<Associacao> sugestoesAssociacoes = [];
  late GoogleMapController mapController;
  bool isFullScreen = false;

  BitmapDescriptor? _iconePatinha;
  final Set<Marker> _marcadores = {};

  //cordenadas a substituir pelas da associação
  LatLng _center = LatLng(38.7169, -9.1399); // Valor por defeito, será substituído


  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }


  Future<void> _fetchAnimals() async {
    final utilizador = Provider.of<UtilizadorProvider>(context, listen: false).user;

    if (utilizador != null) {
      List<Animal> fetchedAnimals = await utilizador.fetchAnimals(utilizador.osSeusAnimais);
      setState(() {
        animais = fetchedAnimals;
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }


  Future<void> _fetchSugestoesAssociacoes() async {
    final utilizador = Provider.of<UtilizadorProvider>(context, listen: false).user;
    String? distrito = utilizador?.distrito;

    if (utilizador != null) {
      List<Associacao> fetchedAssociacoes = await Associacao.getSugestoesAssociacoesFirebase(distrito!);
      print(distrito);

      setState(() {
        print(sugestoesAssociacoes);
        sugestoesAssociacoes = fetchedAssociacoes;
      });
    }
    await Future.delayed(Duration(milliseconds: 10));
  }


  Future<void> _carregarIconePatinha() async {
    final icone = await BitmapDescriptor.fromAssetImage(
      const ImageConfiguration(size: Size(48, 48)),
      'assets/patinhaPin.png',
    );

    setState(() {
      _iconePatinha = icone;
    });
    await Future.delayed(Duration(milliseconds: 10));
    _adicionarMarcadoresDasAssociacoes();
  }


  Future<void> _adicionarMarcadoresDasAssociacoes() async {
    if (_iconePatinha == null || sugestoesAssociacoes.isEmpty) return;
    Set<Marker> novosMarcadores = {};
    for (final associacao in sugestoesAssociacoes) {
      try {
        // Obter localização a partir do distrito
        List<Location> locations = await locationFromAddress('${associacao.distrito}, Portugal');

        if (locations.isNotEmpty) {
          final loc = locations.first;

          final marker = Marker(
            markerId: MarkerId(associacao.name),
            position: LatLng(loc.latitude, loc.longitude),
            icon: _iconePatinha!,
            infoWindow: InfoWindow(
              title: associacao.name,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => VizualizarAssociacaoScreen(associacao: associacao),
                  ),
                );
              },
            ),
          );

          novosMarcadores.add(marker);
        }
      } catch (e) {
        print('Erro ao geocodificar ${associacao.distrito}: $e');
      }
    }

    setState(() {
      _marcadores.addAll(novosMarcadores);
    });
    await Future.delayed(Duration(milliseconds: 10));
  }


  Future<void> _atualizarCenterComDistritoDoUtilizador() async {
    final utilizador = Provider.of<UtilizadorProvider>(context, listen: false).user;

    if (utilizador != null && utilizador.distrito != null) {
      try {
        List<Location> locations = await locationFromAddress('${utilizador.distrito}, Portugal');
        if (locations.isNotEmpty) {
          setState(() {
            _center = LatLng(locations.first.latitude, locations.first.longitude);
          });
        }
        if (mapController != null) {
          mapController.animateCamera(CameraUpdate.newLatLng(_center));
        }
        //print("DEBUG: Coordenadas obtidas para ${utilizador.distrito}: ${locations.first.latitude}, ${locations.first.longitude}");

      } catch (e) {
        print("Erro ao obter coordenadas do distrito do utilizador: $e");
      }
    }

    await Future.delayed(Duration(milliseconds: 10));
  }



  @override
  void initState() {
    super.initState();
    _inicializarTudo(); // chama as funções por ordem certa
  }

  Future<void> _inicializarTudo() async {
    await _fetchAnimals();
    await _fetchSugestoesAssociacoes();
    await _atualizarCenterComDistritoDoUtilizador();
    await _carregarIconePatinha();
  }



  @override
  Widget build(BuildContext context) {
    final utilizador = Provider.of<UtilizadorProvider>(context).user;
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;


    if (utilizador == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    List<Associacao> associacoesEnvolvido = utilizador.associacoesEmQueEstaEnvolvido;

      return Scaffold(
        appBar: AppBar(
          //title: Text("Home Page - $utilizador.fullName"),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Seção de animais
                Text(
                  "Os seus animais",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8.0),

                animais.isEmpty
                    ? Text("Ainda não introduziu o seu patudo")
                    : Row(
                  children: [
                    ...animais.take(3).map((animal) => Expanded(
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Icon(Icons.pets, size: 50),
                              Text(animal.fullName),
                            ],
                          ),
                        ),
                      ),
                    )),
                  ],
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AllAnimalsList(
                              animais: animais,
                              isAssociacao: false,
                            )));
                  },
                  child: Text("Ver todos"),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AdicionarAnimalScreen()));
                  },
                  child: Text("Adicionar patudo"),
                ),
                SizedBox(height: 16.0),
                Text(
                  "Associações em que está envolvido",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8.0),
                SizedBox(
                  height: (associacoesEnvolvido.length > 4)
                      ? 300
                      : associacoesEnvolvido.length * 75.0,
                  child: Column(
                    children: [
                      Expanded(
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: associacoesEnvolvido.length > 4 ? 4 : associacoesEnvolvido.length,
                          itemBuilder: (context, index) {
                            final associacao = associacoesEnvolvido[index];
                            return Card(
                              margin: EdgeInsets.symmetric(vertical: 4.0),
                              child: ListTile(
                                title: Text(associacao.name),
                                subtitle: Text("Localidade: ${associacao.distrito}"),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => VizualizarAssociacaoScreen(associacao: associacao,),
                                    ),
                                  );
                                },
                              ),
                            );
                          },
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => AllAssociacoesList(associacoes: associacoesEnvolvido))
                          );
                        },
                        child: Text("Ver todas"),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 16.0),
                Text(
                  "Sugestões de Associações",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8.0),
                SizedBox(
                  height: (sugestoesAssociacoes.length > 4)
                      ? 300
                      : sugestoesAssociacoes.length * 75.0,
                  child: Column(
                    children: [
                      Expanded(
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: sugestoesAssociacoes.length > 4 ? 4 : sugestoesAssociacoes.length,
                          itemBuilder: (context, index) {
                            final associacao = sugestoesAssociacoes[index];
                            return Card(
                              margin: EdgeInsets.symmetric(vertical: 4.0),
                              child: ListTile(
                                title: Text(associacao.name),
                                subtitle: Text("Localidade: ${associacao.distrito}"),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => VizualizarAssociacaoScreen(associacao: associacao,),
                                    ),
                                  );
                                },
                              ),
                            );
                          },
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => AllAssociacoesList(associacoes: sugestoesAssociacoes))
                          );
                        },
                        child: Text("Ver todas"),
                      ),

                    ],
                  ),
                ),

                AnimatedContainer(
                  duration: Duration(milliseconds: 300),
                  height: isFullScreen ? MediaQuery.of(context).size.height * 0.8 : 200,
                  decoration: BoxDecoration(
                    border: Border.all(color: theme.dividerColor),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(6),
                        child: GoogleMap(
                          onMapCreated: _onMapCreated,
                          initialCameraPosition: CameraPosition(
                            target: _center,
                            zoom: 15.0,
                          ),
                          markers: _marcadores,
                        ),
                      ),
                      Positioned(
                        top: 8,
                        right: 8,
                        child: FloatingActionButton(
                          mini: true,
                          onPressed: () {
                            setState(() {
                              isFullScreen = !isFullScreen;
                            });
                          },
                          child: Icon(isFullScreen ? Icons.fullscreen_exit : Icons.fullscreen),
                        ),
                      ),
                    ],
                  ),
                ),


              ],
            ),
          ),
        ),
      );
  }
}


