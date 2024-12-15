import 'package:flutter/material.dart';
import 'package:tinder_para_caes/models/animal.dart';
import 'package:tinder_para_caes/screens/animalDetailsScreen.dart';

class AllAnimalsAssociacaoScreen extends StatelessWidget {
  final List<Animal?> animais;

  AllAnimalsAssociacaoScreen({required this.animais});

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
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AnimalDetailsScreen(),
                        ),
                      );
                    },
                    child: Text("Ver Detalhes"),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
