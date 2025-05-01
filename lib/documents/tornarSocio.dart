import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class TornarSocioScreen extends StatefulWidget {
  final String uidAssociacao;

  const TornarSocioScreen({super.key, required this.uidAssociacao});
  @override
  _TornarSocioScreenState createState() => _TornarSocioScreenState();
}


class _TornarSocioScreenState extends State<TornarSocioScreen> {
  final _formKey = GlobalKey<FormState>();
  bool aceitaRegras = false;
  String mensagemAdicional = "";


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
                      _mostrarPopupMensagemFinal();

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

  /// Função para Firestore
  Future<void> _submeterFormulario() async {
    try {
      final firestore = FirebaseFirestore.instance;
      final currentUser = FirebaseAuth.instance.currentUser;

      final String uidUtilizador = currentUser?.uid ?? "desconhecido";
      final String uidAssociacao = widget.uidAssociacao;

      await firestore.collection("pedidosENotificacoes").add({
        "uidUtilizador": uidUtilizador,
        "oQuePretendeFazer": "TornarSocio",
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
          "nif": nifController.text,
          "quota": selectedQuota,
        }
      });

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
  void _mostrarPopupMensagemFinal() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        bool mostrarCampoMensagem = false;
        TextEditingController mensagemController = TextEditingController();

        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text("✨ Enviar Inscrição como Sócio"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text("Deseja adicionar uma mensagem adicional à inscrição?"),
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
                  child: Text(mostrarCampoMensagem
                      ? "Esconder mensagem"
                      : "Adicionar mensagem ✍️"),
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


  TextStyle _titleStyle() => TextStyle(fontSize: 18, fontWeight: FontWeight.bold);
}
