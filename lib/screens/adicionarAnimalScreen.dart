import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tinder_para_caes/models/animal.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

class AdicionarAnimalScreen extends StatefulWidget {
  @override
  _AdicionarAnimalScreenState createState() => _AdicionarAnimalScreenState();
}

class _AdicionarAnimalScreenState extends State<AdicionarAnimalScreen> {
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _comportamentoController = TextEditingController();
  final TextEditingController _racaController = TextEditingController();
  String? _genero;
  bool _castrado = false;
  String? _porte;
  String? _especie;
  List<String> racas = [];
  List<String> _racasFiltradas = [];

  @override
  void initState() {
    super.initState();
    _initializeDogBreeds(); // Inicializa a leitura
  }

  Future<void> _initializeDogBreeds() async {
    try {
      final dogBreeds = await Animal.loadDogBreeds(); // Carrega a lista de raças
      setState(() {
        racas = dogBreeds; // Atualiza o estado com a lista carregada
      });
    } catch (e) {
      print('Erro ao carregar as raças: $e');
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Adicionar Animal"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                controller: _nomeController,
                decoration: InputDecoration(
                  labelText: "Nome do Animal",
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 10),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: "Gênero",
                  border: OutlineInputBorder(),
                ),
                value: _genero,
                items: ["Feminino", "Masculino"].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? value) {
                  setState(() {
                    _genero = value;
                  });
                },
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Checkbox(
                    value: _castrado,
                    onChanged: (bool? value) {
                      setState(() {
                        _castrado = value ?? false;
                      });
                    },
                  ),
                  Text("Castrado/Esterilizado"),
                ],
              ),
              SizedBox(height: 10),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: "Porte",
                  border: OutlineInputBorder(),
                ),
                value: _porte,
                items: ["Pequeno", "Médio", "Grande", "Gigante"].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? value) {
                  setState(() {
                    _porte = value;
                  });
                },
              ),
              SizedBox(height: 10),
              TextField(
                controller: _comportamentoController,
                decoration: InputDecoration(
                  labelText: "Comportamento e Problemas Comportamentais",
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
              SizedBox(height: 10),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: "Espécie",
                  border: OutlineInputBorder(),
                ),
                value: _especie,
                items: [
                  "Cão",
                  "Gato",
                  "Aves",
                  "Chinchilas",
                  "Porquinhos da Índia",
                  "Cavalos",
                  "Cacatuas",
                  "Ovelhas",
                  "Peixes",
                  "Hamsters"
                ].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? value) {
                  setState(() {
                    _especie = value;
                    _racaController.clear();
                    _racasFiltradas.clear();
                  });
                },
              ),
              SizedBox(height: 10),
            if (_especie == "Cão") ...[
              TextField(
                controller: _racaController,
                decoration: InputDecoration(
                  labelText: "Raça",
                  border: OutlineInputBorder(),
                ),
                onChanged: (String value) {
                  setState(() {
                    _racasFiltradas = racas
                        .where((raca) => raca.toLowerCase().contains(value.toLowerCase()))
                        .toList();
                  });
                },
              ),
              if (_racasFiltradas.isNotEmpty)
                Container(
                  constraints: BoxConstraints(maxHeight: 150),
                  child: ListView.builder(
                    itemCount: _racasFiltradas.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(_racasFiltradas[index]),
                        onTap: () {
                          setState(() {
                            _racaController.text = _racasFiltradas[index];
                            _racasFiltradas = [];
                          });
                        },
                      );
                    },
                  ),
                ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: _salvarAnimal,
                child: Text("Registar animal"),
              ),
            ],
          ]),

        ),
      ),
    );
  }





  void _salvarAnimal() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Você precisa estar autenticado para registrar um animal!")),
      );
      return;
    }

    String userID = user.uid;
    CollectionReference animaisRef = FirebaseFirestore.instance.collection('animal');
    CollectionReference usersRef = FirebaseFirestore.instance.collection('users'); // 🔹 Definição correta

    try {
      DocumentReference novoAnimalRef = await animaisRef.add({
        'nome': _nomeController.text.trim(),
        'genero': _genero,
        'castrado': _castrado,
        'porte': _porte,
        'especie': _especie,
        'raca': _racaController.text.trim(),
        'comportamento': _comportamentoController.text.trim(),
        'donoID': userID,
        'criado_em': Timestamp.now(),
      });

      // 🔹 Agora adicionamos o ID do animal à lista de animais do usuário
      await usersRef.doc(userID).set({
        'animais': FieldValue.arrayUnion([novoAnimalRef.id])
      }, SetOptions(merge: true));

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Animal adicionado com sucesso!")),
      );

      Navigator.pop(context);
    } catch (e) {
      print("Erro ao guardar no Firestore: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erro ao adicionar animal!")),
      );
    }
  }

}



