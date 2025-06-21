import 'package:flutter/material.dart';
import 'package:tinder_para_caes/models/associacao.dart';
import 'package:tinder_para_caes/screens/vizualizarAssociacaoScreen.dart';

class AllAssociacoesList extends StatefulWidget {
  const AllAssociacoesList({super.key, required this.associacoes});

  final List<Associacao> associacoes;
  @override
  _AllAssociacoesListState createState() => _AllAssociacoesListState();
}

class _AllAssociacoesListState extends State<AllAssociacoesList> {
  late List<Associacao> associacaoFiltradas;
  String? filtroLocalidade;
  String termoPesquisa = '';
  final TextEditingController _pesquisaController = TextEditingController();

  @override
  void initState() {
    super.initState();
    associacaoFiltradas = widget.associacoes;
  }

  bool filtrosAtivos() {
    return termoPesquisa.isNotEmpty || filtroLocalidade != null;
  }

  void aplicarFiltros() {
    setState(() {
      associacaoFiltradas = widget.associacoes.where((associacao) {
        final nomeMatch = associacao.name.toLowerCase().contains(termoPesquisa.toLowerCase());
        final localidadeMatch = filtroLocalidade == null || associacao.distrito == filtroLocalidade;

        return nomeMatch && localidadeMatch;
      }).toList();
    });
  }

  void limparFiltros() {
    setState(() {
      termoPesquisa = '';
      filtroLocalidade = null;
      _pesquisaController.clear();
      aplicarFiltros();
    });
  }

  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Todas as Associações"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            //Campo de pesquisa
            TextField(
              controller: _pesquisaController,
              decoration: InputDecoration(
                labelText: "Pesquisar por nome",
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                termoPesquisa = value;
                aplicarFiltros();
              },
            ),
            SizedBox(height: 8),

            //Dropdown de filtro por localidade
            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                labelText: "Filtrar por Distrito",
                border: OutlineInputBorder(),
              ),
              value: filtroLocalidade,
              items: [
                null,
                ...widget.associacoes.map((a) => a.distrito).toSet()
              ].map((local) {
                return DropdownMenuItem(
                  value: local,
                  child: Text(local ?? "Todas"),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  filtroLocalidade = value;
                  aplicarFiltros();
                });
              },
            ),
            SizedBox(height: 8),

            //Botão de limpar filtros
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: limparFiltros,
                child: Text("Limpar filtros"),
              ),
            ),

            //Lista de associações filtradas
            Expanded(
              child: ListView.builder(
                itemCount: associacaoFiltradas.length,
                itemBuilder: (context, index) {
                  final associacao = associacaoFiltradas[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            associacao.name,
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 8),
                          Text("Distrito: ${associacao.distrito}"),
                          Text("Localidade: ${associacao.localidade}"),
                          Text("Número de Animais: ${associacao.animais.length}"),
                          Text("Tarefas Necessárias:\n"
                              "${associacao.funcionalidades.map((f) => "  • $f").join("\n")}",
                            style: TextStyle(fontSize: 16),
                          ),
                          SizedBox(height: 12),
                          ElevatedButton.icon(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => VizualizarAssociacaoScreen(associacao: associacao),
                                ),
                              );
                            },
                            icon: Icon(Icons.visibility),
                            label: Text("Ver mais informações"),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

}
