import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tinder_para_caes/models/animal.dart';
import 'package:tinder_para_caes/screens/animalDetailsScreen.dart';
import 'package:tinder_para_caes/screens/adicionarAnimalScreen.dart';

import '../models/associacao.dart';
import '../models/utilizador.dart';

class AllAnimalsList extends StatefulWidget {
  final String uidAssociacao;
  final bool isAssociacao;
  final Associacao? associacao;
  final Utilizador? utilizador;
  

  const AllAnimalsList({
    super.key,
    required this.isAssociacao,
    required this.uidAssociacao,
    this.associacao,
    this.utilizador,
  });

  @override
  State<AllAnimalsList> createState() => _AllAnimalsListState();
}

class _AllAnimalsListState extends State<AllAnimalsList> {
  List<Animal?> animaisFiltrados = [];

  String? filtroEspecie;
  String? filtroGenero;
  String termoPesquisa = '';
  String filtroVisibilidade = 'Todos'; // Valor por defeito
  final TextEditingController _pesquisaController = TextEditingController();


  Future<void> _carregarAnimais() async {
    List<Animal> novaLista = [];

    if (widget.isAssociacao) {
      // Buscar dados atualizados da associação
      final doc = await FirebaseFirestore.instance
          .collection('associacao')
          .doc(widget.uidAssociacao)
          .get();
      final associacaoAtualizada = Associacao.fromFirestore(doc);
      novaLista = await associacaoAtualizada.fetchAnimals(associacaoAtualizada.animais);
    } else {
      // Utilizador ver os próprios animais
      if (widget.utilizador != null && widget.uidAssociacao.trim().isEmpty) {
        final doc = await FirebaseFirestore.instance
            .collection('utilizador')
            .doc(widget.utilizador!.uid)
            .get();
        final utilizadorAtualizado = Utilizador.fromFirestore(doc);
        novaLista = await utilizadorAtualizado.fetchAnimals(utilizadorAtualizado.osSeusAnimais);
      }
      // Utilizador ver animais de uma associação
      else if (widget.uidAssociacao.trim().isNotEmpty) {
        final doc = await FirebaseFirestore.instance
            .collection('associacao')
            .doc(widget.uidAssociacao)
            .get();
        final associacao = Associacao.fromFirestore(doc);
        novaLista = await associacao.fetchAnimals(associacao.animais);
      }
    }

    setState(() {
      animaisFiltrados = novaLista;
    });
  }


  bool filtrosAtivos() {
    return termoPesquisa.isNotEmpty || filtroEspecie != null || filtroGenero != null;
  }

  void aplicarFiltros() {
    setState(() {
      animaisFiltrados = animaisFiltrados.where((animal) {
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
  void initState() {
    super.initState();
    _carregarAnimais();
  }

  @override
  Widget build(BuildContext context) {
    final uidAtual = FirebaseAuth.instance.currentUser?.uid;
    bool isDono = true;
    if (animaisFiltrados.isNotEmpty && animaisFiltrados[0] != null) {
      isDono = animaisFiltrados[0]!.donoID == uidAtual;
    }

    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Scaffold(
      appBar: AppBar(
        title: Text("Todos os Animais"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context, true);
          },
        ),
      ),
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
                  final String? imagemPerfil = animal.imagens.isNotEmpty ? animal.imagens.first : null;
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // COLUNA DE TEXTO
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  animal.fullName,
                                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                                ),
                                SizedBox(height: 8),
                                Text("Idade: ${animal.calcularIdade()}"),
                                Text("Sexo: ${animal.gender}"),
                                Text("Castrado: ${animal.sterilized ? "Sim" : "Não"}"),
                                SizedBox(height: 12),
                                ElevatedButton.icon(
                                  onPressed: () async {
                                    final resultado = await Navigator.push<Map>(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => AnimalDetailsScreen(
                                          animal: animal,
                                          isAssoci: widget.isAssociacao,
                                          uidAssociacao: widget.uidAssociacao,
                                          origem: 'allAnimalsList', // identifica a origem
                                        ),
                                      ),
                                    );
                                    if (resultado?['apagado'] == true && resultado?['origem'] == 'allAnimalsList') {
                                      await _carregarAnimais();
                                    }
                                  },
                                  icon: Icon(Icons.info_outline),
                                  label: Text("Ver mais informações"),
                                ),
                              ],
                            ),
                          ),

                          // ESPAÇO ENTRE TEXTO E IMAGEM
                          SizedBox(width: 12),

                          // IMAGEM
                          Container(
                            width: 100,
                            height: 120,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              image: imagemPerfil != null
                                  ? DecorationImage(
                                image: NetworkImage(imagemPerfil),
                                fit: BoxFit.cover,
                              )
                                  : null,
                              color: theme.primaryColor,
                            ),
                            child: imagemPerfil == null
                                ? Center(
                              child: Image.asset(
                                animal.species == 'Cão'
                                    ? 'assets/iconCao.png'
                                    : animal.species == 'Gato'
                                    ? 'assets/iconGato.png'
                                    : 'assets/iconPatinhaGeral.png',
                                  fit: BoxFit.cover,
                              ),
                            )
                                : null, // Isto evita erro quando imagem existe
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

      // o dono dos animais podem adicionar animais neste screen
      floatingActionButton: isDono
          ? FloatingActionButton(
        onPressed: () async {
          final resultado = await Navigator.push(context,MaterialPageRoute(builder: (context) => AdicionarAnimalScreen()));
          if (resultado == true) {
            await _carregarAnimais(); // recarrega lista
          }
        },
        tooltip: "Adicionar Animal",
        child: const Icon(Icons.add, size: 30),
      )
          : null,
    );
  }
}
