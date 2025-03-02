import 'package:flutter/material.dart';
import 'package:tinder_para_caes/models/utilizador.dart';
import 'package:tinder_para_caes/models/associacao.dart';

class Allpedidoslist {
  final Utilizador utilizadorQueRealizaOpedido;
  final String oQuePretendeFazer;
  final Associacao associacao;
  final bool confirmouTodosOsRequisitos;
  final String mensagemAdicional;

  Allpedidoslist({
    required this.utilizadorQueRealizaOpedido,
    required this.oQuePretendeFazer,
    required this.associacao,
    required this.confirmouTodosOsRequisitos,
    required this.mensagemAdicional,
  });
}

class AllPedidosList extends StatelessWidget {
  final List<Allpedidoslist> notificacoes;

  AllPedidosList({required this.notificacoes});

  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Notificações"),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(8.0),
        itemCount: notificacoes.length,
        itemBuilder: (context, index) {
          final notificacao = notificacoes[index];
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8.0),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Utilizador: ${notificacao.utilizadorQueRealizaOpedido}",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Text("Gênero: ${notificacao.utilizadorQueRealizaOpedido.gender}"),
                  SizedBox(height: 8),
                  Text("O que pretende fazer: ${notificacao.oQuePretendeFazer}"),
                  Text("Associação: ${notificacao.associacao.name}"),
                  Text("Confirmou requisitos: ${notificacao.confirmouTodosOsRequisitos ? "Sim" : "Não"}"),
                  SizedBox(height: 8),
                  Text("Mensagem Adicional: ${notificacao.mensagemAdicional}"),
                  SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          // Implementar lógica de aceitar
                        },
                        child: Text("Aceitar"),
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.green[300]),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          // Implementar lógica de enviar mensagem
                        },
                        child: Text("Enviar Mensagem"),
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.blue[300]),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          // Implementar lógica de recusar
                        },
                        child: Text("Recusar"),
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.red[300]),
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