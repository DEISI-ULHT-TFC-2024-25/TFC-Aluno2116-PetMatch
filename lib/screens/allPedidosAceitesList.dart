import 'package:flutter/material.dart';
import 'package:tinder_para_caes/models/associacao.dart';
import 'package:tinder_para_caes/models/pedido.dart';

class AllPedidosAceitesList extends StatefulWidget {
  final List<Pedido> pedidos;
  const AllPedidosAceitesList({super.key, required this.pedidos});

  @override
  State<AllPedidosAceitesList> createState() => _AllPedidosAceitesListState();
}

class _AllPedidosAceitesListState extends State<AllPedidosAceitesList> {
  Map<String, bool> _expandedStates = {}; // controla se o card está expandido

  List<Pedido?> pedidosFiltrados = [];
  String nomeAssociacao = "";
  String? filtroTipo;
  DateTime? filtroData;
  String? filtroDataTexto;
  String termoPesquisa = ''; //nome
  final TextEditingController _pesquisaController = TextEditingController();

  void _toggleExpanded(String pedidoId) {
    setState(() {
      _expandedStates[pedidoId] = !(_expandedStates[pedidoId] ?? false);
    });
  }

  @override
  void initState() {
    super.initState();
    pedidosFiltrados = widget.pedidos;
  }

  bool filtrosAtivos() {
    return termoPesquisa.isNotEmpty || filtroData != null || filtroTipo != null;
  }

  void aplicarFiltros() {
    setState(() {
      pedidosFiltrados = widget.pedidos.where((pedido) {
        final nomeMatch = pedido.dadosPrenchidos['Nome Completo'].toLowerCase().contains(termoPesquisa.toLowerCase());
        final dataMatch = filtroData == null || pedido.dataCriacao.isAfter(filtroData!) || pedido.dataCriacao.isAtSameMomentAs(filtroData!);
        final tipoMatch = filtroTipo == null || pedido.funcionalidade == filtroTipo;
        return nomeMatch && dataMatch && tipoMatch;
      }).toList();
    });
  }

  void limparFiltros() {
    setState(() {
      termoPesquisa = '';
      filtroTipo = null;
      filtroData = null;
      _pesquisaController.clear();
      aplicarFiltros();
    });
  }



  @override
  Widget build(BuildContext context) {
    final pedidos = widget.pedidos;
    if (pedidos == null) {
      return Scaffold(
        appBar: AppBar(title: Text("Pedidos aceites")),
        body: Center(child: Text("Nenhum pedido aceite.")),
      );
    }

    return Scaffold(
        appBar: AppBar(title: Text("Pedidos aceites"),),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(

            children: [
              // Campo de pesquisa
              TextField(
                controller: _pesquisaController,
                decoration: InputDecoration(
                  labelText: "Pesquisar por nome da associação",
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  termoPesquisa = value;
                  aplicarFiltros();
                },
              ),
              SizedBox(height: 8),

              // Filtro de Tipo
              SizedBox(
                width: double.infinity,
                child: DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    labelText: "Filtrar por tipo de pedido",
                    border: OutlineInputBorder(),
                  ),
                  value: filtroTipo,
                  items: [
                    "Ir passear um Cão",
                    "Tornar-se Voluntario",
                    "Tornar-se Sócio",
                    "Apadrinhamento de um animal",
                    "Tornar-se em Família de Acolhimento Temporária",
                  ].map((tipo) {
                    return DropdownMenuItem(value: tipo, child: Text(tipo, style: TextStyle(fontSize : 14)));
                  }).toList(),
                  onChanged: (value) {
                    filtroTipo = value;
                    aplicarFiltros();
                  },
                ),
              ),
              SizedBox(height: 8),

              // Filtro de Data
              SizedBox(
                width: double.infinity,
                child: DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    labelText: "Filtrar por data",
                    border: OutlineInputBorder(),
                  ),
                  value: filtroDataTexto,
                  items: ["Hoje", "Últimos 7 dias", "Este mês", "Este ano"].map((texto) {
                    return DropdownMenuItem(value: texto, child: Text(texto));
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      filtroDataTexto = value;
                      // Converter o texto para uma data
                      if (value == "Hoje") {
                        filtroData = DateTime.now();
                      } else if (value == "Últimos 7 dias") {
                        filtroData = DateTime.now().subtract(Duration(days: 7));
                      } else if (value == "Este mês") {
                        filtroData = DateTime.now().subtract(Duration(days: 31));
                      } else if (value == "Este ano") {
                        filtroData = DateTime.now().subtract(Duration(days: 365));
                      }
                    });
                    aplicarFiltros();
                  },
                ),
              ),

              //limpar filtros
              if (filtrosAtivos()) ...[
                SizedBox(height: 8),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton.icon(
                    onPressed: limparFiltros,
                    icon: Icon(Icons.clear),
                    label: Text("Limpar Filtros"),
                  ),
                ),
              ],
              SizedBox(height: 8),

              //lista de pedidos
              Expanded(
                child: pedidosFiltrados.isEmpty ? Center(child: Text("Nenhum pedido encontrado."))
                    : ListView.builder(
                  itemCount: pedidosFiltrados.length,
                  itemBuilder: (context, index) {
                    final pedido = pedidosFiltrados[index]!;
                    final isExpanded = _expandedStates[pedido.id] ?? false;

                    return Card(
                      color: Theme.of(context).cardColor,
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
                                    "Associação: ${Associacao.getNomeAssociacao(pedido.uidAssociacao)}",
                                    softWrap: true,
                                    overflow: TextOverflow.fade,
                                    maxLines: 3, // Limita o número de linhas
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
                            Text("Estado atual: ${pedido.estado}"),
                            Text("Data em que foi realizado: ${pedido.dataCriacao.toString().split(' ')[0]}"),

                            if (isExpanded) ...[
                              SizedBox(height: 8),
                              Text("Mensagem do Utilizador: ${pedido.mensagemAdicional ?? "Sem detalhes"}"),
                              SizedBox(height: 8),
                              for (var entry in pedido.dadosPrenchidos.entries)
                                if (entry.value is Map)
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text('•${entry.key}:'),
                                      for (var subEntry in (entry.value as Map).entries)
                                        Text('• ${subEntry.key}: ${subEntry.value}'),
                                    ],
                                  )
                                else if (entry.value is List && (entry.value as List).isNotEmpty)
                                  Text('• ${entry.key}: ${(entry.value as List).join(", ")}')
                                else if (entry.value is bool)
                                    if (entry.value == true)
                                      Text('• ${entry.key}: Sim')
                                    else
                                      Text('• ${entry.key}: Não')
                                  else
                                    Text('• ${entry.key}: ${entry.value}'),
                            ],
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),

        )
    );
  }
}
