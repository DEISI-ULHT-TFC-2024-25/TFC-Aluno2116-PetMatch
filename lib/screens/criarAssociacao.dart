import 'package:flutter/material.dart';
import 'package:tinder_para_caes/screens/associacaoHomeScreen.dart';
import 'package:tinder_para_caes/models/associacao.dart';
import 'package:tinder_para_caes/firebaseLogic/authenticationService.dart';

class Criarassociacao extends StatefulWidget {
  @override
  _CriarAssociacaoFormScreenState createState() => _CriarAssociacaoFormScreenState();
}

class _CriarAssociacaoFormScreenState extends State<Criarassociacao> {
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
  final TextEditingController localidadeController = TextEditingController();

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
      "email1": email1Controller.text,
      "email2": email2Controller.text,
      "telefone1": telefone1Controller.text,
      "telefone2": telefone2Controller.text,
      "morada": shareLocation ? moradaController.text : null,
      "localidade": !shareLocation ? localidadeController.text : null,
      "tipo": "associacao",
    };

    var user = await authService.registerAssociacao(
      email1Controller.text,
      passwordController.text,
      associacaoData,
    );

    if (user != null) {
      print("✅ Associação registada com sucesso!");
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Associacaohomescreen()));
    } else {
      print("❌ Erro ao registrar associação");
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Formulário de Associação')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            TextField(controller: nomeController, decoration: InputDecoration(labelText: 'Nome')),
            SizedBox(height: 10),
            TextField(controller: passwordController, decoration: InputDecoration(labelText: 'Palavra-passe'), obscureText: true),
            SizedBox(height: 10),
            TextField(controller: confirmPasswordController, decoration: InputDecoration(labelText: 'Confirmação da Palavra-passe'), obscureText: true),
            SizedBox(height: 10),
            TextField(controller: telefone1Controller, decoration: InputDecoration(labelText: 'Telemóvel 1')),
            SizedBox(height: 10),
            TextField(controller: telefone2Controller, decoration: InputDecoration(labelText: 'Telemóvel 2')),
            SizedBox(height: 10),
            TextField(controller: email1Controller, decoration: InputDecoration(labelText: 'Email 1')),
            SizedBox(height: 10),
            TextField(controller: email2Controller, decoration: InputDecoration(labelText: 'Email 2')),
            SizedBox(height: 10),
            CheckboxListTile(
              title: Text('Partilhar localização?'),
              value: shareLocation,
              onChanged: (bool? value) {
                setState(() {
                  shareLocation = value ?? false;
                });
              },
            ),
            if (shareLocation) ...[
              TextField(controller: moradaController, decoration: InputDecoration(labelText: 'Morada')),
            ] else ...[
              TextField(controller: localidadeController, decoration: InputDecoration(labelText: 'Localidade')),
            ],
            SizedBox(height: 20),
            Align(
              alignment: Alignment.bottomRight,
              child: ElevatedButton(
                onPressed: register, //
                child: Text("Submeter"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
