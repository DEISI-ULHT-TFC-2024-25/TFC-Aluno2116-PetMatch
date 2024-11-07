import 'package:flutter/material.dart';
import 'package:tinder_para_caes/screens/criarAssociacao.dart';
import 'package:tinder_para_caes/screens/criarUtilizador.dart';


class EscolherUtiliAssoci extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Escolha o tipo de registo'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Criarutilizador()),
                );
              },
              child: Text('Utilizador'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Criarassociacao()),
                );
              },
              child: Text('Associação'),
            ),
          ],
        ),
      ),
    );
  }
}
