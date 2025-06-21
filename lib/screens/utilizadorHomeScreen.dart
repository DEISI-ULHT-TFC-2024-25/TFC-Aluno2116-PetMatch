import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:tinder_para_caes/models/associacao.dart';
import 'package:tinder_para_caes/models/pedido.dart';
import 'package:tinder_para_caes/screens/allPedidosAceitesList.dart';
import 'package:tinder_para_caes/screens/animalDetailsScreen.dart';
import 'package:tinder_para_caes/screens/loginScreen.dart';
import 'package:tinder_para_caes/screens/vizualizarAssociacaoScreen.dart';
import 'package:tinder_para_caes/models/animal.dart';
import 'package:tinder_para_caes/screens/adicionarAnimalScreen.dart';
import 'package:tinder_para_caes/screens/allAnimalsList.dart';
import 'package:tinder_para_caes/screens/allAssociacoesList.dart';
import 'package:provider/provider.dart';
import 'package:tinder_para_caes/firebaseLogic/utilizadorProvider.dart';
import 'package:geocoding/geocoding.dart';
import 'package:tinder_para_caes/screens/editarPerfilUtilizador.dart';

import '../models/funcionalidades.dart';

class UtilizadorHomeScreen extends StatefulWidget {
  const UtilizadorHomeScreen({super.key});

  @override
  _UtilizadorHomeScreenState createState() => _UtilizadorHomeScreenState();
}

class _UtilizadorHomeScreenState extends State<UtilizadorHomeScreen> {
  List<Animal> animais = [];
  bool isLoading = true;//
  List<Associacao> sugestoesAssociacoes = [];
  List<Associacao> todasAssociacoes = [];
  late GoogleMapController mapController;
  bool isFullScreen = false;
  List <Pedido> pedidosAceites = [];
  TextEditingController pesquisaController = TextEditingController();
  String termoPesquisa = "";

  BitmapDescriptor? _iconePatinha;
  final Set<Marker> _marcadores = {};

