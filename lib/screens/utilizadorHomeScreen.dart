import 'package:flutter/material.dart';
import 'package:tinder_para_caes/models/associacao.dart';
import 'package:tinder_para_caes/screens/vizualizarAssociacaoScreen.dart';
import 'package:tinder_para_caes/models/animal.dart';
import 'package:tinder_para_caes/screens/adicionarAnimalScreen.dart';
import 'package:tinder_para_caes/screens/allAnimalsList.dart';
import 'package:tinder_para_caes/screens/allAssociacoesList.dart';
import 'package:provider/provider.dart';
import 'package:tinder_para_caes/firebaseLogic/utilizadorProvider.dart';

class UtilizadorHomeScreen extends StatelessWidget {
  const UtilizadorHomeScreen({super.key});


  @override
  Widget build(BuildContext context) {
    final utilizador = Provider.of<UtilizadorProvider>(context).user;

    if (utilizador == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    List<Associacao> sugestoesAssociacoes = Associacao.getSugestoesAssociacoes(utilizador.local);
    List<Associacao> associacoesEnvolvido = utilizador.associacoesEmQueEstaEnvolvido;
    List<Animal> animais = utilizador.osSeusAnimais;



      return Scaffold(
        appBar: AppBar(
          //title: Text("Home Page - $utilizador.fullName"),
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
                    ? Text("Ainda não introduziu o seu patudo")
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
                        context,
                        MaterialPageRoute(
                            builder: (context) => AllAnimalsList(
                              animais: animais,
                              isAssociacao: false,
                            )));
                  },
                  child: Text("Ver todos"),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AdicionarAnimalScreen()));
                  },
                  child: Text("Adicionar patudo"),
                ),
                SizedBox(height: 16.0),
                Text(
                  "Associações Associadas",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8.0),
                SizedBox(
                  height: (associacoesEnvolvido.length > 4)
                      ? 300
                      : associacoesEnvolvido.length * 75.0,
                  child: Column(
                    children: [
                      Expanded(
                        child: ListView.builder(
                          shrinkWrap: true,
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
                              context,
                              MaterialPageRoute(builder: (context) => AllAssociacoesList(associacoes: associacoesEnvolvido))
                          );
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
                SizedBox(
                  height: (sugestoesAssociacoes.length > 4)
                      ? 300
                      : sugestoesAssociacoes.length * 75.0,
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
                              context,
                              MaterialPageRoute(builder: (context) => AllAssociacoesList(associacoes: associacoesEnvolvido))
                          );
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

