import 'package:flutter/material.dart';
import 'package:tinder_para_caes/models/animal.dart';
import 'package:tinder_para_caes/models/associacao.dart';
import 'package:tinder_para_caes/models/utilizador.dart';
import 'package:tinder_para_caes/screens/allAnimalsScreen.dart';
import 'package:tinder_para_caes/screens/adicionarAnimalScreen.dart';

// Função para retornar uma associação pelo nome
Associacao procurarAssociacaoPorNome(String nomeProcurado, List<Associacao> associacoes) {
  return associacoes.firstWhere(
        (associacao) => associacao.name.toLowerCase() == nomeProcurado.toLowerCase(),
  );
}

class Associacaohomescreen extends StatelessWidget {

  //ecra exemplo para a associaçao h

  Associacao associacaoImaginaria= procurarAssociacaoPorNome("Associação H", Associacao.todasAssociacoes);

  @override
  Widget build(BuildContext context) {
    List<Animal?> animaisExibidos = associacaoImaginaria.animais.take(9).toList();
    List<Animal?> animais= associacaoImaginaria.animais;

    return Scaffold(
      appBar: AppBar( //ecra feito para associação h
        title: Text("Home Page - ${associacaoImaginaria.name}"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Lista de Associações Associadas
            Text(
              "Os seus pedidos",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.0),
            Expanded(
              child: ListView.builder(
                itemCount: associacaoImaginaria.pedidosRealizados.length,
                itemBuilder: (context, index) {
                  final pedido = associacaoImaginaria.pedidosRealizados[index];

                  String utilizadorName = "";
                  String oQuePretendeFazer = "";
                  Animal? animal = null;
                  if(pedido != null) {
                    utilizadorName = pedido.utilizadorQueRealizaOpedido.fullName;
                    animal = pedido.animalRequesitado;
                    oQuePretendeFazer = pedido.oQuePretendeFazer;
                  }
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 4.0),
                    child: ListTile(
                      title: Text(utilizadorName),
                      subtitle: Column(
                        children: [
                          Text("Animal para qual o pedido foi efetuado: ${animal}",
                            maxLines: 3, // Número máximo de linhas que o texto pode ocupar
                            overflow: TextOverflow.ellipsis, // Adiciona "..." caso o texto ultrapasse o limite),
                            ),

                          Text("Pedido enviado para: ${oQuePretendeFazer}"),
                        ],
                      ),

                    )

                  );
                },
              ),
            ),
            SizedBox(height: 16.0),
//--------------------------------------------------------------------------------------------------


      // Lista de Sugestões de Associações
            Text(
              "Os seus patudos visiveis ao publico",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),

            SizedBox(height: 8.0),
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.all(8.0),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3, // 3 itens por linha
                  crossAxisSpacing: 8.0,
                  mainAxisSpacing: 8.0,
                ),
                itemCount: animaisExibidos.length,
                itemBuilder: (context, index) {

                  return Card(
                    color: Colors.redAccent,
                    child: Center(
                      child: Text(
                        animaisExibidos[index]!.fullName,
                        style: TextStyle(color: Colors.white, fontSize: 16),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AllAnimalsScreen(animais: animais),
                        ),
                      );
                    },
                    child: Text("Ver Todos"),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => AdicionarAnimalScreen()),
                      );
                    },
                    child: Text("Adicionar Animal"),
                  ),
                ],
              ),

            ),
          ],
        ),
      ),
    );
  }
}
