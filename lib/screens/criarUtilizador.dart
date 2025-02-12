import 'package:flutter/material.dart';
import 'package:tinder_para_caes/screens/utilizadorHomeScreen.dart';

class Criarutilizador extends StatefulWidget {
  @override
  UtilizadorFormScreenState createState() => UtilizadorFormScreenState();
}

class UtilizadorFormScreenState extends State<Criarutilizador> {
  bool isAdult = false;
  String gender = 'Feminino';
  final List<String> genders = ['Feminino', 'Masculino', 'Outro'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Formulário de Utilizador')),
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
              decoration: InputDecoration(labelText: 'NIF'),
            ),
            SizedBox(height: 10),
            TextField(
              decoration: InputDecoration(labelText: 'Telemóvel'),
            ),
            SizedBox(height: 10),
            TextField(
              decoration: InputDecoration(labelText: 'Email'),
            ),
            SizedBox(height: 10),
            CheckboxListTile(
              title: Text('É maior de idade?'),
              value: isAdult,
              onChanged: (bool? value) {
                setState(() {
                  isAdult = value ?? false;
                });
              },
            ),
            DropdownButtonFormField<String>(
              decoration: InputDecoration(labelText: 'Sexo'),
              value: gender,
              items: genders.map((String gender) {
                return DropdownMenuItem<String>(
                  value: gender,
                  child: Text(gender),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  gender = newValue ?? 'Feminino';
                });
              },
            ),
            SizedBox(height: 10),
            TextField(
              decoration: InputDecoration(labelText: 'Morada'),
            ),
            SizedBox(height: 20),
            Align(
              alignment: Alignment.bottomRight,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => UtilizadorHomeScreen()),
                  );
                },
                child: Text('Submeter'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
