import 'package:flutter/material.dart';
import 'package:tinder_para_caes/screens/vizualizarAssociacaoScreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class TornarPadrinhoScreen extends StatefulWidget {
  @override
  _TornarPadrinhoScreenState createState() => _TornarPadrinhoScreenState();
}

class _TornarPadrinhoScreenState extends State<TornarPadrinhoScreen> {
  final _formKey = GlobalKey<FormState>();
  bool aceitaRegras = false;

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
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => VizualizarAssociacaoScreen()),
          ),
        ),
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
                  onPressed: () async {
                    if (_formKey.currentState!.validate() && aceitaRegras) {
                      await _submeterFormulario(); // Salva no Firestore
                      _mostrarPopupConfirmacao(); // Mostra o popup após salvar
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

  /// Função para salvar no Firebase Firestore
  Future<void> _submeterFormulario() async {
    try {
      // Obtém o ID do utilizador autenticado
      String uidAssociacao = FirebaseAuth.instance.currentUser?.uid ?? "desconhecido";

      // Referência ao Firestore
      FirebaseFirestore firestore = FirebaseFirestore.instance;

      // Criar um novo pedido na subcoleção "apadrinhar"
      await firestore
          .collection("pedidoENotificacoes") // 📂 Coleção principal
          .doc(uidAssociacao) // 📄 Documento do utilizador
          .collection("apadrinhar") // 📂 Subcoleção específica
          .add({
        "nomeCompleto": nomeController.text,
        "morada": moradaController.text,
        "codigoPostal": codigoPostalController.text,
        "localidade": localidadeController.text,
        "email": emailController.text,
        "telemovel": telemovelController.text,
        "nomeAnimal": nomeAnimalController.text,
        "tipoApadrinhamento": selectedOpcao,
        "status": "pendente", // Pedido começa como "pendente"
        "dataCriacao": FieldValue.serverTimestamp(), // Timestamp automático
      });

      // Mensagem de sucesso
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
  void _mostrarPopupConfirmacao() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("🎉 Pedido de Apadrinhamento Confirmado!"),
          content: Text("Obrigado por querer ajudar! Em breve, entraremos em contacto."),
          actions: [
            TextButton(
              child: Text("Fechar"),
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => VizualizarAssociacaoScreen()),
                );
              },
            ),
          ],
        );
      },
    );
  }
}
