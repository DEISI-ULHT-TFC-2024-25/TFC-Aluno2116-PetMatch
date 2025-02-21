import 'package:flutter/material.dart';
import 'package:tinder_para_caes/screens/utilizadorHomeScreen.dart';
import 'package:tinder_para_caes/firebaseLogic/authenticationService.dart';

class Criarutilizador extends StatefulWidget {
  @override
  UtilizadorFormScreenState createState() => UtilizadorFormScreenState();
}

class UtilizadorFormScreenState extends State<Criarutilizador> {
  bool isAdult = false;
  String gender = 'Feminino';
  final List<String> genders = ['Feminino', 'Masculino', 'Outro'];
  final Authenticationservice authService = Authenticationservice();

  final TextEditingController nomeController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  final TextEditingController nifController = TextEditingController();
  final TextEditingController telefoneController = TextEditingController();
  final TextEditingController moradaController = TextEditingController();

  void register() async {

    if (passwordController.text != confirmPasswordController.text) {
      print("❌ As palavras-passe não coincidem!");
      return;
    }

    if (passwordController.text.isEmpty || emailController.text.isEmpty) {
      print("❌ Email e senha são obrigatórios");
      return;
    }


    Map<String, dynamic> userData = {
      "nome": nomeController.text,
      "email": emailController.text,
      "nif": nifController.text,
      "telefone": telefoneController.text,
      "morada": moradaController.text,
      "sexo": gender,
      "maior_de_idade": isAdult,
      "tipo": "utilizador",
    };

    var user = await authService.registerUtilizador(
      emailController.text,
      passwordController.text,
      userData,
    );

    if (user != null) {
      print("✅ Utilizador registado com sucesso!");
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => UtilizadorHomeScreen()));
    } else {
      print("❌ Erro ao registrar utilizador");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Formulário de Utilizador')),
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
            TextField(controller: nifController, decoration: InputDecoration(labelText: 'NIF')),
            SizedBox(height: 10),
            TextField(controller: telefoneController, decoration: InputDecoration(labelText: 'Telemóvel')),
            SizedBox(height: 10),
            TextField(controller: emailController, decoration: InputDecoration(labelText: 'Email')),
            SizedBox(height: 10),
            CheckboxListTile(
              title: Text('É maior de idade?'),
              value: isAdult,
              onChanged: (bool? value) {
                setState(() { isAdult = value ?? false; });
              },
            ),
            DropdownButtonFormField<String>(
              decoration: InputDecoration(labelText: 'Sexo'),
              value: gender,
              items: genders.map((String gender) {
                return DropdownMenuItem<String>(value: gender, child: Text(gender));
              }).toList(),
              onChanged: (String? newValue) {
                setState(() { gender = newValue ?? 'Feminino'; });
              },
            ),
            SizedBox(height: 10),
            TextField(controller: moradaController, decoration: InputDecoration(labelText: 'Morada')),
            SizedBox(height: 20),
            Align(
              alignment: Alignment.bottomRight,
              child: ElevatedButton(
                onPressed: register, // 🔹 Chama a função de registo no Firebase
                child: Text('Submeter'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}