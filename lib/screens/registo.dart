// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'criarUtilizador.dart';
import 'criarAssociacao.dart';

class RegistrationScreen extends StatelessWidget {
  final String userType;

  RegistrationScreen({required this.userType});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Registo $userType'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text("Caso não tenha ainda efetuado o registo", style: TextStyle(fontSize: 16)),
            SizedBox(height: 10),
            TextField(
              decoration: InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            TextField(
              decoration: InputDecoration(
                labelText: 'Palavra-passe',
                border: OutlineInputBorder(),
                //obscureText: true,
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => userType == 'Utilizador' ? Criarutilizador() : Criarassociacao(),
                  ),
                );
              },
              child: Text('Efetuar Registo'),
            ),
          ],
        ),
      ),
    );
  }
}
