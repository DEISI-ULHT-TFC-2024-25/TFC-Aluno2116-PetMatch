import 'package:flutter/material.dart';
import 'package:tinder_para_caes/models/associacao.dart';
import 'package:tinder_para_caes/screens/vizualizarAssociacaoScreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/animal.dart';

class TornarPadrinhoScreen extends StatefulWidget {
  final String uidAssociacao;

  const TornarPadrinhoScreen({super.key, required this.uidAssociacao});

  @override
  _TornarPadrinhoScreenState createState() => _TornarPadrinhoScreenState();
}


class _TornarPadrinhoScreenState extends State<TornarPadrinhoScreen> {
  final _formKey = GlobalKey<FormState>();
  bool aceitaRegras = false;
  String mensagemAdicional = "";
  List <Animal> opcoesDeAnimais = [];
  Animal? selectedDog ;

  // Controladores dos campos
  final TextEditingController nomeController = TextEditingController();
  final TextEditingController moradaController = TextEditingController();
  final TextEditingController codigoPostalController = TextEditingController();
  final TextEditingController localidadeController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController telemovelController = TextEditingController();


  // Dropdown de apadrinhamento
  List<String> opcoesApadrinhamento = ["Ajuda financeira", "Apoio com alimentação", "Custos veterinários", "Outro"];
  String selectedOpcao = "Ajuda financeira";

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


  @override
  void initState() {
    super.initState();
    _fetchAnimals();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("🐱 Tornar-se Padrinho 🐶"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("📌 Dados Pessoais", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              _buildTextField("Nome Completo", nomeController),
              _buildTextField("Morada", moradaController),
              _buildTextField("Código Postal", codigoPostalController),
              _buildTextField("Localidade", localidadeController),
              _buildTextField("E-mail", emailController),
              _buildTextField("Telemóvel", telemovelController),
              SizedBox(height: 20),

              Text("🐕 Escolha do Animal 🐈", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              _buildDropdownAnimal(),
              _buildDropdownApadrinhamento(),
              SizedBox(height: 20),

              CheckboxListTile(
                title: Text("Termos e condições"),
                subtitle: Text("Aceito partilhar os meus dados pessoais com a associação que estou a contactar\nAceito ser contactado pela associação"),
                value: aceitaRegras,
                onChanged: (bool? value) {
                  setState(() {
                    aceitaRegras = value ?? false;
                  });
                },
              ),

              SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate() && aceitaRegras) {
                      _mostrarPopupMensagemFinal();
                    }
                  },
                  child: Text("Submeter Pedido ✅"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Função para capturar dados dos campos de texto
  Widget _buildTextField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Por favor, preencha este campo';
          }
          return null;
        },
      ),
    );
  }

  /// Dropdown de tipo de apadrinhamento
  Widget _buildDropdownApadrinhamento() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(border: OutlineInputBorder()),
        value: selectedOpcao,
        items: opcoesApadrinhamento.map((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
        onChanged: (String? newValue) {
          setState(() {
            selectedOpcao = newValue!;
          });
        },
      ),
    );
  }

  //Dropdown do animal que quer escolher para apadrinhar
  Widget _buildDropdownAnimal() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: DropdownButtonFormField<Animal>(
        decoration: InputDecoration(labelText: "Escolha o animal que pretende apadrinhar",border: OutlineInputBorder()),
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

  /// Função para guardar no Firebase Firestore
  Future<void> _submeterFormulario() async {
    try {
      final firestore = FirebaseFirestore.instance;
      final currentUser = FirebaseAuth.instance.currentUser;

      final String uidUtilizador = currentUser?.uid ?? "desconhecido";
      final String uidAssociacao = widget.uidAssociacao;

      await firestore.collection("pedidosENotificacoes").add({
        "uidUtilizador": uidUtilizador,
        "oQuePretendeFazer": "Apadrinhamento de um animal",
        "uidAssociacao": uidAssociacao,
        "confirmouTodosOsRequisitos": aceitaRegras,
        "mensagemAdicional": mensagemAdicional,
        "estado": "pendente",
        "dataCriacao": FieldValue.serverTimestamp(),

        "dadosPreenchidos": {
          "Nome Completo": nomeController.text,
          "Morada": moradaController.text,
          "Código Postal": codigoPostalController.text,
          "Localidade": localidadeController.text,
          "Email": emailController.text,
          "Telemóvel": telemovelController.text,
          "Animal que pretende apadrinhar": selectedDog?.fullName,
          "Tipo de apadrinhamento": selectedOpcao,
        }
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Pedido submetido com sucesso! ✅")),
      );

    } catch (e) {
      print("Erro ao submeter pedido: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erro ao submeter pedido! ❌")),
      );
    }
  }

  /// Popup de confirmação após submissão
  void _mostrarPopupMensagemFinal() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        bool mostrarCampoMensagem = false;
        TextEditingController mensagemController = TextEditingController();

        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text("✨ Enviar Pedido de Apadrinhamento ✨"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text("Deseja adicionar uma mensagem adicional?"),
                  if (mostrarCampoMensagem)
                    Padding(
                      padding: const EdgeInsets.only(top: 12),
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
                    Navigator.of(context).pop();
                    await _submeterFormulario();
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
