import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class TornarVoluntarioScreen extends StatefulWidget {
  const TornarVoluntarioScreen({super.key});

  @override
  _TornarVoluntarioScreenState createState() => _TornarVoluntarioScreenState();
}

class _TornarVoluntarioScreenState extends State<TornarVoluntarioScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controladores dos campos de texto
  final TextEditingController nomeController = TextEditingController();
  final TextEditingController moradaController = TextEditingController();
  final TextEditingController localidadeController = TextEditingController();
  final TextEditingController codigoPostalController = TextEditingController();
  final TextEditingController telemovelController = TextEditingController();
  final TextEditingController telefoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController ccController = TextEditingController();
  final TextEditingController validadeController = TextEditingController();
  final TextEditingController nifController = TextEditingController();
  final TextEditingController outrasTarefasController = TextEditingController();

  bool hasTransport = false;
  bool aceitaRegras = false;

  Map<String, bool> tasks = {
    "Campanhas de Angariação de alimentação e outros produtos": false,
    "Venda em Feiras de bens doados à Associação": false,
    "Conhecimentos de construção (arranjos no nosso abrigo)": false,
    "Ajuda na captura de animais em risco": false,
    "Limpeza das boxes e passear animais no nosso abrigo": false,
    "Boleias aos animais (de/para o abrigo ou clínicas/veterinários)": false,
    "Ser FAT de cães": false,
    "Disponibilidade para fazer recobro de animais": false,
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Tornar-se Voluntário 🏠"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("📌 Dados Pessoais", style: _titleStyle()),
              _buildTextField("Nome", nomeController),
              _buildTextField("Morada", moradaController),
              _buildTextField("Localidade", localidadeController),
              _buildTextField("Código Postal", codigoPostalController),
              _buildTextField("Telemóvel", telemovelController),
              _buildTextField("Telefone", telefoneController),
              _buildTextField("E-mail", emailController),
              _buildTextField("CC/BI", ccController),
              _buildTextField("Validade", validadeController),
              _buildTextField("NIF", nifController),
              SizedBox(height: 10),

              Row(
                children: [
                  Text("🚗 Transporte Próprio"),
                  Switch(
                    value: hasTransport,
                    onChanged: (value) {
                      setState(() {
                        hasTransport = value;
                      });
                    },
                  ),
                ],
              ),
              SizedBox(height: 10),

              Text("📋 Que tarefas está disponível para efectuar", style: _titleStyle()),
              Column(
                children: tasks.keys.map((String key) {
                  return CheckboxListTile(
                    title: Text(key),
                    value: tasks[key],
                    onChanged: (bool? value) {
                      setState(() {
                        tasks[key] = value ?? false;
                      });
                    },
                  );
                }).toList(),
              ),
              SizedBox(height: 10),

              _buildTextField("Outras tarefas", outrasTarefasController),

              CheckboxListTile(
                title: Text("Confirmo que li e aceito as regras."),
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
                  child: Text("Submeter Formulário ✅"),
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

  /// Função para salvar no Firebase Firestore
  Future<void> _submeterFormulario() async {
    try {
      // Obtém o ID do utilizador autenticado
      String uidAssociacao = FirebaseAuth.instance.currentUser?.uid ?? "desconhecido";

      // Referência ao Firestore
      FirebaseFirestore firestore = FirebaseFirestore.instance;

      // Criar um novo pedido na subcoleção "voluntario"
      await firestore
          .collection("pedidoENotificacoes") // 📂 Coleção principal
          .doc(uidAssociacao) // 📄 Documento do utilizador
          .collection("voluntario") // 📂 Subcoleção específica
          .add({
        "nome": nomeController.text,
        "morada": moradaController.text,
        "localidade": localidadeController.text,
        "codigoPostal": codigoPostalController.text,
        "telemovel": telemovelController.text,
        "telefone": telefoneController.text,
        "email": emailController.text,
        "cc": ccController.text,
        "validade": validadeController.text,
        "nif": nifController.text,
        "temTransporte": hasTransport,
        "tarefas": tasks.entries.where((entry) => entry.value).map((entry) => entry.key).toList(),
        "outrasTarefas": outrasTarefasController.text,
        "aceitaRegras": aceitaRegras,
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
          content: Text("Obrigado por se tornar voluntário! Em breve, entraremos em contacto."),
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
