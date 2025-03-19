import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tinder_para_caes/screens/associacaoHomeScreen.dart';
import 'package:tinder_para_caes/models/associacao.dart';
import 'package:tinder_para_caes/firebaseLogic/authenticationService.dart';
import 'package:provider/provider.dart';
import 'package:tinder_para_caes/firebaseLogic/associacaoProvider.dart';
import '../models/funcionalidades.dart' show Funcionalidades;

class CriarAssociacao extends StatefulWidget {
  const CriarAssociacao({super.key});

  @override
  _CriarAssociacaoFormScreenState createState() => _CriarAssociacaoFormScreenState();
}

class _CriarAssociacaoFormScreenState extends State<CriarAssociacao> {
  bool shareLocation = false;
  final Authenticationservice authService = Authenticationservice();
  final TextEditingController nomeController = TextEditingController();
  final TextEditingController email1Controller = TextEditingController();
  final TextEditingController email2Controller = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  final TextEditingController telefone1Controller = TextEditingController();
  final TextEditingController telefone2Controller = TextEditingController();
  final TextEditingController moradaController = TextEditingController();
  final TextEditingController distritoController = TextEditingController();


  List<Funcionalidades> funcionalidadesSelecionadas = [];

  void _mostrarPopUpFuncionalidades() async {
    List<Funcionalidades> selecionadasTemp = List.from(funcionalidadesSelecionadas);

    bool? resultado = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Escolha as Funcionalidades que deseja que as pessoas possam realizar"),
          content: Container(
            width: MediaQuery.of(context).size.width * 0.9, // Ocupa quase a tela toda
            height: MediaQuery.of(context).size.height * 0.7,
            child: ListView(
              children: Funcionalidades.values.map((func) {
                return CheckboxListTile(
                  title: Text(func.toString().split('.').last),
                  value: selecionadasTemp.contains(func),
                  onChanged: (bool? value) {
                    setState(() {
                      if (value == true) {
                        selecionadasTemp.add(func);
                      } else {
                        selecionadasTemp.remove(func);
                      }
                    });
                  },
                );
              }).toList(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context, false);
              },
              child: const Text("Cancelar"),
            ),
            TextButton(
              onPressed: () {
                funcionalidadesSelecionadas = selecionadasTemp;
                MaterialPageRoute(
                    builder: (context) => const AssociacaoHomeScreen(),
                );;
              },
              child: const Text("Confirmar"),
            ),
          ],
        );
      },
    );

    if (resultado == true) {
      setState(() {});
    }
  }

  void register() async {
    if (passwordController.text != confirmPasswordController.text) {
      print("❌ As palavras-passe não coincidem!");
      return;
    }
    if (passwordController.text.isEmpty || email1Controller.text.isEmpty) {
      print("❌ Email e senha são obrigatórios");
      return;
    }

    Map<String, dynamic> associacaoData = {
      "nome": nomeController.text,
      "emailGeral": email1Controller.text,
      "emailParaAlgumaCoisa": email2Controller.text,
      "telemovelPrincipal": telefone1Controller.text,
      "telemovelSecundario": telefone2Controller.text,
      "morada": shareLocation ? moradaController.text : null,
      "distrito": !shareLocation ? distritoController.text : null,
      "tipo": "associacao",
      "animais": [],
      "pedidos": [],
      "eventos": [],
      "necessidades": [],
      "funcionalidades": funcionalidadesSelecionadas
          .map((f) => f.toString().split('.').last)
          .toList(),
    };

    var firebaseUser = await authService.registerAssociacao(

      email1Controller.text,
      passwordController.text,
      associacaoData,
    );

    if (firebaseUser != null) {
      print("✅ Associação registada com sucesso!");
      final uid = firebaseUser.uid;
      final docRef = FirebaseFirestore.instance.collection('associacao').doc(uid);
      final docSnap = await docRef.get();
      final data = docSnap.data() as Map<String, dynamic>;
      final minhaAssociacao = Associacao.fromMap(uid,data);
      Provider.of<AssociacaoProvider>(context, listen: false)
          .setAssociation(minhaAssociacao);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const AssociacaoHomeScreen(),
        ),
      );
    } else {
      print("❌ Erro ao registrar associação");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Formulário de Associação')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            TextField(
              controller: nomeController,
              decoration: const InputDecoration(labelText: 'Nome'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: passwordController,
              decoration: const InputDecoration(labelText: 'Palavra-passe'),
              obscureText: true,
            ),
            const SizedBox(height: 10),
            TextField(
              controller: confirmPasswordController,
              decoration: const InputDecoration(labelText: 'Confirmação da Palavra-passe'),
              obscureText: true,
            ),
            const SizedBox(height: 10),
            TextField(
              controller: telefone1Controller,
              decoration: const InputDecoration(labelText: 'Telemóvel 1'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: telefone2Controller,
              decoration: const InputDecoration(labelText: 'Telemóvel 2'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: email1Controller,
              decoration: const InputDecoration(labelText: 'Email 1'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: email2Controller,
              decoration: const InputDecoration(labelText: 'Email 2'),
            ),
            const SizedBox(height: 10),
            CheckboxListTile(
              title: const Text('Partilhar localização?'),
              value: shareLocation,
              onChanged: (bool? value) {
                setState(() {
                  shareLocation = value ?? false;
                });
              },
            ),
            TextField(
              controller: distritoController,
              decoration: const InputDecoration(labelText: 'Distrito'),
            ),

            if (shareLocation) ...[
              TextField(
                controller: moradaController,
                decoration: const InputDecoration(labelText: 'Morada'),
              ),
            ],
            const SizedBox(height: 20),
            ElevatedButton(
            onPressed: _mostrarPopUpFuncionalidades,
            child: const Text("Escolher Funcionalidades"),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
            onPressed: register,
            child: const Text("Submeter"),
            ),

          ],
        ),
      ),
    );
  }
}