  LatLng _center = LatLng(38.7169, -9.1399); // Valor por defeito, será substituído


  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }


  Future<void> fetchAnimals() async {
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


  Future<void> fetchTodasAssociacoes() async {
    final utilizador = Provider.of<UtilizadorProvider>(context, listen: false).user;
    if (utilizador != null) {
      List<Associacao> fetchedTodasAssociacoes = await Associacao.getTodasAssociacoesFirebase();
      setState(() {
        todasAssociacoes = fetchedTodasAssociacoes;
      });
      await Future.delayed(Duration(milliseconds: 10));
    }
  }


  Future<void> fetchSugestoesAssociacoes() async {
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


  Future<void> fetchPedidos() async {
    final utilizador = Provider.of<UtilizadorProvider>(context, listen: false).user;

    if (utilizador == null) {
      setState(() {
        isLoading = false;
      });
      return;
    }

    try {
      final firestore = FirebaseFirestore.instance;
      // Obtem todos os pedidos com utilizador == UID da associação logada
      final querySnapshot = await firestore
          .collection("pedidosENotificacoes")
          .where("uidUtilizador", isEqualTo: utilizador.uid)
          .where("estado", isEqualTo: "Aceite")
          .get();
      // Extrai lista de documentos
      final documentos = querySnapshot.docs;
      // Converte os documentos em objetos Pedido
      List<Pedido> fetchedPedidos = documentos.map((doc) {
        return Pedido.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
      setState(() {
        pedidosAceites = fetchedPedidos;
        isLoading = false;
      });
    } catch (e) {
      print("Erro nos pedidos: $e");
      setState(() {
        isLoading = false;
      });
    }
  }


  Future<void> carregarIconePatinha() async {
    final icone = await BitmapDescriptor.fromAssetImage(
      const ImageConfiguration(size: Size(48, 48)),
      'assets/patinhaPin.png',
    );

    setState(() {
      _iconePatinha = icone;
    });
    await Future.delayed(Duration(milliseconds: 10));
    adicionarMarcadoresDasAssociacoes();
  }


  Future<void> adicionarMarcadoresDasAssociacoes() async {
    if (_iconePatinha == null || todasAssociacoes.isEmpty) return;
    Set<Marker> novosMarcadores = {};
    for (final associacao in todasAssociacoes) {
      try {
        // Obter localização a partir da localidade
        List<Location> locations = await locationFromAddress('${associacao.localidade}, Portugal');

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
        print('Erro ao geocodificar ${associacao.localidade}: $e');
      }
    }

    setState(() {
      _marcadores.addAll(novosMarcadores);
    });
    await Future.delayed(Duration(milliseconds: 10));
  }


  Future<void> atualizarCenterComDistritoDoUtilizador() async {
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


  void _mostrarPopupConfirmarTerminarSessao(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text("Tem a certeza que pretende terminar sessão?"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text("Esta ação irá terminar a sua sessão atual."),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context); // Fecha sem fazer nada
                  },
                  child: Text("Cancelar"),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const LoginScreen()),
                    );
                  },
                  child: Text("Terminar"),
                ),
              ],
            );
          },
        );
      },
    );
  }



  @override
  void initState() {
    super.initState();
    inicializarTudo();
  }

  Future<void> inicializarTudo() async {
    await fetchAnimals();
    await fetchPedidos();
    await fetchTodasAssociacoes();
    await fetchSugestoesAssociacoes();
    await atualizarCenterComDistritoDoUtilizador();
    await carregarIconePatinha();
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

      return Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () {
                _mostrarPopupConfirmarTerminarSessao(context);
              },
            ),
          ],
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
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AnimalDetailsScreen(animal: animal, isAssoci: false, uidAssociacao: ""),
                            ),
                          );
                        },
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Image.asset(
                                animal.species == 'Cão' ? 'assets/iconCao.png':
                                    animal.species == 'Gato' ? 'assets/iconGato.png':
                                        'assets/iconPatinhaGeral.png'
                              ),
                              Text(animal.fullName),
                            ],
                          ),
                        ),
                      ),
                    ))),
                  ],
                ),

                Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AllAnimalsList(animais: animais,isAssociacao: false,uidAssociacao: " "),
                            ),
                          );
                        },
                        child: Text("Ver todos"),
                      ),
                    ),
                    SizedBox(width: 8), // Espaçamento entre os botões
                    Expanded(
                      child: TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AdicionarAnimalScreen(),
                            ),
                          );
                        },
                        child: Text("Adicionar patudo"),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20.0),
                Text(
                  "Notificações: ",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8.0),
                SizedBox(
                  height: (pedidosAceites.length > 2)
                      ? 200
                      : pedidosAceites.length * 100.0,
                  child: Column(
                    children: [
                      Expanded(
                        child: ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: pedidosAceites.length > 2 ? 2 : pedidosAceites.length,
                          itemBuilder: (context, index) {
                            final pedido = pedidosAceites[index];
                            //String nomeAssociacao = Associacao.getNomeAssociacao(pedido.associacaoId).toString();
                            return Card(
                              margin: EdgeInsets.symmetric(vertical: 4.0),
                              child: ListTile(
                                title: Text(pedido.funcionalidade ?? 'Ação não disponivel'),
                                subtitle: Text("Estado: ${pedido.estado ?? 'Desconhecida'}"),
                              ),
                            );
                          },
                        ),
                      ),

                    ],
                  ),
                ),
                Center(
                  child: TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AllPedidosAceitesList(pedidos: pedidosAceites),
                        ),
                      );
                    },
                    child: Text("Ver todos os pedidos (${pedidosAceites.length})"),
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
                    : sugestoesAssociacoes.length * 100.0,
                  child: Column(
                    children: [
                      Expanded(
                        child: ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: sugestoesAssociacoes.length > 4 ? 4 : sugestoesAssociacoes.length,
                          itemBuilder: (context, index) {
                            final associacao = sugestoesAssociacoes[index];
                            return Card(
                              margin: EdgeInsets.symmetric(vertical: 4.0),
                              child: ListTile(
                                title: Text(associacao.name),
                                subtitle: Text("Distrito: ${associacao.distrito}\nLocalidade: ${associacao.localidade}"),
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
                    ],
                  ),
                ),
                Center(
                  child: TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              AllAssociacoesList(associacoes: todasAssociacoes),
                        ),
                      );
                    },
                    child: Text("Ver todas"),
                  ),
                ),
                SizedBox(height: 16.0),

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
                SizedBox(height: 16.0),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EditarPerfilUtilizador(),
                        ),
                      );
                    },
                    child: Text("Editar Perfil"),
                  ),
                )
              ],
            ),
          ),
        ),
      );
  }
}


