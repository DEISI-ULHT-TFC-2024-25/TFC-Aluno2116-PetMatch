import 'package:flutter/material.dart';
import 'package:tinder_para_caes/models/pedido.dart';

class AllPedidosAceitesList extends StatefulWidget {
  final List<Pedido> pedidos;
  const AllPedidosAceitesList({super.key, required this.pedidos});

  @override
  State<AllPedidosAceitesList> createState() => _AllPedidosAceitesListState();
}

class _AllPedidosAceitesListState extends State<AllPedidosAceitesList> {
  Map<String, bool> _expandedStates = {}; // controla se o card está expandido

  void _toggleExpanded(String pedidoId) {
    setState(() {
      _expandedStates[pedidoId] = !(_expandedStates[pedidoId] ?? false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Pedidos Aceites"),
      ),
      body: widget.pedidos.isEmpty
          ? Center(child: Text("Não existem pedidos aceites."))
          : ListView.builder(
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
                          "Utilizador: ${pedido.dadosPrenchidos['nomeCompleto'] ?? 'Desconhecido'}",
                          softWrap: true,
                          overflow: TextOverflow.fade,
                          maxLines: 3,
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
                  Text("Estado: ${pedido.estado}"),

                  if (isExpanded) ...[
                    SizedBox(height: 8),
                    Text("Mensagem: ${pedido.mensagemAdicional ?? "Sem mensagem adicional"}"),
                    for (var entry in pedido.dadosPrenchidos.entries)
                      Text('${entry.key}: ${entry.value}'),
                  ],
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
