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

import 'animalDetailsScreen.dart';

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
  String needs = "";
  String name = "";
  int numberOfAnimals = 0;
  String uid = "";
  String iban = "";


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
      iban = assoE.iban ?? "";

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
      appBar: AppBar(
        title: Text(name),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [

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

          numberOfAnimals == 0 ?
            Text("Sem patudos para visualizar"):
          GridView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),

            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              crossAxisSpacing: 0.0,
              mainAxisSpacing: 0.0,
              childAspectRatio: 0.85,
            ),
            itemCount: animals.length> 12 ? 12: animals.length,
            itemBuilder: (context, index) {
              final animal = animals[index];
              String uidAssociacao = uid ?? ''  ;
              return InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AnimalDetailsScreen(animal: animal, isAssoci:true, uidAssociacao: uidAssociacao ),
                    ),
                  );
                },
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(0),
                    child: Column(
                      children: [
                        Image.asset(
                            animal.species == 'Cão' ? 'assets/iconCao.png':
                            animal.species == 'Gato' ? 'assets/iconGato.png':
                            'assets/iconPatinhaGeral.png'
                        ),
                        Text(animal.fullName, style: TextStyle(fontSize: 14)),
                      ],
                    ),
                  ),
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

            child: Text("Ver Todos ($numberOfAnimals)"),
          ),

          SizedBox(height: 20),

          Text("Donativos e necessidades:", style: textTheme.bodyMedium),
          SizedBox(height: 10),
          if (needs.isNotEmpty)
            Text(needs)
          else
            Text("De momento não existem informações", style: textTheme.bodyMedium),
          SizedBox(height: 10),
          if (iban != "")
            Text("Caso queira fazer um donativo:", style: textTheme.bodyMedium),
            Text("IBAN: $iban", style: textTheme.bodyMedium),
          SizedBox(height: 20),


          //botões de açoes
          ElevatedButton(
            onPressed: () {
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
                  builder: (context) => TornarVoluntarioScreen(uidAssociacao: uid),
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
                  builder: (context) => TornarSocioScreen(uidAssociacao: uid),
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
