import 'package:flutter/material.dart';
import 'package:tinder_para_caes/models/associacao.dart';
import 'package:tinder_para_caes/screens/vizualizarAssociacaoScreen.dart';

class AllAssociacoesList extends StatelessWidget {
  final List<Associacao> associacoes;

  const AllAssociacoesList({super.key, required this.associacoes});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Todas as Associações"),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(8.0),
        itemCount: associacoes.length,
        itemBuilder: (context, index) {
          final associacao = associacoes[index];
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8.0),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    associacao.name,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text("Sigla: ${associacao.sigla}"),
                  Text("Local:${associacao.distrito}"),
                  Text("Número de Animais: ${associacao.animais.length}"),
                  Text("Tarefas Necessárias: ${associacao.funcionalidades}"),
                  SizedBox(height: 12),
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => VizualizarAssociacaoScreen(),
                        ),
                      );
                    },
                    icon: Icon(Icons.visibility),
                    label: Text("Ver mais informações 👀"),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
