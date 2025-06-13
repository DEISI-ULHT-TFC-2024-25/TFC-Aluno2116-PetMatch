import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:tinder_para_caes/firebaseLogic/utilizadorProvider.dart';
import 'package:tinder_para_caes/firebaseLogic/authenticationService.dart';
import 'package:provider/provider.dart';
import '../theme/theme.dart';

class EditarPerfilUtilizador extends StatefulWidget {
  const EditarPerfilUtilizador({super.key});

  @override
  _EditarPerfilUtilizadorState createState() => _EditarPerfilUtilizadorState();
}

class _EditarPerfilUtilizadorState extends State<EditarPerfilUtilizador> {

  final Authenticationservice authService = Authenticationservice();
  final TextEditingController nomeController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController nifController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  final TextEditingController telefoneController = TextEditingController();
  final TextEditingController generoController = TextEditingController();
  final TextEditingController moradaController = TextEditingController();
  final TextEditingController distritoController = TextEditingController();
  final TextEditingController codigoPostalController = TextEditingController();

  String gender = 'Feminino';
  final List<String> genders = ['Feminino', 'Masculino', 'Outro'];


  void atualizar() async {
    final utilizadorProvider = Provider.of<UtilizadorProvider>(context, listen: false);
    final utilizador = utilizadorProvider.user;

    if (utilizador == null) return;

    final Map<String, dynamic> dadosAtualizados = {};

    if (nomeController.text.trim().isNotEmpty) {
      dadosAtualizados['nome'] = nomeController.text.trim();
    }
    if (emailController.text.trim().isNotEmpty) {
      dadosAtualizados['email'] = emailController.text.trim();
    }
    if (nifController.text.trim().isNotEmpty) {
      dadosAtualizados['nif'] = nifController.text.trim();
    }
    if (telefoneController.text.trim().isNotEmpty) {
      dadosAtualizados['telefone'] = telefoneController.text.trim();
    }
    if (generoController.text.trim().isNotEmpty) {
      dadosAtualizados['gender'] = generoController.text.trim();
    }
    if (distritoController.text.trim().isNotEmpty) {
      dadosAtualizados['distrito'] = distritoController.text.trim();
    }
    if (codigoPostalController.text.trim().isNotEmpty) {
      dadosAtualizados['zipcode'] = codigoPostalController.text.trim();
    }

    // Atualizar palavra-passe se for válida e coincidir
    if (passwordController.text.trim().isNotEmpty &&
        passwordController.text == confirmPasswordController.text) {
      await authService.atualizarPassword(passwordController.text.trim());
    }

    // Atualizar o email se for diferente do atual
    if (emailController.text.trim().isNotEmpty &&
        emailController.text.trim() != utilizador.email) {
      await authService.atualizarEmail(emailController.text.trim());
      dadosAtualizados['email'] = emailController.text.trim();
    }

    await FirebaseFirestore.instance
        .collection('utilizador')
        .doc(utilizador.uid)
        .update(dadosAtualizados);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Perfil atualizado com sucesso!')),
    );

    // Atualizar o provider local
    await utilizadorProvider.recarregarUtilizador();

    // Voltar atrás
    Navigator.pop(context);
  }


  List<String> distritos = [];

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
    final theme = Theme.of(context); // Obtém o tema

    return Scaffold(
      appBar: AppBar(title: const Text('Alteração dos seus dados')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            TextField(
              controller: nomeController,
              decoration: InputDecoration(labelText: 'Nome'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(labelText: 'Palavra-passe'),
              obscureText: true,
            ),
            const SizedBox(height: 10),
            TextField(
              controller: confirmPasswordController,
              decoration: InputDecoration(labelText: 'Confirmação da Palavra-passe'),
              obscureText: true,
            ),
            const SizedBox(height: 10),
            TextField(
              controller: telefoneController,
              decoration: InputDecoration(labelText: 'Telemóvel'),
            ),
            const SizedBox(height: 10),
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
              controller: nifController,
              decoration: InputDecoration(labelText: 'NIF'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: codigoPostalController,
              decoration: InputDecoration(labelText: 'CodigoPostal'),
            ),
            const SizedBox(height: 10),

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

            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: theme.primaryColor),
              onPressed: atualizar,
              child: const Text("Atualizar Perfil"),
            ),
          ],
        ),
      ),
    );
  }
}