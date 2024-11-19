import 'package:flutter/material.dart';
import 'package:tinder_para_caes/screens/associacaoHomeScreen.dart';

class Criarassociacao extends StatefulWidget {
  @override
  _CriarAssociacaoFormScreenState createState() => _CriarAssociacaoFormScreenState();
}

class _CriarAssociacaoFormScreenState extends State<Criarassociacao> {
  bool shareLocation = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Formulário de Associação')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            TextField(
              decoration: InputDecoration(labelText: 'Nome'),
            ),
            SizedBox(height: 10),
            TextField(
              decoration: InputDecoration(labelText: 'Palavra-passe'),
              obscureText: true,
            ),
            SizedBox(height: 10),
            TextField(
              decoration: InputDecoration(labelText: 'Confirmação da Palavra-passe'),
              obscureText: true,
            ),
            SizedBox(height: 10),
            TextField(
              decoration: InputDecoration(labelText: 'Telemóvel 1'),
            ),
            SizedBox(height: 10),
            TextField(
              decoration: InputDecoration(labelText: 'Telemóvel 2'),
            ),
            SizedBox(height: 10),
            TextField(
              decoration: InputDecoration(labelText: 'Email 1'),
            ),
            SizedBox(height: 10),
            TextField(
              decoration: InputDecoration(labelText: 'Email 2'),
            ),
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
              TextField(
                decoration: InputDecoration(labelText: 'Morada'),
              ),
            ] else ...[
              TextField(
                decoration: InputDecoration(labelText: 'Localidade'),
              ),
            ],
            SizedBox(height: 20),
            Align(
              alignment: Alignment.bottomRight,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Associacaohomescreen()),
                  );
                },
                child: Text("Submeter"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
