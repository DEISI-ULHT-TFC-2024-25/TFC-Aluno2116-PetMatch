
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

  List<Pedido?> pedidosFiltrados = [];
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
    final associacao = Provider.of<AssociacaoProvider>(context).association;
    if (associacao == null) {
      return Scaffold(
        appBar: AppBar(title: Text("Notificações")),
        body: Center(child: Text("Nenhuma associação carregada.")),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text("Pedidos"),),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(

          children: [
            // Campo de pesquisa
            TextField(
              controller: _pesquisaController,
              decoration: InputDecoration(
                labelText: "Pesquisar por nome do utilizador que fez o pedido",
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
                                  "Utilizador: ${pedido.dadosPrenchidos['Nome Completo']}",
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

                          //botoes de aceitar recusar e enviar mensagem
                          SizedBox(height: 12),
                          Wrap(
                            spacing: 4,
                            runSpacing: 4,
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
                                width: 120,
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
            ),
          ],
        ),

      )
    );
  }
}
