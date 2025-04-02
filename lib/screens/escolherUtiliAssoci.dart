import 'package:flutter/material.dart';
import 'package:tinder_para_caes/screens/criarAssociacao.dart';
import 'package:tinder_para_caes/screens/criarUtilizador.dart';

class Escolherutiliassoci extends StatefulWidget {
  const Escolherutiliassoci({super.key});

  @override
  _Escolherutiliassoci createState() => _Escolherutiliassoci();
}

class _Escolherutiliassoci extends State<Escolherutiliassoci> {
  int _selectedIndex = 0; // 0 para Utilizador, 1 para Associação

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(height: 40),
          Row(
            children: [
              _buildTabButton('Utilizador', 0),
              _buildTabButton('Associação', 1),
            ],
          ),
          Expanded(
            child: _selectedIndex == 0 ? CriarUtilizador() : CriarAssociacao(),
          ),
        ],
      ),
    );
  }

  Widget _buildTabButton(String title, int index) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedIndex = index;
          });
        },
        child: Container(
          alignment: Alignment.center,
          padding: EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: _selectedIndex == index ? Colors.black : Colors.transparent,
                width: 5,
              ),
            ),
          ),
          child: Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: _selectedIndex == index ? Colors.black : Colors.brown,
            ),
          ),
        ),
      ),
    );
  }
}
