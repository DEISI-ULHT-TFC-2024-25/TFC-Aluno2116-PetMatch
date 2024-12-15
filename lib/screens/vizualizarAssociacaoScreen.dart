import 'package:flutter/material.dart';
import 'package:tinder_para_caes/models/animal.dart';
import 'package:tinder_para_caes/models/associacao.dart';
import 'package:tinder_para_caes/models/eventos.dart';

class vizualizarAssociacaoScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    Associacao assoE = Associacao.procurarAssociacao(0);
    final List<Animal> animals = assoE.animais;
    final List<Eventos> events = assoE.eventos;
    final String name = assoE.name;
    final int numberOfAnimals = assoE.animais.length;
    final List<String> needs = assoE.necessidades;



    return Scaffold(
      appBar: AppBar(
        title: Text(name),
      ),
      body: Padding(
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
                          "Animais Disponíveis:",
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
                          itemCount: 20,
                          itemBuilder: (context, index) {
                            if (index >= animals.length) return SizedBox.shrink();
                            final animal = animals[index];
                            return GestureDetector(
                              onTap: () {
                                // Navigate to animal-specific page
                                Navigator.pushNamed(context, '/animal', arguments: animal);
                              },
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    height: 100,
                                    width: double.infinity,
                                    color: Colors.grey[300], // Placeholder for the image
                                    child: Icon(Icons.pets, size: 50, color: Colors.grey),
                                  ),
                                  SizedBox(height: 5),
                                  Text(animal.fullName, style: TextStyle(fontWeight: FontWeight.bold)),
                                  Text("${animal.age} anos"),
                                  if (animal.gender == 1)
                                    Text("Masculino")
                                  else
                                    Text("Feminino"),
                                  Text(animal.sterilized ? "Castrado" : "Não castrado"),
                                ],
                              ),
                            );
                          },
                        ),
                        SizedBox(height: 10),
                        ElevatedButton(
                          onPressed: () {
                            // Navigate to full animal list
                            Navigator.pushNamed(context, '/animalsList', arguments: name);
                          },
                          child: Text("Ver todos os animais"),
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
                          ...needs.map((need) => Text("- $need")),
                        SizedBox(height: 20),
                        Container(
                          height: 150,
                          color: Colors.grey[300], // Placeholder for the map
                          child: Center(child: Text("Mapa")),
                        ),
                        SizedBox(height: 20),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                Navigator.pushNamed(context, '/becomeMember');
                              },
                              child: Text("Tornar-se sócio"),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.pushNamed(context, '/walkDog');
                              },
                              child: Text("Passear um cão"),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.pushNamed(context, '/sponsorAnimal');
                              },
                              child: Text("Apadrinar um animal"),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.pushNamed(context, '/volunteer');
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
    );
  }
}
