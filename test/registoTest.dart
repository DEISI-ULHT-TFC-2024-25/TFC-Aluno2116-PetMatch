import 'package:flutter/material.dart' show TextField;
import 'package:flutter_test/flutter_test.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:mockito/mockito.dart';
import 'package:tinder_para_caes/screens/loginScreen.dart';
import 'package:tinder_para_caes/screens/escolherUtiliAssoci.dart';
import 'package:provider/provider.dart';
import 'mocks.mocks.dart'; // Import generated mocks
import 'test_helpers.dart'; // Import test helper

void main() {
  group('LoginScreen Tests', () {
    late MockAuthenticationservice mockAuthService;
    late MockFirebaseAuth mockFirebaseAuth;

    setUp(() {
      mockAuthService = MockAuthenticationservice();
      mockFirebaseAuth = MockFirebaseAuth();
    });

    testWidgets('Verifica se os campos de entrada de email e senha existem', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget(child: const LoginScreen(), authService: mockAuthService));
      expect(find.byType(TextField), findsNWidgets(2));
      expect(find.text('Email'), findsOneWidget);
      expect(find.text('Palavra-passe'), findsOneWidget);
    });

    testWidgets('Verifica se o botão de login existe e pode ser pressionado', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget(child: const LoginScreen(), authService: mockAuthService));
      final loginButton = find.text('Login');
      expect(loginButton, findsOneWidget);
      await tester.tap(loginButton);
      await tester.pump();
    });

    testWidgets('Exibe uma mensagem de erro ao tentar login com credenciais inválidas', (WidgetTester tester) async {
      when(mockAuthService.loginUser(any, any)).thenThrow(Exception('Erro no login'));
      await tester.pumpWidget(createTestWidget(child: const LoginScreen(), authService: mockAuthService));
      await tester.enterText(find.byType(TextField).first, 'email@invalido.com');
      await tester.enterText(find.byType(TextField).last, 'senhaerrada');
      await tester.tap(find.text('Login'));
      await tester.pump();
      expect(find.textContaining('Login failed'), findsOneWidget);
    });


    testWidgets('Navega para a tela de registro ao clicar no botão de registro', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget(child: const LoginScreen(), authService: mockAuthService));
      await tester.tap(find.text('Efectuar Registo'));
      await tester.pumpAndSettle();
      expect(find.byType(Escolherutiliassoci), findsOneWidget);
    });

    testWidgets('Verifica se a tela exibe a mensagem de boas-vindas', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget(child: const LoginScreen(), authService: mockAuthService));
      expect(find.text('Bem-vindo'), findsOneWidget);
    });

    testWidgets('Verifica se os campos de entrada começam vazios', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget(child: const LoginScreen(), authService: mockAuthService));
      expect(find.text(''), findsNWidgets(2));
    });

    testWidgets('Exibe erro ao tentar login sem preencher os campos', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget(child: const LoginScreen(), authService: mockAuthService));
      await tester.tap(find.text('Login'));
      await tester.pump();
      expect(find.textContaining('Login failed'), findsOneWidget);
    });

    testWidgets('Permite preencher os campos corretamente', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget(child: const LoginScreen(), authService: mockAuthService));
      await tester.enterText(find.byType(TextField).first, 'usuario@teste.com');
      await tester.enterText(find.byType(TextField).last, 'senha123');
      expect(find.text('usuario@teste.com'), findsOneWidget);
      expect(find.text('senha123'), findsOneWidget);
    });

    testWidgets('Exibe erro ao inserir email inválido', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget(child: const LoginScreen(), authService: mockAuthService));
      await tester.enterText(find.byType(TextField).first, 'email-invalido');
      await tester.enterText(find.byType(TextField).last, 'senha123');
      await tester.tap(find.text('Login'));
      await tester.pump();
      expect(find.textContaining('Login failed'), findsOneWidget);
    });
  });
}
