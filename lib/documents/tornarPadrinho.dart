import 'package:flutter/material.dart';
import 'package:tinder_para_caes/screens/vizualizarAssociacaoScreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

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

  // Controladores dos campos
  final TextEditingController nomeController = TextEditingController();
  final TextEditingController moradaController = TextEditingController();
  final TextEditingController codigoPostalController = TextEditingController();
  final TextEditingController localidadeController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController telemovelController = TextEditingController();
  final TextEditingController nomeAnimalController = TextEditingController();

  // Dropdown de apadrinhamento
  List<String> opcoesApadrinhamento = ["Ajuda financeira", "Apoio com alimentação", "Custos veterinários", "Outro"];
  String selectedOpcao = "Ajuda financeira";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //leading: IconButton(
         // icon: Icon(Icons.arrow_back),
          //onPressed: () => Navigator.pushReplacement(
            //context,
            //MaterialPageRoute(builder: (context) => VizualizarAssociacaoScreen()),
          //),
        //),
        title: Text("Tornar-se Padrinho 🐶"),
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

              Text("🐕 Escolha do Animal", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              _buildTextField("Nome do Animal que deseja apadrinhar", nomeAnimalController),
              _buildDropdownApadrinhamento(),
              SizedBox(height: 20),

              CheckboxListTile(
                title: Text("Aceito os termos e condições"),
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
                      _mostrarPopupMensagemFinal(); // ← Mostra o popup com opção de mensagem
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Por favor, preencha todos os campos e aceite os termos. ❗")),
                      );
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
        "associacao": uidAssociacao,
        "confirmouTodosOsRequisitos": aceitaRegras,
        "mensagemAdicional": mensagemAdicional,
        "estado": "pendente",
        "dataCriacao": FieldValue.serverTimestamp(),

        "dadosPreenchidos": {
          "nomeCompleto": nomeController.text,
          "morada": moradaController.text,
          "codigoPostal": codigoPostalController.text,
          "localidade": localidadeController.text,
          "email": emailController.text,
          "telemovel": telemovelController.text,
          "nomeAnimal": nomeAnimalController.text,
          "tipoApadrinhamento": selectedOpcao,
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
              title: Text("✨ Enviar Pedido de Apadrinhamento"),
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
