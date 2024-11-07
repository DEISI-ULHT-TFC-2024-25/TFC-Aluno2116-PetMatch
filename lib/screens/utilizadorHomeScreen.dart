import 'package:flutter/material.dart';
import 'package:tinder_para_caes/models/animais.dart';
import 'package:tinder_para_caes/models/associacao.dart';
import 'package:tinder_para_caes/models/utilizador.dart';
import 'package:tinder_para_caes/unitTests/homeScreens.dart';

class Utilizadorhomescreen extends StatelessWidget {
  // Função para filtrar associações sugeridas com base na localidade do usuário
  List<Associacao> getSugestoesAssociacoes() {
    return Homescreens().todasAssociacoes.where((associacao) =>
    associacao.local == Utilizador.local&&
        !Utilizador.associacoesEmQueEstaEnvolvido.contains(associacao)
    ).toList();
  }

  @override
  Widget build(BuildContext context) {
    // Obtenção das sugestões com base na localidade
    final sugestoesAssociacoes = getSugestoesAssociacoes();

    return Scaffold(
      appBar: AppBar(
        title: Text("Home - ${Utilizador.name}"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Lista de Associações Associadas
            Text(
              "Associações Associadas",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.0),
            Expanded(
              child: ListView.builder(
                itemCount: usuario.associacoes.length,
                itemBuilder: (context, index) {
                  final associacao = usuario.associacoes[index];
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 4.0),
                    child: ListTile(
                      title: Text(associacao.nome),
                      subtitle: Text("Localidade: ${associacao.localidade}"),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 16.0),

            // Lista de Sugestões de Associações
            Text(
              "Sugestões de Associações",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.0),
            Expanded(
              child: ListView.builder(
                itemCount: sugestoesAssociacoes.length,
                itemBuilder: (context, index) {
                  final associacao = sugestoesAssociacoes[index];
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 4.0),
                    child: ListTile(
                      title: Text(associacao.nome),
                      subtitle: Text("Localidade: ${associacao.localidade}"),
                      trailing: Icon(Icons.add),
                      onTap: () {
                        // Aqui você pode adicionar lógica para associar ao usuário
                        print("Adicionar ${associacao.nome}");
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
