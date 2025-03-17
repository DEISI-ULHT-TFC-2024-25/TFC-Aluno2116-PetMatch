import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tinder_para_caes/firebaseLogic/associacaoProvider.dart';

class AllPedidosList extends StatelessWidget {
  const AllPedidosList({super.key});

  @override
  Widget build(BuildContext context) {

    final associacao = Provider.of<AssociacaoProvider>(context).association;

    if (associacao == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text("Notificações"),
        ),
        body: const Center(
          child: Text("Nenhuma associação carregada."),
        ),
      );
    }


    final pedidos = associacao.pedidosRealizados; // List<Pedido>

    return Scaffold(
      appBar: AppBar(
        title: const Text("Notificações"),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(8.0),
        itemCount: pedidos.length,
        itemBuilder: (context, index) {
          final notificacao = pedidos[index]; // notificacao é do tipo Pedido

          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8.0),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  Text(
                    "Utilizador: ${notificacao.utilizadorQueRealizaOpedido.fullName}",
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),

                  Text("Gênero: ${notificacao.utilizadorQueRealizaOpedido.gender}"),
                  const SizedBox(height: 8),
                  Text("O que pretende fazer: ${notificacao.oQuePretendeFazer}"),
                  Text("Associação: ${notificacao.associacao.name}"),
                  Text(
                    "Confirmou requisitos: "
                        "${notificacao.confirmouTodosOsRequisitos ? "Sim" : "Não"}",
                  ),
                  const SizedBox(height: 8),
                  Text("Mensagem Adicional: ${notificacao.mensagemAdicional}"),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          pedidos[index].estado = "Aceite";
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green[300],
                        ),
                        child: const Text("Aceitar"),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          pedidos[index].estado = "Pendente";
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue[300],
                        ),
                        child: const Text("Enviar Mensagem"),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          pedidos[index].estado = "Recusado";
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red[300],
                        ),
                        child: const Text("Recusar"),
                      ),
                    ],
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
