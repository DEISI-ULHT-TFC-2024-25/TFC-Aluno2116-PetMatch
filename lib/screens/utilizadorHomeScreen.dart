import 'package:flutter/material.dart';
import 'package:tinder_para_caes/models/associacao.dart';
import 'package:tinder_para_caes/models/utilizador.dart';
import 'package:tinder_para_caes/screens/vizualizarAssociacaoScreen.dart';
import 'package:tinder_para_caes/models/animal.dart';
import 'package:tinder_para_caes/screens/adicionarAnimalScreen.dart';
import 'package:tinder_para_caes/screens/allAnimalsList.dart';
import 'package:tinder_para_caes/screens/allAssociacoesList.dart';

class UtilizadorHomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Obtenção das sugestões com base na localidade
    List<Associacao> sugestoesAssociacoes = Associacao.getSugestoesAssociacoes(Utilizador.user.local);
    List<Associacao> associacoesEnvolvido = Utilizador.user.associacoesEmQueEstaEnvolvido;
    List<Animal> animais = Utilizador.user.osSeusAnimais;

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
              // Seção de animais
              Text(
                "Os seus animais",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8.0),
              animais.isEmpty
                  ? Text("Ainda não introduzio o seu patuto")
                  : Row(
                children: [
                  ...animais.take(3).map((animal) => Expanded(
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Icon(Icons.pets, size: 50),
                            Text(animal.fullName),
                          ],
                        ),
                      ),
                    ),
                  )),
                ],
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(
                      context, MaterialPageRoute(builder: (context) => AllAnimalsList(animais: animais, isAssociacao: false))
                  );
                  // Ação para ver todos os animais
                },
                child: Text("Ver todos"),
              ),

              TextButton(
                onPressed: () {
                  Navigator.push(
                      context, MaterialPageRoute(builder: (context) => AdicionarAnimalScreen())
                  );
                  // Ação para ver todos os animais
                },
                child: Text("Adicionar patudo"),
              ),

              SizedBox(height: 16.0),
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
                        //physics: NeverScrollableScrollPhysics(),
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
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                            context, MaterialPageRoute(builder: (context) => AllAssociacoesList(associacoes: associacoesEnvolvido))
                        );
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
                        itemCount: sugestoesAssociacoes.length > 4 ? 4 : sugestoesAssociacoes.length,
                        itemBuilder: (context, index) {
                          final associacao = sugestoesAssociacoes[index];
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
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                            context, MaterialPageRoute(builder: (context) => AllAssociacoesList(associacoes: associacoesEnvolvido))
                        );
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
