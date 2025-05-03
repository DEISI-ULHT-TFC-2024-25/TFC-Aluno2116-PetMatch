import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:tinder_para_caes/screens/associacaoHomeScreen.dart';
import 'package:tinder_para_caes/screens/utilizadorHomeScreen.dart';
import 'package:provider/provider.dart';
import 'package:tinder_para_caes/screens/loginScreen.dart';
import 'package:tinder_para_caes/firebaseLogic/utilizadorProvider.dart';
import 'package:tinder_para_caes/firebaseLogic/associacaoProvider.dart';
import 'package:tinder_para_caes/theme/theme.dart';
import 'firebase_options.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  /// Verifica se o utilizador atual é um utilizador normal ou uma associação
  Future<Widget> _verificaAutenticacaoInicial() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      final uid = user.uid;

      final utilizadorDoc = await FirebaseFirestore.instance
          .collection('utilizadores')
          .doc(uid)
          .get();

      if (utilizadorDoc.exists) {
        return const UtilizadorHomeScreen();
      }

      final associacaoDoc = await FirebaseFirestore.instance
          .collection('associacoes')
          .doc(uid)
          .get();

      if (associacaoDoc.exists) {
        return const AssociacaoHomeScreen();
      }
    }

    // Se não estiver autenticado ou não existir nas coleções
    return const LoginScreen();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UtilizadorProvider()),
        ChangeNotifierProvider(create: (_) => AssociacaoProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'PetMatch',
        theme: lightTheme,
        darkTheme: darkTheme,
        themeMode: ThemeMode.system,
        home: FutureBuilder<Widget>(
          future: _verificaAutenticacaoInicial(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              );
            } else if (snapshot.hasData) {
              return snapshot.data!;
            } else {
              return const LoginScreen();
            }
          },
        ),
      ),
    );
  }
}
