import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tinder_para_caes/firebaseLogic/authenticationService.dart'; // Serviço de autenticação
import 'escolherUtiliAssoci.dart'; // Tela de registro
import 'package:tinder_para_caes/screens/utilizadorHomeScreen.dart'; // Tela principal para utilizador
import 'package:tinder_para_caes/screens/associacaoHomeScreen.dart'; // Tela principal para associação

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final Authenticationservice authService = Authenticationservice(); // Instância do serviço de autenticação

  void login() async {
    User? user = await authService.loginUser(
      emailController.text.trim(),
      passwordController.text.trim(),
    );

    if (user != null) {
      print("✅ Login bem-sucedido!");

      // 🔹 Pega o tipo do usuário no Firestore
      Map<String, dynamic>? userData = await authService.getUserData(user.uid);
      String userType = userData?['tipo'] ?? 'utilizador'; // Se não existir, assume "utilizador"

      // 🔹 Redireciona conforme o tipo de usuário
      if (userType == "associacao") {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Associacaohomescreen()));
      } else {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => UtilizadorHomeScreen()));
      }
    } else {
      print("❌ Erro no login");
      // Aqui podes exibir um SnackBar ou um alerta para o usuário
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
              controller: emailController, // Agora captura o email
              decoration: const InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: passwordController, // Agora captura a senha
              decoration: const InputDecoration(
                labelText: 'Palavra-passe',
                border: OutlineInputBorder(),
              ),
              obscureText: true, // Oculta a senha
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: login, // Chama a função login()
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
