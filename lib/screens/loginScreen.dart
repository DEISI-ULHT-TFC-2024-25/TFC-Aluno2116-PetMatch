import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore
import 'package:tinder_para_caes/firebaseLogic/authenticationService.dart';
import 'escolherUtiliAssoci.dart';
import 'package:tinder_para_caes/screens/utilizadorHomeScreen.dart';
import 'package:tinder_para_caes/screens/associacaoHomeScreen.dart';

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

      // 2️⃣ First, check if the user exists in the "utilizador" collection
      DocumentSnapshot<Map<String, dynamic>> userSnapshot =
      await _firestore.collection('utilizador').doc(user.uid).get();

      String? userType;

      if (userSnapshot.exists) {
        userType = "utilizador"; // User is a normal user
      } else {
        // 3️⃣ If not found, check the "associacao" collection
        DocumentSnapshot<Map<String, dynamic>> assocSnapshot =
        await _firestore.collection('associacao').doc(user.uid).get();

        if (assocSnapshot.exists) {
          userType = "associacao"; // User is an association
        }
      }

      if (userType == null) {
        throw Exception("⚠️ User type not found in Firestore!");
      }

      print("🎭 User type: $userType");

      // 4️⃣ Redirect to the correct screen
      if (userType == "associacao") {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Associacaohomescreen()),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => UtilizadorHomeScreen()),
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Text("Bem-vindo", style: TextStyle(fontSize: 16)),
            const SizedBox(height: 10),
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
            const Spacer(),
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
    );
  }
}