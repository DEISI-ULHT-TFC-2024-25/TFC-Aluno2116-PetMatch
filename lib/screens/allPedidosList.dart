import 'package:flutter/material.dart';
import 'package:tinder_para_caes/models/utilizador.dart';
import 'package:tinder_para_caes/models/associacao.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tinder_para_caes/firebaseLogic/associacaoProvider.dart';
import 'package:tinder_para_caes/models/pedido.dart';

class AllPedidosList extends StatelessWidget {
  const AllPedidosList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Obtemos a associação do Provider
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

    // A lista de pedidos da associação
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
                  // Exemplo: acessando o nome do utilizador
                  Text(
                    "Utilizador: ${notificacao.utilizadorQueRealizaOpedido.fullName}",
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  // Se 'gender' for um int (0,1,2) ou algo similar, adapte aqui
                  Text("Gênero: ${notificacao.utilizadorQueRealizaOpedido.gender}"),
                  const SizedBox(height: 8),
                  // Caso 'oQuePretendeFazer' seja um enum, você pode exibir .name ou algo similar
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
                          // Implementar lógica de aceitar
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green[300],
                        ),
                        child: const Text("Aceitar"),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          // Implementar lógica de enviar mensagem
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue[300],
                        ),
                        child: const Text("Enviar Mensagem"),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          // Implementar lógica de recusar
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
