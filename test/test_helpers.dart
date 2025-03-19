import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'mocks.mocks.dart'; // Importa os mocks gerados

Widget createTestWidget({required Widget child, required MockAuthenticationservice authService}) {
  return MaterialApp(
    home: Provider<MockAuthenticationservice>.value(
      value: authService,
      child: child,
    ),
  );
}
