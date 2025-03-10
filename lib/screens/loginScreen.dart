import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore
import 'package:go_router/go_router.dart';
import 'package:tinder_para_caes/firebaseLogic/authenticationService.dart';
import 'escolherUtiliAssoci.dart';
import 'package:tinder_para_caes/screens/utilizadorHomeScreen.dart';
import 'package:tinder_para_caes/screens/associacaoHomeScreen.dart';
import 'package:tinder_para_caes/models/utilizador.dart';
import 'package:tinder_para_caes/models/associacao.dart';
import 'package:tinder_para_caes/firebaseLogic/utilizadorProvider.dart';
import 'package:tinder_para_caes/firebaseLogic/associacaoProvider.dart';
import 'package:provider/provider.dart';


class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final Authenticationservice authService = Authenticationservice();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance; // Firestore instance

  void login() async {
    try {
      // 1️⃣ Log in user with email & password
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      User? user = userCredential.user;
      if (user == null) {
        throw Exception("❌ Error: User not found.");
      }

      print("✅ Login successful! UID: ${user.uid}");

      // 2️⃣ Primeiro, verifica se o usuário existe na coleção "utilizador"
      DocumentSnapshot<Map<String, dynamic>> userSnapshot =
      await _firestore.collection('utilizador').doc(user.uid).get();

      String? userType;

      if (userSnapshot.exists) {
        userType = "utilizador"; // Usuário normal
      } else {
        // 3️⃣ Se não for encontrado, verifica na coleção "associacao"
        DocumentSnapshot<Map<String, dynamic>> assocSnapshot =
        await _firestore.collection('associacao').doc(user.uid).get();

        if (assocSnapshot.exists) {
          userType = "associacao"; // Usuário do tipo associação
        }
      }

      if (userType == null) {
        throw Exception("⚠️ User type not found in Firestore!");
      }

      print("🎭 User type: $userType");

      // 4️⃣ Redireciona para a tela correta
      // Se o usuário for "utilizador"
      if (userType == "utilizador") {
        // Ler os dados do documento na coleção 'utilizador'
        Map<String, dynamic>? data = userSnapshot.data(); // era docSnapshot
        if (data == null) {
          throw Exception("Dados do utilizador não encontrados.");
        }
        final meuUtilizador = Utilizador.fromMap(data);

        // Atualiza o provider do Utilizador:
        Provider.of<UtilizadorProvider>(context, listen: false).setUser(
            meuUtilizador);

        // Navega para a tela principal do utilizador (sem passar parâmetro):
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const UtilizadorHomeScreen()),
        );
      } else if (userType == "associacao") {
        // Ler os dados do documento na coleção 'associacao'
        DocumentSnapshot<Map<String, dynamic>> assocSnapshot =
        await _firestore.collection('associacao').doc(user.uid).get();

        Map<String, dynamic>? data = assocSnapshot.data();
        if (data == null) {
          throw Exception("Dados da associação não encontrados.");
        }
        final minhaAssociacao = Associacao.fromMap(data);

        // Atualiza o provider da Associação:
        Provider.of<AssociacaoProvider>(context, listen: false).setAssociation(
            minhaAssociacao);

        // Navega para a tela principal da associação (sem passar parâmetro):
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const AssociacaoHomeScreen()),
        );
      }
    } catch (e) {
      print("❌ Login error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Login failed: ${e.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min, // Mantém apenas o tamanho necessário
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              const Text(
                "Bem-vindo",
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.center, // Centraliza o texto
              ),
              const SizedBox(height: 20),
              TextField(
                controller: emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: passwordController,
                decoration: const InputDecoration(
                  labelText: 'Palavra-passe',
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: login,
                child: const Text('Login'),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Escolherutiliassoci()),
                  );
                },
                child: const Text('Efectuar Registo'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
