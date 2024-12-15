import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:tinder_para_caes/screens/associacaoHomeScreen.dart'; // Certifique-se de que o arquivo existe
import 'package:tinder_para_caes/screens/mensagensAssociacao.dart'; // Certifique-se de que o arquivo existe
import 'package:tinder_para_caes/screens/defenicoesAssociacao.dart'; // Certifique-se de que o arquivo existe

// Definição dos destinos de navegação
class AppDestination {
  final String route;
  final String label;
  final IconData icon;

  const AppDestination({
    required this.route,
    required this.label,
    required this.icon,
  });
}

const List<AppDestination> destinations = [
  AppDestination(
    label: 'Início',
    icon: Icons.home,
    route: '/',
  ),
  AppDestination(
    label: 'Mensagens',
    icon: Icons.mark_unread_chat_alt,
    route: '/mensagens',
  ),
  AppDestination(
    label: 'Definições',
    icon: Icons.settings,
    route: '/defenicoes',
  ),
];

// Componente RootLayout que inclui a barra de navegação
class RootLayout extends StatelessWidget {
  const RootLayout({
    Key? key,
    required this.currentIndex,
    required this.child,
  }) : super(key: key);

  final int currentIndex;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      bottomNavigationBar: NavigationBar(
        selectedIndex: currentIndex,
        onDestinationSelected: (index) {
          context.go(destinations[index].route);
        },
        destinations: destinations
            .map((destination) => NavigationDestination(
          label: destination.label,
          icon: Icon(destination.icon),
        ))
            .toList(),
      ),
    );
  }
}

// Configuração de rotas com a barra de navegação
final GoRouter appRouter = GoRouter(
  routes: [
    GoRoute(
      path: '/associacaoHomeScreen.dart',
      builder: (context, state) => RootLayout(
        currentIndex: 0,
        child:  Associacaohomescreen(),
      ),
    ),
    GoRoute(
      path: '/mensagensAssociacao.dart',
      builder: (context, state) => RootLayout(
        currentIndex: 1,
        child: MensagensAssociacao(),
      ),
    ),
    GoRoute(
      path: '/defenicoesAssociacao.dart',
      builder: (context, state) => RootLayout(
        currentIndex: 2,
        child:  DefenicoesAssociacao(),
      ),
    ),
  ],
);

