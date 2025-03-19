import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:provider/provider.dart';
import 'package:tinder_para_caes/screens/loginScreen.dart';
import 'package:tinder_para_caes/firebaseLogic/utilizadorProvider.dart';
import 'package:tinder_para_caes/firebaseLogic/associacaoProvider.dart';
import 'package:tinder_para_caes/theme/theme.dart'; // Import the theme


void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UtilizadorProvider()),
        ChangeNotifierProvider(create: (_) => AssociacaoProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Minha App',
        theme: lightTheme, // Light theme
        darkTheme: darkTheme, // Dark theme
        themeMode: ThemeMode.system, // Automatically follow system theme
        home: LoginScreen(),
      ),
    );
  }
}
