import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tinder_para_caes/screens/vizualizarAssociacaoScreen.dart';
import 'package:tinder_para_caes/models/associacao.dart';

import '../models/animal.dart';

class PassearCaoScreen extends StatefulWidget {
  final String uidAssociacao;
  const PassearCaoScreen({Key? key, required this.uidAssociacao}) : super(key: key);

  @override
  _PassearCaoScreenState createState() => _PassearCaoScreenState();
}

class _PassearCaoScreenState extends State<PassearCaoScreen> {
  final TextEditingController nomePasseadorController = TextEditingController();
  final TextEditingController moradaFiscalController = TextEditingController();
  final TextEditingController ccBiController = TextEditingController();
  final TextEditingController validadeCCController = TextEditingController();
  final TextEditingController tlmController = TextEditingController();
  final TextEditingController idadeController = TextEditingController();
  final TextEditingController matriculaVeiculoController = TextEditingController();
  final TextEditingController local = TextEditingController();

  bool aceitaRegras = false;
  String mensagemAdicional = "";
  List <Animal> opcoesDeAnimais = [];
  Animal? selectedDog ;

  @override
  void initState() {
    super.initState();
    _fetchAnimals();
  }

  Future<void> _submeterFormulario() async {
    try {
      final firestore = FirebaseFirestore.instance;
      final currentUser = FirebaseAuth.instance.currentUser;
      final String uidUtilizador = currentUser?.uid ?? "desconhecido";
      final String uidAnimal = "uidAnimal123";
      final String uidAssociacao = widget.uidAssociacao;

      final docRef = await firestore.collection("pedidosENotificacoes").add({
        "oQuePretendeFazer": "Ir passear um Cão",
        "utilizadorUid": uidUtilizador,
        "uidAssociacao": uidAssociacao,
        "confirmouTodosOsRequisitos": aceitaRegras,
        "mensagemAdicional": mensagemAdicional,
        "estado": "Pendente",
        "dataCriacao": FieldValue.serverTimestamp(),

        "dadosPreenchidos": {
          "Nome Completo": nomePasseadorController.text,
          "Morada Fiscal": moradaFiscalController.text,
          "Nmero de Cartão de Cidadão": ccBiController.text,
          "Validade do Cartão de Cidadão": validadeCCController.text,
          "Telemóvel": tlmController.text,
          "Matricula do Veiculo usado para Transporte": matriculaVeiculoController.text,
          "Local do Passeio": local.text,
          "Idade": int.tryParse(idadeController.text) ?? 0,
          "Nome do Cão": selectedDog?.fullName,

        },
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Pedido de passeio submetido com sucesso! ✅")),
      );

    } catch (e) {
      print("Erro ao submeter formulário: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erro ao submeter pedido! ❌")),
      );
    }
  }

  Future<void> _fetchAnimals() async {
    final snapshot = await FirebaseFirestore.instance.collection('associacao').get();
    final associacao = snapshot.docs
        .map((doc) => Associacao.fromFirestore(doc))
        .firstWhere((a) => a.uid == widget.uidAssociacao);

    if (associacao != null) {
      List<Animal> fetchedAnimals = await associacao.fetchAnimals(associacao.animais);
      setState(() {
        opcoesDeAnimais = fetchedAnimals;
      });
    }
  }

  //Dropdown do animal que quer escolher para apadrinhar
  Widget _buildDropdownAnimal() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: DropdownButtonFormField<Animal>(
        decoration: InputDecoration(labelText: "Escolha o animal que pretende passear",border: OutlineInputBorder()),
        value: selectedDog,
        items: opcoesDeAnimais.map((animal) {
          return DropdownMenuItem<Animal>(
            value: animal,
            child: Text("${animal.fullName} (${animal.breed}) - ${animal.calcularIdade()}"),
          );
        }).toList(),
        onChanged: (Animal? newAnimal) {
          setState(() {
            selectedDog = newAnimal!;
          });
        },
        menuMaxHeight: 400,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Passear Cão 🐶")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Text("📌 Dados Pessoais", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            TextField(controller: nomePasseadorController, decoration: InputDecoration(labelText: "Nome*")),
            SizedBox(height: 20),
            TextField(controller: moradaFiscalController, decoration: InputDecoration(labelText: "Morada Fiscal*")),
            SizedBox(height: 20),
            TextField(controller: ccBiController, decoration: InputDecoration(labelText: "CC/BI*")),
            SizedBox(height: 20),
            TextField(controller: validadeCCController, decoration: InputDecoration(labelText: "Data de Validade*")),
            SizedBox(height: 20),
            TextField(
              controller: tlmController,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(labelText: "Telemóvel*"),
            ),
            SizedBox(height: 20),
            TextField(
              controller: idadeController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: "Idade* (mínimo 18 anos)"),
            ),

            SizedBox(height: 20),
            Text("🐕 Escolha do Animal 🐈", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            _buildDropdownAnimal(),
            SizedBox(height: 20),

            Text("📍 Local onde se vai realizar o passeio", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            TextField(controller: local, decoration: InputDecoration(labelText: "Local onde o vai passear:")),
            SizedBox(height: 20),
            TextField(controller: matriculaVeiculoController, decoration: InputDecoration(labelText: "Matrícula do veículo:")),
            SizedBox(height: 20),

            Center(
              child: ElevatedButton(
                onPressed: () {
                  _mostrarPopupRegras();
                },
                child: Text("Submeter Formulário ✅"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _mostrarPopupRegras() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("📜 Termos e Responsabilidades"),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("O passeador compromete-se a cumprir determinadas regras durante o passeio:"),
                Text("✅ Nunca soltar o canídeo."),
                Text("✅ Não permitir que terceiros se aproximem sem autorização."),
                Text("✅ Manter a integridade física do canídeo e evitar perigos."),
                Text("✅ Apanhar os dejetos do canídeo."),
                Text("✅ Limitar o passeio a duas horas."),
                StatefulBuilder(
                  builder: (BuildContext context, StateSetter setStateDialog) {
                    return CheckboxListTile(
                      title: Text("Confirmo que li e aceito as regras."),
                      value: aceitaRegras,
                      tileColor: Colors.transparent,
                      onChanged: (bool? value) {
                        setState(() {
                          aceitaRegras = value!;
                        });
                        setStateDialog(() {}); //  Atualiza só o conteúdo do popup
                      },
                    );
                  },
                ),

              ],
            ),
          ),
          actions: [
            TextButton(
              child: Text("Cancelar ❌"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              onPressed: aceitaRegras
                  ? () async {
                Navigator.of(context).pop();
                _mostrarPopupFinal();

              }
                  : null,
              child: Text("Aceitar ✅"),
            ),

          ],
        );
      },
    );
  }

  //  Popup final com imagem e incentivo para tirar fotos
  void _mostrarPopupFinal() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        bool mostrarCampoMensagem = false;
        TextEditingController mensagemController = TextEditingController();

        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text("🐶 Pedido de Passeio Registado com Sucesso!"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(height: 10),
                  Text(
                    "📸 Lembra-te de tirar fotos do passeio!\nPodes enviá-las para partilhar a experiência.",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                  if (mostrarCampoMensagem)
                    Padding(
                      padding: const EdgeInsets.only(top: 16.0),
                      child: TextField(
                        controller: mensagemController,
                        maxLines: 4,
                        decoration: InputDecoration(
                          labelText: "Mensagem adicional",
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    setState(() {
                      mostrarCampoMensagem = !mostrarCampoMensagem;
                    });
                  },
                  child: Text(mostrarCampoMensagem ? "Esconder mensagem" : "Adicionar mensagem ✍️"),
                ),
                ElevatedButton(
                  onPressed: () async {
                    setState(() {
                      mensagemAdicional = mensagemController.text;
                    });
                    Navigator.of(context).pop(); // fecha popup
                    await _submeterFormulario(); // guarda os dados
                  },
                  child: Text("Submeter ✅"),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
