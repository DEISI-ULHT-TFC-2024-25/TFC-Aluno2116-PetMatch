import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tinder_para_caes/models/animal.dart';
import 'package:tinder_para_caes/models/pedido.dart';
import 'package:tinder_para_caes/screens/allAnimalsList.dart';
import 'package:tinder_para_caes/screens/adicionarAnimalScreen.dart';
import 'package:provider/provider.dart';
import 'package:tinder_para_caes/firebaseLogic/associacaoProvider.dart';
import 'package:tinder_para_caes/screens/allPedidosList.dart';
import 'package:tinder_para_caes/screens/animalDetailsScreen.dart';
import 'package:tinder_para_caes/screens/loginScreen.dart';

import 'package:tinder_para_caes/screens/editarFuncionalidades.dart';
import 'package:tinder_para_caes/screens/editarPerfilAssociação.dart';

class AssociacaoHomeScreen extends StatefulWidget {
  const AssociacaoHomeScreen({super.key});

  @override
  _AssociacaoHomeScreenState createState() => _AssociacaoHomeScreenState();
}

class _AssociacaoHomeScreenState extends State<AssociacaoHomeScreen> {
  List<Animal> animais = []; // Store fetched animals
  bool isLoading = true;// Track loading state
  List<Pedido> pedidos = [];
  int numberOfAnimals = 0;

  @override
  void initState() {
    super.initState();
    _fetchAnimals();
    _fetchPedidos();
  }

  Future<void> _fetchAnimals() async {
    final associacao = Provider.of<AssociacaoProvider>(context, listen: false).association;

    if (associacao != null) {
      List<Animal> fetchedAnimals = await associacao.fetchAnimals(associacao.animais);
      setState(() {
        animais = fetchedAnimals;
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _fetchPedidos() async {
    final associacao = Provider.of<AssociacaoProvider>(context, listen: false).association;

    if (associacao == null) {
      setState(() {
        isLoading = false;
      });
      return;
    }

    try {
      final firestore = FirebaseFirestore.instance;

      // Obtem todos os pedidos com associacao == UID da associação logada
      final querySnapshot = await firestore
          .collection("pedidosENotificacoes")
          .where("associacao", isEqualTo: associacao.uid)
          .get();

      // Extrai lista de documentos
      final documentos = querySnapshot.docs;

      // Extrai os IDs e guarda na associação
      List<String> idsPedidos = documentos.map((doc) => doc.id).toList();
      associacao.pedidosRealizados = idsPedidos;

      // Converte os documentos em objetos Pedido
      List<Pedido> fetchedPedidos = documentos.map((doc) {
        return Pedido.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();

      setState(() {
        pedidos = fetchedPedidos;
        isLoading = false;
      });
    } catch (e) {
      print("Erro nos pedidos: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  void _mostrarPopupConfirmarTerminarSessao(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text("Tem a certeza que pretende terminar sessão?"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text("Esta ação irá terminar a sua sessão atual."),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context); // Fecha sem fazer nada
                  },
                  child: Text("Cancelar"),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const LoginScreen()),
                    );
                  },
                  child: Text("Terminar"),
                ),
              ],
            );
          },
        );
      },
    );
  }



  @override
  Widget build(BuildContext context) {
    final associacao = Provider.of<AssociacaoProvider>(context).association;
    numberOfAnimals = associacao!.animais.length;


    if (associacao == null || isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(associacao.name),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              _mostrarPopupConfirmarTerminarSessao(context);
            },
          ),
        ],
      ),

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 16.0),
              Text("Pedidos:", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, decoration: TextDecoration.none)),
              SizedBox(height: 10.0),

              // Notifications List
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: pedidos.length > 2 ? 2 : pedidos.length,
                itemBuilder: (context, index) {
                  final pedido = pedidos[index];
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 4.0, horizontal: 4.0),
                    child: ListTile(

                      title: Text("Pedido de: ${pedido.dadosPrenchidos['nomeCompleto']}"),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Animal: ${pedido.utilizadorUid}", maxLines: 2, overflow: TextOverflow.ellipsis),
                          Text("Pretende: ${pedido.funcionalidade}"),
                        ],
                      ),
                    ),
                  );
                },
              ),

              SizedBox(height: 16.0),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => AllPedidosList(pedidos: pedidos)));
                  },
                  child: Text("Ver todos os pedidos pendentes (${pedidos.length})"),
                ),
              ),
              SizedBox(height: 20.0),

              // Animals Section
              Text(
                "Os seus patudos visíveis ao público",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, decoration: TextDecoration.none),
              ),
              SizedBox(height: 20.0),

              // Animals Grid
              GridView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),

                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 0.0,
                  mainAxisSpacing: 0.0,
                  childAspectRatio: 0.8,
                ),
                itemCount: animais.length> 9? 9: animais.length,
                itemBuilder: (context, index) {
                  final animal = animais[index];
                  String uidAssociacao = associacao?.uid ?? ''  ;
                  return InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AnimalDetailsScreen(animal: animal, isAssoci:true, uidAssociacao: uidAssociacao ),
                          ),
                        );
                      },
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: Column(
                          children: [
                            Image.asset(
                                animal.species == 'Cão' ? 'assets/iconCao.png':
                                animal.species == 'Gato' ? 'assets/iconGato.png':
                                'assets/iconPatinhaGeral.png'
                            ),
                            Text(animal.fullName),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),

              SizedBox(height: 8.0),

              Padding(
                padding: const EdgeInsets.all(4.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => AllAnimalsList(animais: animais, isAssociacao: true, uidAssociacao: associacao.uid)));
                      },
                      child: Text("Ver Todos ($numberOfAnimals)"),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => AdicionarAnimalScreen()));
                      },
                      child: Text("Adicionar Animal"),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20.0),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditarPerfilAssociacao(),
                      ),
                    );
                  },
                  child: Text("Editar Perfil"),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
