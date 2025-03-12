import 'package:flutter/material.dart';
import 'package:tinder_para_caes/models/animal.dart';
import 'package:tinder_para_caes/screens/animalDetailsScreen.dart';
import 'package:tinder_para_caes/screens/adicionarAnimalScreen.dart';

class AllAnimalsList extends StatelessWidget {
  final List<Animal?> animais;
  final bool isAssociacao;

  AllAnimalsList({required this.animais, required this.isAssociacao});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Todos os Animais"),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(8.0),
        itemCount: animais.length,
        itemBuilder: (context, index) {
          final animal = animais[index];
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8.0),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    animal!.fullName,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text("Idade: ${animal.age} anos"),
                  Text("Sexo: ${animal.gender}"),
                  Text("Castrado: ${animal.sterilized ? "Sim" : "Não"}"),
                  Text("Número de Passeios: ${animal.numeroDePasseiosDados}"),
                  SizedBox(height: 12),
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AnimalDetailsScreen(isAssoci: isAssociacao),
                        ),
                      );
                    },
                    icon: Icon(Icons.visibility),
                    label: Text("Ver mais informações 👀"),
                  ),
                ],
              ),
            ),
          );
        },
      ),

      // Apenas Associações podem adicionar animais
      floatingActionButton: isAssociacao
          ? FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AdicionarAnimalScreen(),
            ),
          );
        },
        child: Text("➕", style: TextStyle(fontSize: 24)),
        tooltip: "Adicionar Animal",
      )
          : null,
    );
  }
}
