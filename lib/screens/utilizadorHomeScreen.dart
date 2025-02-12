import 'package:flutter/material.dart';
import 'package:tinder_para_caes/models/associacao.dart';
import 'package:tinder_para_caes/models/utilizador.dart';
import 'package:tinder_para_caes/screens/vizualizarAssociacaoScreen.dart';

class UtilizadorHomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Obtenção das sugestões com base na localidade
    List<Associacao> sugestoesAssociacoes = Associacao.getSugestoesAssociacoes(Utilizador.user.local);
    List<Associacao> associacoesEnvolvido = Utilizador.user.associacoesEmQueEstaEnvolvido;

    return Scaffold(
      appBar: AppBar(
        title: Text("Home Page - ${Utilizador.user.fullName}"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Associações Associadas",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8.0),
              Container(
                height: (associacoesEnvolvido.length > 4) ? 300 : associacoesEnvolvido.length * 75.0,
                child: Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: associacoesEnvolvido.length > 4 ? 4 : associacoesEnvolvido.length,
                        itemBuilder: (context, index) {
                          final associacao = associacoesEnvolvido[index];
                          return Card(
                            margin: EdgeInsets.symmetric(vertical: 4.0),
                            child: ListTile(
                              title: Text(associacao.name),
                              subtitle: Text("Localidade: ${associacao.local}"),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => VizualizarAssociacaoScreen(),
                                  ),
                                );
                              },
                            ),
                          );
                        },
                      ),
                    ),
                    if (associacoesEnvolvido.length > 4)
                      TextButton(
                        onPressed: () {
                          // Ação para ver todas as associações
                        },
                        child: Text("Ver todas"),
                      ),
                  ],
                ),
              ),
              SizedBox(height: 16.0),
              Text(
                "Sugestões de Associações",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8.0),
              Container(
                height: (sugestoesAssociacoes.length > 4) ? 300 : sugestoesAssociacoes.length * 75.0,
                child: Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: sugestoesAssociacoes.length > 4 ? 4 : sugestoesAssociacoes.length,
                        itemBuilder: (context, index) {
                          final associacao = sugestoesAssociacoes[index];
                          return Card(
                            margin: EdgeInsets.symmetric(vertical: 4.0),
                            child: ListTile(
                              title: Text(associacao.name),
                              subtitle: Text("Localidade: ${associacao.local}"),
                              trailing: Icon(Icons.add),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => VizualizarAssociacaoScreen(),
                                  ),
                                );
                              },
                            ),
                          );
                        },
                      ),
                    ),
                    if (sugestoesAssociacoes.length > 4)
                      TextButton(
                        onPressed: () {
                          // Ação para ver todas as sugestões
                        },
                        child: Text("Ver todas"),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
