
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tinder_para_caes/models/animal.dart';
import 'package:tinder_para_caes/models/pedido.dart';
import 'package:tinder_para_caes/screens/allAnimalsList.dart';
import 'package:tinder_para_caes/screens/adicionarAnimalScreen.dart';
import 'package:provider/provider.dart';
import 'package:tinder_para_caes/firebaseLogic/associacaoProvider.dart';
import 'package:tinder_para_caes/screens/allPedidosList.dart';

class AssociacaoHomeScreen extends StatefulWidget {
  const AssociacaoHomeScreen({super.key});

  @override
  _AssociacaoHomeScreenState createState() => _AssociacaoHomeScreenState();
}

class _AssociacaoHomeScreenState extends State<AssociacaoHomeScreen> {
  List<Animal> animais = []; // Store fetched animals
  bool isLoading = true;// Track loading state
  List<Pedido> pedidos = [];

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

      // Converte os documentos em objetos Pedido (assumindo que tens um fromFirestore)
      List<Pedido> fetchedPedidos = documentos.map((doc) {
        return Pedido.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();

      setState(() {
        pedidos = fetchedPedidos;
        isLoading = false;
      });
    } catch (e) {
      print("Erro ao buscar pedidos: $e");
      setState(() {
        isLoading = false;
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    final associacao = Provider.of<AssociacaoProvider>(context).association;


    if (associacao == null || isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Home Page - ${associacao.name}",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, decoration: TextDecoration.none),
              ),
              SizedBox(height: 16.0),
              Text("Pedidos:", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, decoration: TextDecoration.none)),
              SizedBox(height: 20.0),

              // Notifications List
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: pedidos.length > 3 ? 3 : pedidos.length,
                itemBuilder: (context, index) {
                  final pedido = pedidos[index];
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 4.0, horizontal: 4.0),
                    child: ListTile(

                      title: Text("Pedido de: ${pedido.dadosPrenchidos['nomeCompleto']}"),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Animal: ${pedido.animalId}", maxLines: 2, overflow: TextOverflow.ellipsis),
                          Text("Pretende: ${pedido.funcionalidade}"),
                        ],
                      ),
                    ),
                  );
                },
              ),

              SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => AllPedidosList(pedidos: pedidos)));
                },
                child: Text("Ver todos os pedidos pendentes"),
              ),

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
                padding: const EdgeInsets.all(8.0),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 8.0,
                  mainAxisSpacing: 8.0,
                  childAspectRatio: 1,
                ),
                itemCount: animais.length> 9? 9: animais.length,
                itemBuilder: (context, index) {
                  return Card(
                    color: Colors.brown[300],
                    child: Center(
                      child: Text(
                        animais[index].fullName,
                        style: TextStyle(color: Colors.white, fontSize: 16),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  );
                },
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AllAnimalsList(animais: animais, isAssociacao: true, uidAssociacao: associacao.uid),
                    ),
                  );
                },
                child: Text("Ver Animais"),
              ),

              Padding(
                padding: const EdgeInsets.all(4.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => AdicionarAnimalScreen()));
                      },
                      child: Text("Adicionar Animal"),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        // Implementar ação para "Editar necessidades"
                      },
                      child: Text("Editar necessidades"),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
