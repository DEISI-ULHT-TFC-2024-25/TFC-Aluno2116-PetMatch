import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:tinder_para_caes/models/animal.dart';
import 'package:tinder_para_caes/models/associacao.dart';
import 'package:tinder_para_caes/models/eventos.dart';
import 'package:tinder_para_caes/screens/allAnimalsList.dart';

class VizualizarAssociacaoScreen extends StatefulWidget {
  const VizualizarAssociacaoScreen({super.key});

  @override
  _VizualizarAssociacaoScreenState createState() => _VizualizarAssociacaoScreenState();
}

class _VizualizarAssociacaoScreenState extends State<VizualizarAssociacaoScreen> {
  late GoogleMapController mapController;
  bool isFullScreen = false;
  bool isLoading = true; // Track if data is still loading
  List<Animal> animals = [];
  List<Eventos> events = [];
  List<String> needs = [];
  String name = "";
  int numberOfAnimals = 0;

  final LatLng _center = const LatLng(38.7169, -9.1399); // Associação location

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    Associacao assoE = Associacao.procurarAssociacao(0);

    List<Animal> fetchedAnimals = await assoE.fetchAnimals(assoE.animais);

    setState(() {
      animals = fetchedAnimals;
      events = assoE.eventos;
      needs = assoE.necessidades;
      name = assoE.name;
      numberOfAnimals = assoE.animais.length;
      isLoading = false; // Data is ready
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        body: Center(child: CircularProgressIndicator()), // Show loading indicator
      );
    }

    return Scaffold(
      appBar: isFullScreen ? null : AppBar(title: Text(name)),
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
                        return ListTile(
                          title: Text(events[index].titulo),
                          subtitle: Text(events[index].date),
                        );
                      },
                    ),
                  ],
                  SizedBox(height: 20),
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
                  SizedBox(height: 20),
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
                      SizedBox(
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
                    ],
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
