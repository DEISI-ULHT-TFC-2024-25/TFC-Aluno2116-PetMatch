import 'package:flutter/material.dart';
import 'package:tinder_para_caes/models/animal.dart';
import 'package:tinder_para_caes/screens/animalDetailsScreen.dart';
import 'package:tinder_para_caes/screens/adicionarAnimalScreen.dart';

class AllAnimalsList extends StatefulWidget {
  final String uidAssociacao;
  final List<Animal?> animais;
  final bool isAssociacao;

  const AllAnimalsList({
    super.key,
    required this.animais,
    required this.isAssociacao,
    required this.uidAssociacao,
  });

  @override
  State<AllAnimalsList> createState() => _AllAnimalsListState();
}

class _AllAnimalsListState extends State<AllAnimalsList> {
  List<Animal?> animaisFiltrados = [];

  String? filtroEspecie;
  String? filtroGenero;
  String termoPesquisa = '';
  String filtroVisibilidade = 'Visíveis'; // Valor por defeito



  final TextEditingController _pesquisaController = TextEditingController();

  @override
  void initState() {
    super.initState();
    animaisFiltrados = widget.animais;
  }

  bool filtrosAtivos() {
    return termoPesquisa.isNotEmpty || filtroEspecie != null || filtroGenero != null;
  }

  void aplicarFiltros() {
    setState(() {
      animaisFiltrados = widget.animais.where((animal) {
        if (animal == null) return false;

        final nomeMatch = animal.fullName.toLowerCase().contains(termoPesquisa.toLowerCase());
        final especieMatch = filtroEspecie == null || animal.species == filtroEspecie;
        final generoMatch = filtroGenero == null || animal.gender == filtroGenero;

        bool visibilidadeMatch;
        if (filtroVisibilidade == 'Todos') {
          visibilidadeMatch = true;
        } else if (filtroVisibilidade == 'Visíveis') {
          visibilidadeMatch = animal.visivel == true;
        } else {
          visibilidadeMatch = animal.visivel == false;
        }

        return nomeMatch && especieMatch && generoMatch && visibilidadeMatch;
      }).toList();
    });
  }


  void limparFiltros() {
    setState(() {
      termoPesquisa = '';
      filtroEspecie = null;
      filtroGenero = null;
      filtroVisibilidade = 'Visíveis';
      _pesquisaController.clear();
      aplicarFiltros();
    });
  }


  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Scaffold(
      appBar: AppBar(title: Text("Todos os Animais")),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            // Campo de pesquisa
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

            // Filtro de espécie
            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                labelText: "Filtrar por espécie",
                border: OutlineInputBorder(),
              ),
              value: filtroEspecie,
              items: [
                "Cão",
                "Gato",
                "Aves",
                "Chinchilas",
                "Porquinhos da Índia",
                "Cavalos",
                "Ovelhas",
                "Hamsters"
              ].map((especie) {
                return DropdownMenuItem(value: especie, child: Text(especie));
              }).toList(),
              onChanged: (value) {
                filtroEspecie = value;
                aplicarFiltros();
              },
            ),
            SizedBox(height: 8),

            // Filtro de género
            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                labelText: "Filtrar por género",
                border: OutlineInputBorder(),
              ),
              value: filtroGenero,
              items: ["Feminino", "Masculino"].map((genero) {
                return DropdownMenuItem(value: genero, child: Text(genero));
              }).toList(),
              onChanged: (value) {
                filtroGenero = value;
                aplicarFiltros();
              },
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

            //filtrar se for associacao por visibilidade
            if (widget.isAssociacao) ...[
              SizedBox(height: 8),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: "Filtrar por visibilidade",
                  border: OutlineInputBorder(),
                ),
                value: filtroVisibilidade,
                items: ["Visíveis", "Não Visíveis", "Todos"].map((opcao) {
                  return DropdownMenuItem(value: opcao, child: Text(opcao));
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    filtroVisibilidade = value!;
                    aplicarFiltros();
                  });
                },
              ),
            ],

            // Lista de animais
            Expanded(
              child: animaisFiltrados.isEmpty
                  ? Center(child: Text("Nenhum animal encontrado."))
                  : ListView.builder(
                itemCount: animaisFiltrados.length,
                itemBuilder: (context, index) {
                  final animal = animaisFiltrados[index]!;
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            animal.fullName,
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 8),
                          Text("Idade: ${animal.age} anos"),
                          Text("Sexo: ${animal.gender}"),
                          Text("Castrado: ${animal.sterilized ? "Sim" : "Não"}"),
                          Text("Número de Passeios: ${animal.numeroDePasseiosDados}"),
                          SizedBox(height: 12),
                          ElevatedButton.icon(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => AnimalDetailsScreen(
                                    animal: animal,
                                    isAssoci: widget.isAssociacao,
                                    uidAssociacao: widget.uidAssociacao,
                                  ),
                                ),
                              );
                            },
                            icon: Icon(Icons.info_outline),
                            label: Text("Ver mais informações 👀"),
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

      // Apenas Associações podem adicionar animais
      floatingActionButton: widget.isAssociacao
          ? FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AdicionarAnimalScreen(),
            ),
          );
        },
        tooltip: "Adicionar Animal",
        child: const Icon(Icons.add, size: 30),
      )
          : null,
    );
  }
}
