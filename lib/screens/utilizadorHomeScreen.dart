import 'package:flutter/material.dart';
import 'package:tinder_para_caes/models/animal.dart';
import 'package:tinder_para_caes/models/associacao.dart';
import 'package:tinder_para_caes/models/utilizador.dart';

class Utilizadorhomescreen extends StatelessWidget {
  // Função para filtrar associações sugeridas com base na localidade do usuário
  List<Associacao> getSugestoesAssociacoes() {
    return Associacao.todasAssociacoes.where((associacao) =>
    associacao.local == Utilizador.user.local &&
        !Utilizador.user.associacoesEmQueEstaEnvolvido.contains(associacao)
    ).toList();
  }

  @override
  Widget build(BuildContext context) {
    // Obtenção das sugestões com base na localidade
    final sugestoesAssociacoes = getSugestoesAssociacoes();

    return Scaffold(
      appBar: AppBar(
        title: Text("Home Page - ${Utilizador.user.fullName}"),
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
                itemCount: Utilizador.user.associacoesEmQueEstaEnvolvido.length,
                itemBuilder: (context, index) {
                  final associacao = Utilizador.user.associacoesEmQueEstaEnvolvido[index];

                  // MARTELADA
                  var assocName = "";
                  var local = "";
                  if(associacao != null) {
                    assocName = associacao.name;
                    local = associacao.local;
                  }
                  // FIM DA MARTELADA

                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 4.0),
                    child: ListTile(
                      title: Text(assocName),
                      subtitle: Text("Localidade: ${local}"),
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
                      title: Text(associacao.name),
                      subtitle: Text("Localidade: ${associacao.local}"),
                      trailing: Icon(Icons.add),
                      onTap: () {
                        // Aqui você pode adicionar lógica para associar ao usuário
                        print("Adicionar ${associacao.name}");
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
