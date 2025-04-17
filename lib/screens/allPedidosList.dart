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
  Map<String, bool> _expandedStates = {}; // controla se o card está expandido

  void _toggleExpanded(String pedidoId) {
    setState(() {
      _expandedStates[pedidoId] = !(_expandedStates[pedidoId] ?? false);
    });
  }

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
      backgroundColor: Colors.brown[100],
      body: ListView.builder(
        padding: EdgeInsets.all(8),
        itemCount: widget.pedidos.length,
        itemBuilder: (context, index) {
          final pedido = widget.pedidos[index];
          final isExpanded = _expandedStates[pedido.id] ?? false;

          return Card(
            color: Colors.white,
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
                  // Topo com info básica e botão de expandir
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          "Utilizador: ${pedido.utilizadorId}",
                          softWrap: true,
                          overflow: TextOverflow.fade,
                          maxLines: 3, // Limita o número de linhas se quiseres
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ),
                      IconButton(
                        icon: Icon(isExpanded
                            ? Icons.keyboard_arrow_up
                            : Icons.keyboard_arrow_down),
                        onPressed: () => _toggleExpanded(pedido.id),
                      ),
                    ],
                  ),



                  Text("Pretende: ${pedido.funcionalidade}"),
                  Text("Associação: ${pedido.associacaoId}"),
                  Text("Estado atual: ${pedido.estado}"),


                  if (isExpanded) ...[
                    SizedBox(height: 8),
                    Text("Detalhes: ${pedido.mensagemAdicional ?? "Sem detalhes"}"),
                    // Podes adicionar mais campos aqui conforme o modelo Pedido
                  ],

                  SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    alignment: WrapAlignment.start,
                    children: [
                      SizedBox(
                        width: 110,
                        child: ElevatedButton(
                          onPressed: () async {
                            await pedido.atualizarEstadoNoFirestore("Aceite");
                            setState(() {});
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green[200],
                          ),
                          child: Text("Aceitar", textAlign: TextAlign.center),
                        ),
                      ),
                      SizedBox(
                        width: 130,
                        child: ElevatedButton(
                          onPressed: () async {
                            await pedido.atualizarEstadoNoFirestore("Pendente");
                            setState(() {});
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue[200],
                          ),
                          child: Text("Enviar Mensagem", textAlign: TextAlign.center),
                        ),
                      ),
                      SizedBox(
                        width: 110,
                        child: ElevatedButton(
                          onPressed: () async {
                            await pedido.atualizarEstadoNoFirestore("Recusado");
                            setState(() {});
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red[200],
                          ),
                          child: Text("Recusar", textAlign: TextAlign.center),
                        ),
                      ),
                    ],
                  )

                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
