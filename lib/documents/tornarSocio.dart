import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class TornarSocioScreen extends StatefulWidget {
  const TornarSocioScreen({super.key});

  @override
  _TornarSocioScreenState createState() => _TornarSocioScreenState();
}

class _TornarSocioScreenState extends State<TornarSocioScreen> {
  final _formKey = GlobalKey<FormState>();
  bool aceitaRegras = false;

  // Controladores dos campos de texto
  final TextEditingController nomeController = TextEditingController();
  final TextEditingController moradaController = TextEditingController();
  final TextEditingController codigoPostalController = TextEditingController();
  final TextEditingController localidadeController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController telemovelController = TextEditingController();
  final TextEditingController nifController = TextEditingController();

  // Dropdown de tipo de quota
  List<String> quotas = ["5€/mês", "10€/mês", "15€/mês", "Outro"];
  String selectedQuota = "5€/mês";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text("Tornar-se Sócio 🏡"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("📌 Dados Pessoais", style: _titleStyle()),
              _buildTextField("Nome Completo", nomeController),
              _buildTextField("Morada", moradaController),
              _buildTextField("Código Postal", codigoPostalController),
              _buildTextField("Localidade", localidadeController),
              _buildTextField("E-mail", emailController),
              _buildTextField("Telemóvel", telemovelController),
              _buildTextField("NIF", nifController),
              SizedBox(height: 20),

              Text("💰 Escolha o Tipo de Quota", style: _titleStyle()),
              _buildDropdownQuota(),
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
                  child: Text("Submeter Inscrição ✅"),
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

  /// Dropdown de tipo de quota
  Widget _buildDropdownQuota() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(border: OutlineInputBorder()),
        value: selectedQuota,
        items: quotas.map((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
        onChanged: (String? newValue) {
          setState(() {
            selectedQuota = newValue!;
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

      // Criar um novo pedido na subcoleção "socio"
      await firestore
          .collection("pedidoENotificacoes") // 📂 Coleção principal
          .doc(uidAssociacao) // 📄 Documento do utilizador
          .collection("socio") // 📂 Subcoleção específica
          .add({
        "nomeCompleto": nomeController.text,
        "morada": moradaController.text,
        "codigoPostal": codigoPostalController.text,
        "localidade": localidadeController.text,
        "email": emailController.text,
        "telemovel": telemovelController.text,
        "nif": nifController.text,
        "quota": selectedQuota,
        "status": "pendente", // Inscrição começa como "pendente"
        "dataCriacao": FieldValue.serverTimestamp(), // Timestamp automático
      });

      // Mensagem de sucesso
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Inscrição submetida com sucesso! ✅")),
      );

    } catch (e) {
      print("Erro ao submeter inscrição: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erro ao submeter inscrição! ❌")),
      );
    }
  }

  /// Popup de confirmação após submissão
  void _mostrarPopupConfirmacao() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("🎉 Inscrição Confirmada!"),
          content: Text("Obrigado por se tornar sócio! Em breve, entraremos em contacto."),
          actions: [
            TextButton(
              child: Text("Fechar"),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        );
      },
    );
  }

  TextStyle _titleStyle() => TextStyle(fontSize: 18, fontWeight: FontWeight.bold);
}
