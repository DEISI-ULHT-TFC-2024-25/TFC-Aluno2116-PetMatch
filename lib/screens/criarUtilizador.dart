import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:tinder_para_caes/firebaseLogic/authenticationService.dart';
import 'package:tinder_para_caes/models/utilizador.dart';
import 'package:tinder_para_caes/screens/utilizadorHomeScreen.dart';
import 'package:tinder_para_caes/firebaseLogic/utilizadorProvider.dart';
import 'package:provider/provider.dart';

class CriarUtilizador extends StatefulWidget {
  const CriarUtilizador({super.key});

  @override
  UtilizadorFormScreenState createState() => UtilizadorFormScreenState();
}

class UtilizadorFormScreenState extends State<CriarUtilizador> {
  bool isAdult = false;
  String gender = 'Feminino';
  final List<String> genders = ['Feminino', 'Masculino', 'Outro'];
  final Authenticationservice authService = Authenticationservice();
  List<String> distritos = [];

  final TextEditingController nomeController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  final TextEditingController nifController = TextEditingController();
  final TextEditingController telefoneController = TextEditingController();
  final TextEditingController moradaController = TextEditingController();
  final TextEditingController distritoController = TextEditingController();
  final TextEditingController localidadeController = TextEditingController();
  final TextEditingController zipcodeController = TextEditingController();


  bool _formularioValido() {
    return nomeController.text.trim().isNotEmpty &&
        passwordController.text.isNotEmpty &&
        confirmPasswordController.text.isNotEmpty &&
        telefoneController.text.trim().isNotEmpty &&
        emailController.text.trim().isNotEmpty &&
        moradaController.text.trim().isNotEmpty &&
        zipcodeController.text.trim().isNotEmpty &&
        distritoController.text.trim().isNotEmpty &&
        localidadeController.text.trim().isNotEmpty &&
        isAdult == true;
  }


  Future<void> register() async {
    if (!_formularioValido()) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Preencha todos os campos, são todos obrigatórios!")),
      );
      return;
    }
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
      "nif": nifController.text ?? '',
      "telefone": telefoneController.text,
      "morada": moradaController.text,
      "distrito": distritoController.text,
      "localidade": localidadeController.text,
      "zipcode": zipcodeController.text,
      "genero": gender,
      "maior_de_idade": isAdult,
      "tipo": "utilizador",
      "associacoesEmQueEstaEnvolvido": [],
      "osSeusAnimais": [],
    };

    var firebaseUser = await authService.registerUtilizador(
      emailController.text,
      passwordController.text,
      userData,
    );

    if (firebaseUser != null) {
      print("✅ Utilizador registado com sucesso!");

      final uid = firebaseUser.uid;
      final docRef = FirebaseFirestore.instance.collection('utilizador').doc(uid);
      final docSnap = await docRef.get();
      final data = docSnap.data() as Map<String, dynamic>;
      final meuUtilizador = Utilizador.fromMap(uid,data);
      Provider.of<UtilizadorProvider>(context, listen: false).setUser(meuUtilizador);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const UtilizadorHomeScreen(),
        ),
      );
    } else {
      print("❌ Erro ao registrar utilizador");
    }
  }

  @override
  void initState() {
    super.initState();
    _initializeDistritos();
  }

  static Future<List<String>> loadDistritos() async {
    final String response = await rootBundle.loadString('assets/distritos.txt');
    return response.split('\n').map((line) => line.trim()).toList();
  }

  Future<void> _initializeDistritos() async {
    try {
      final distritosLista = await loadDistritos();
      setState(() {
        distritos = distritosLista;
      });
    } catch (e) {
      print('Erro ao carregar os distritos: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Formulário de Utilizador'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            const SizedBox(height: 20),
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
              controller: nifController,
              decoration: const InputDecoration(labelText: 'NIF'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: telefoneController,
              decoration: const InputDecoration(labelText: 'Telemóvel'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            const SizedBox(height: 10),
            CheckboxListTile(
              title: const Text('É maior de idade?'),
              value: isAdult,
              tileColor: Colors.transparent,
              onChanged: (bool? value) {
                setState(() {
                  isAdult = value ?? false;
                });
              },
            ),
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(labelText: 'Género'),
              value: gender,
              items: genders.map((String g) {
                return DropdownMenuItem<String>(
                  value: g,
                  child: Text(g),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  gender = newValue ?? 'Feminino';
                });
              },
            ),
            const SizedBox(height: 10),
            TextField(
              controller: moradaController,
              decoration: const InputDecoration(labelText: 'Morada'),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: zipcodeController,
              decoration: const InputDecoration(labelText: 'Código Postal'),
            ),
            const SizedBox(height: 20),
            Autocomplete<String>(
              optionsBuilder: (TextEditingValue textEditingValue) {
                if (textEditingValue.text.isEmpty) {
                  return const Iterable<String>.empty();
                }
                return distritos.where((String distrito) =>
                    distrito.toLowerCase().contains(textEditingValue.text.toLowerCase()));
              },
              fieldViewBuilder: (BuildContext context, TextEditingController textEditingController, FocusNode focusNode, VoidCallback onFieldSubmitted) {
                distritoController.text = textEditingController.text;
                return TextField(
                  controller: textEditingController,
                  focusNode: focusNode,
                  decoration: const InputDecoration(labelText: 'Distrito'),
                );
              },
              onSelected: (String selection) {
                distritoController.text = selection;
              },
            ),
            const SizedBox(height: 20),
            TextField(
              controller: localidadeController,
              decoration: const InputDecoration(labelText: 'Localidade'),
            ),

            const SizedBox(height: 20),
            Align(
              alignment: Alignment.bottomRight,
              child: ElevatedButton(
                onPressed: register, // Chama a função de registo
                child: const Text('Submeter'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
