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
      //appBar: AppBar(title: Text('Registo')),
      body: Column(
        children: [
          // Separador na parte superior
          Container(
            color: Colors.grey[200],
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildTabButton('Utilizador', 0),
                _buildTabButton('Associação', 1),
              ],
            ),
          ),
          Expanded(
            child: _selectedIndex == 0 ? CriarUtilizador() : CriarAssociacao(),
          ),
        ],
      ),
    );
  }

  Widget _buildTabButton(String title, int index) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedIndex = index;
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: _selectedIndex == index ? Colors.blue : Colors.transparent,
              width: 3,
            ),
          ),
        ),
        child: Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: _selectedIndex == index ? Colors.blue : Colors.black,
          ),
        ),
      ),
    );
  }
}
