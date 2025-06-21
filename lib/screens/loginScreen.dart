import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore
import 'package:tinder_para_caes/firebaseLogic/authenticationService.dart';
import 'package:tinder_para_caes/widgets/paw_loading.dart' show PawLoading;
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

  bool _isLoading = false;

  void login() async {
    setState(() {
      _isLoading = true; // Show loading animation
    });
    try {

      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      User? user = userCredential.user;
      if (user == null) {
        throw Exception("❌ Error: User not found.");
      }

      DocumentSnapshot<Map<String, dynamic>> userSnapshot =
      await _firestore.collection('utilizador').doc(user.uid).get();

      String? userType;

      if (userSnapshot.exists) {
        userType = "utilizador"; // Utilizador normal
      } else {

        DocumentSnapshot<Map<String, dynamic>> assocSnapshot =
        await _firestore.collection('associacao').doc(user.uid).get();

        if (assocSnapshot.exists) {
          userType = "associacao"; // utilizador do tipo associação
        }
      }

      if (userType == null) {
        throw Exception("User type not found in Firestore!");
      }
      print(" User type: $userType");


      if (userType == "utilizador") {
        // Ler os dados do documento na coleção 'utilizador'
        Map<String, dynamic>? data = userSnapshot.data(); // era docSnapshot
        if (data == null) {
          throw Exception("Dados do utilizador não encontrados.");
        }
        final meuUtilizador = Utilizador.fromMap(user.uid, data);
        Provider.of<UtilizadorProvider>(context, listen: false).setUser(
            meuUtilizador);

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const UtilizadorHomeScreen()),
        );
      } else if (userType == "associacao") {
        DocumentSnapshot<Map<String, dynamic>> assocSnapshot =
        await _firestore.collection('associacao').doc(user.uid).get();

        Map<String, dynamic>? data = assocSnapshot.data();
        if (data == null) {
          throw Exception("Dados da associação não encontrados.");
        }
        print("AAAAAAAAAAAAAAAAAA");

        final minhaAssociacao = Associacao.fromMap(user.uid, data);
        Provider.of<AssociacaoProvider>(context, listen: false).setAssociation(
            minhaAssociacao);
        await Future.delayed(Duration.zero);

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
    finally {
      setState(() {
        _isLoading = false; // Hide loading animation
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              const Text(
                "Bem-vindo",
                style: TextStyle(fontSize: 24),
                textAlign: TextAlign.center,
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

              _isLoading
                  ?                     PawLoading() // Show paw print animation when logging in
                  : ElevatedButton(
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