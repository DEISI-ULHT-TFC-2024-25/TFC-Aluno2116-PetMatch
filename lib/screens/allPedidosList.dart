import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tinder_para_caes/firebaseLogic/associacaoProvider.dart';
import 'package:tinder_para_caes/models/pedido.dart';

class AllPedidosList extends StatefulWidget {
  final List<Pedido> pedidos;

  const AllPedidosList({super.key, required this.pedidos});

  @override
  State<AllPedidosList> createState() => _AllPedidosListState();
}

class _AllPedidosListState extends State<AllPedidosList> {
  @override
  Widget build(BuildContext context) {
    final associacao = Provider.of<AssociacaoProvider>(context).association;

    if (associacao == null) {
      return Scaffold(
        appBar: AppBar(title: Text("Notificações")),
        body: Center(child: Text("Nenhuma associação carregada.")),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Notificações"),
        backgroundColor: Colors.brown[400],
      ),
      backgroundColor: Colors.brown[100], // fundo do ecrã
      body: ListView.builder(
        padding: EdgeInsets.all(8),
        itemCount: widget.pedidos.length,
        itemBuilder: (context, index) {
          final pedido = widget.pedidos[index];

          return Card(
            color: Colors.white, // fundo branco no card
            elevation: 3,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            margin: EdgeInsets.symmetric(vertical: 8),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Utilizador: ${pedido.utilizadorId}",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  Text("Pretende: ${pedido.funcionalidade}"),
                  Text("Associação: ${pedido.associacaoId}"),
                  Text("Estado atual: ${pedido.estado}"),
                  SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    alignment: WrapAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () async {
                          await pedido.atualizarEstadoNoFirestore("Aceite");
                          setState(() {});
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green[300],
                        ),
                        child: Text("Aceitar"),
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          await pedido.atualizarEstadoNoFirestore("Pendente");
                          setState(() {});
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue[300],
                        ),
                        child: Text("Enviar Mensagem"),
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          await pedido.atualizarEstadoNoFirestore("Recusado");
                          setState(() {});
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red[300],
                        ),
                        child: Text("Recusar"),
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
