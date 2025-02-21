import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:tinder_para_caes/documents/tornarSocio.dart';
import 'package:tinder_para_caes/models/animal.dart';
import 'package:tinder_para_caes/models/associacao.dart';
import 'package:tinder_para_caes/models/eventos.dart';
import 'package:tinder_para_caes/screens/allAnimalsList.dart';
import 'package:tinder_para_caes/documents/passearCao.dart';
import 'package:tinder_para_caes/documents/tornarPadrinho.dart';
import 'package:tinder_para_caes/documents/tornarVoluntario.dart';


class VizualizarAssociacaoScreen extends StatefulWidget {
  @override
  _VizualizarAssociacaoScreenState createState() => _VizualizarAssociacaoScreenState();
}

class _VizualizarAssociacaoScreenState extends State<VizualizarAssociacaoScreen> {
  late GoogleMapController mapController;
  bool isFullScreen = false;

  final LatLng _center = const LatLng(38.7169, -9.1399); // Defina a localização da associação

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    Associacao assoE = Associacao.procurarAssociacao(0);
    final List<Animal> animals = assoE.animais;
    final List<Eventos> events = assoE.eventos;
    final String name = assoE.name;
    final int numberOfAnimals = assoE.animais.length;
    final List<String> needs = assoE.necessidades;

    return Scaffold(
      appBar: isFullScreen
          ? null
          : AppBar(
        title: Text(name),
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "$numberOfAnimals animais na associação",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 20),
                  if (events.isNotEmpty) ...[
                    Text(
                      "Eventos:",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: events.length,
                      itemBuilder: (context, index) {
                        final event = events[index];
                        return ListTile(
                          title: Text(event.titulo),
                          subtitle: Text(event.date),
                        );
                      },
                    ),
                  ],
                  SizedBox(height: 20),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Animais da associação:",
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 10),
                            GridView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 10,
                                mainAxisSpacing: 10,
                                childAspectRatio: 0.8,
                              ),
                              itemCount: animals.length,
                              itemBuilder: (context, index) {
                                final animal = animals[index];
                                return GestureDetector(
                                  onTap: () {
                                    Navigator.pushNamed(context, '/animal', arguments: animal);
                                  },
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Container(
                                        height: 100,
                                        width: double.infinity,
                                        color: Colors.grey[300],
                                        child: Icon(Icons.pets, size: 50, color: Colors.grey),
                                      ),
                                      SizedBox(height: 5),
                                      Text(animal.fullName, style: TextStyle(fontWeight: FontWeight.bold)),
                                      Text("${animal.age} anos"),
                                      Text(animal.gender == 1 ? "Masculino" : "Feminino"),
                                      Text(animal.sterilized ? "Castrado" : "Não castrado"),
                                    ],
                                  ),
                                );
                              },
                            ),
                            SizedBox(height: 10),
                            ElevatedButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => AllAnimalsList(animais: animals, isAssociacao: false),
                                    ),
                                  );
                                },
                                child: Text("Ver Todos"),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Donativos e necessidades:",
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 10),
                            if (needs.isNotEmpty)
                              ...needs.map((need) => Text("- $need"))
                            else
                              Text("De momento não existem informações"),
                            SizedBox(height: 20),
                            Stack(
                              children: [
                                Container(
                                  height: 150,
                                  child: GoogleMap(
                                    onMapCreated: _onMapCreated,
                                    initialCameraPosition: CameraPosition(
                                      target: _center,
                                      zoom: 15.0,
                                    ),
                                    markers: {
                                      Marker(
                                        markerId: MarkerId("associacao"),
                                        position: _center,
                                        infoWindow: InfoWindow(title: name),
                                      ),
                                    },
                                  ),
                                ),
                                Positioned(
                                  top: 8,
                                  right: 8,
                                  child: FloatingActionButton(
                                    mini: true,
                                    backgroundColor: Colors.white,
                                    child: Icon(Icons.fullscreen),
                                    onPressed: () {
                                      setState(() {
                                        isFullScreen = true;
                                      });
                                    },
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 20),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                ElevatedButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => TornarSocioScreen(),
                                      ),
                                    );
                                  },
                                  child: Text("Tornar-se sócio"),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => PassearCaoScreen(),
                                      ),
                                    );
                                  },
                                  child: Text("Passear Cão"),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => TornarPadrinhoScreen(),
                                      ),
                                    );
                                  },
                                  child: Text("Apadrinar um animal"),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => TornarVoluntarioApp(),
                                      ),
                                    );
                                  },
                                  child: Text("Tornar-se voluntário"),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    Navigator.pushNamed(context, '/contactAssociation');
                                  },
                                  child: Text("Falar com a associação"),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          if (isFullScreen)
            Positioned.fill(
              child: Stack(
                children: [
                  GoogleMap(
                    onMapCreated: _onMapCreated,
                    initialCameraPosition: CameraPosition(
                      target: _center,
                      zoom: 15.0,
                    ),
                    markers: {
                      Marker(
                        markerId: MarkerId("associacao"),
                        position: _center,
                        infoWindow: InfoWindow(title: name),
                      ),
                    },
                  ),
                  Positioned(
                    top: 40,
                    right: 16,
                    child: FloatingActionButton(
                      backgroundColor: Colors.white,
                      child: Icon(Icons.fullscreen_exit),
                      onPressed: () {
                        setState(() {
                          isFullScreen = false;
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
