import 'package:flutter/material.dart';
import 'package:tinder_para_caes/models/animal.dart';
import 'package:tinder_para_caes/models/associacao.dart';
import 'package:tinder_para_caes/screens/allAnimalsList.dart';
import 'package:tinder_para_caes/screens/adicionarAnimalScreen.dart';
import 'package:provider/provider.dart';
import 'package:tinder_para_caes/firebaseLogic/associacaoProvider.dart';
import 'package:tinder_para_caes/screens/allPedidosList.dart';

class AssociacaoHomeScreen extends StatelessWidget {

  const AssociacaoHomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final associacao = Provider.of<AssociacaoProvider>(context).association;

    if (associacao == null) {
      return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: Text("Página da Associação"),
        //backgroundColor: Colors.brown, // Ajuste conforme necessário
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Título
              Text(
                "Home Page - ${associacao.name}",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  decoration: TextDecoration.none,
                ),
              ),
              SizedBox(height: 16.0),

              // Notificações
              Text(
                "Notificações",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  decoration: TextDecoration.none,
                ),
              ),
              SizedBox(height: 8.0),

              // Lista de notificações
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: associacao.pedidosRealizados.length,
                itemBuilder: (context, index) {
                  final pedido = associacao.pedidosRealizados[index];
                  String utilizadorName = pedido.utilizadorQueRealizaOpedido.fullName;
                  Animal animal = pedido.animalRequesitado;
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 4.0, horizontal: 4.0),
                    child: ListTile(
                      title: Text(utilizadorName),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Animal interessado: ${animal.fullName}",
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text("Pedido: ${pedido.oQuePretendeFazer}"),
                        ],
                      ),
                    ),
                  );
                },
              ),
              SizedBox(height: 16.0),

              // Animais visíveis ao público
              Text(
                "Os seus patudos visíveis ao público",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  decoration: TextDecoration.none,
                ),
              ),
              SizedBox(height: 8.0),

              // Grid de animais com scroll total
              GridView.builder(
                shrinkWrap: true, // Permite que o Grid se ajuste dentro do SingleChildScrollView
                physics: NeverScrollableScrollPhysics(), // Evita conflitos de rolagem
                padding: const EdgeInsets.all(8.0),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3, // Define 3 colunas
                  crossAxisSpacing: 8.0,
                  mainAxisSpacing: 8.0,
                  childAspectRatio: 1, // Mantém os cards mais quadrados
                ),
                itemCount: associacao.animais.length,
                itemBuilder: (context, index) {
                  return Card(
                    color: Colors.brown,
                    child: Center(
                      child: Text(
                        associacao.animais[index].fullName,
                        style: TextStyle(color: Colors.white, fontSize: 16),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  );
                },
              ),
              SizedBox(height: 16.0),

              // Botões de ações
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AllAnimalsList(
                              animais: associacao.animais,
                              isAssociacao: true,
                            ),
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
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => AllPedidosList()),
                        );
                      },
                      child: Text("Ver notificações"),
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
