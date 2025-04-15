import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:tinder_para_caes/models/animal.dart';
import 'package:tinder_para_caes/models/associacao.dart';
import 'package:tinder_para_caes/models/eventos.dart';
import 'package:tinder_para_caes/screens/allAnimalsList.dart';
import 'package:tinder_para_caes/documents/passearCao.dart';
import 'package:tinder_para_caes/documents/tornarPadrinho.dart';
import 'package:tinder_para_caes/documents/tornarFAT.dart';
import 'package:tinder_para_caes/documents/tornarSocio.dart';
import 'package:tinder_para_caes/documents/tornarVoluntario.dart';

class VizualizarAssociacaoScreen extends StatefulWidget {
  final Associacao associacao;

  const VizualizarAssociacaoScreen({super.key, required this.associacao});

  @override
  _VizualizarAssociacaoScreenState createState() => _VizualizarAssociacaoScreenState();
}

class _VizualizarAssociacaoScreenState extends State<VizualizarAssociacaoScreen> {
  late GoogleMapController mapController;
  bool isFullScreen = false;
  bool isLoading = true;
  List<Animal> animals = [];
  List<Eventos> events = [];
  List<String> needs = [];
  String name = "";
  int numberOfAnimals = 0;
  String uid = "";


//cordenadas a substituir pelas da associação
  final LatLng _center = const LatLng(38.7169, -9.1399);


  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    Associacao assoE = widget.associacao;
    List<Animal> fetchedAnimals = await assoE.fetchAnimals(assoE.animais);

    setState(() {
      animals = fetchedAnimals;
      events = assoE.eventos;
      needs = assoE.necessidades;
      name = assoE.name;
      numberOfAnimals = assoE.animais.length;
      isLoading = false;
      uid = assoE.uid;

    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    if (isLoading) {
      return Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: isFullScreen ? null : AppBar(title: Text(name)),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // Parte Principal: Info e Animais
          Text(
            "$numberOfAnimals animais na associação",
            style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 20),

          if (events.isNotEmpty) ...[
            Text(
              "Eventos:",
              style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: events.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: Icon(Icons.event, color: theme.colorScheme.primary),
                  title: Text(events[index].titulo),
                  subtitle: Text(events[index].date),
                );
              },
            ),
            SizedBox(height: 20),
          ],

          Text(
            "Animais da associação:",
            style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
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
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surfaceVariant,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(Icons.pets, size: 50, color: theme.colorScheme.onSurfaceVariant),
                    ),
                    SizedBox(height: 5),
                    Text(animal.fullName, style: textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold)),
                    Text("${animal.age} anos", style: textTheme.bodyMedium),
                    Text(animal.gender , style: textTheme.bodyMedium),
                    Text(animal.sterilized ? "Castrado" : "Não castrado", style: textTheme.bodyMedium),
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
                  builder: (context) => AllAnimalsList(animais: animals, isAssociacao: false, uidAssociacao: uid),
                ),
              );
            },
            child: Text("Ver Todos"),
          ),

          SizedBox(height: 30),


          Text(
            "Donativos e necessidades:",
            style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          if (needs.isNotEmpty)
            ...needs.map((need) => Text("- $need", style: textTheme.bodyMedium))
          else
            Text("De momento não existem informações", style: textTheme.bodyMedium),
          SizedBox(height: 20),

          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AllAnimalsList(animais: animals, isAssociacao: false, uidAssociacao: uid),
                ),
              );
            },
            child: Text("Contactar Associação"),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TornarPadrinhoScreen(uidAssociacao: uid),
                ),
              );
            },
            child: Text("Apadrinhar"),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PassearCaoScreen(uidAssociacao: uid),
                ),
              );
            },
            child: Text("Ir Passear Cão"),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TornarVoluntarioScreen(),
                ),
              );
            },
            child: Text("Inscrever em Voluntariado"),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TornarSocioScreen(),
                ),
              );
            },
            child: Text("Tornar-se Sócio"),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TornarFAT(uidAssociacao: uid),
                ),
              );
            },
            child: Text("Tornar-se Família de Acolhimento Temporário"),
          ),

        ],
      ),
    );

  }


}
