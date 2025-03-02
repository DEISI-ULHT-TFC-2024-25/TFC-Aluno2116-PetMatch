import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tinder_para_caes/firebaseLogic/authenticationService.dart'; // Serviço de autenticação
import 'escolherUtiliAssoci.dart';
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
  final Authenticationservice authService = Authenticationservice();

  void login() async {
    User? user = await authService.loginUser(
      emailController.text.trim(),
      passwordController.text.trim(),
    );

    if (user != null) {
      print("✅ Login bem-sucedido!");

      // Obtém os dados do utilizador no Firestore
      Map<String, dynamic>? userData = await authService.getUserData(user.uid);
      String userType = userData?['tipo'] ?? 'utilizador'; // Assume "utilizador" se não existir
      print(userType);
      // Redireciona com base no tipo de usuário
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
    } else {
      print("❌ Erro no login");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erro ao fazer login. Verifique seus dados e tente novamente.')),
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
              onPressed: login, // Agora chama a função de login corretamente
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
