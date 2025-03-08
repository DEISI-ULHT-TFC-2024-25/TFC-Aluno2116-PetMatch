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
      if (userType == "associacao") {
        // Ler o documento da coleção 'associacao'
        DocumentSnapshot<Map<String, dynamic>> assocSnapshot =
        await _firestore.collection('associacao').doc(user.uid).get();

        if (!assocSnapshot.exists) {
          throw Exception("❌ Documento da associação não encontrado.");
        }

        Map<String, dynamic> data = assocSnapshot.data()!;
        final minhaAssociacao = Associacao.fromMap(data);

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => AssociacaoHomeScreen(associacao: minhaAssociacao)),
        );
      } else {
        // Aqui, criamos a instância de Utilizador com os dados do Firestore.
        // Certifique-se de que sua classe Utilizador possua o método fromMap.
        Map<String, dynamic> userData = userSnapshot.data()!;
        Utilizador utilizadorALogar = Utilizador.fromMap(userData);

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => UtilizadorHomeScreen(utilizador: utilizadorALogar),
          ),
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
