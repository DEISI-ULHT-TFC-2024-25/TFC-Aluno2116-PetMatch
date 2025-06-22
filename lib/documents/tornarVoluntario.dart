import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class TornarVoluntarioScreen extends StatefulWidget {
  final String uidAssociacao;
  const TornarVoluntarioScreen({super.key, required this.uidAssociacao});

  @override
  _TornarVoluntarioScreenState createState() => _TornarVoluntarioScreenState();
}


class _TornarVoluntarioScreenState extends State<TornarVoluntarioScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controladores dos campos de texto
  final TextEditingController nomeController = TextEditingController();
  final TextEditingController moradaController = TextEditingController();
  final TextEditingController localidadeController = TextEditingController();
  final TextEditingController distritoController = TextEditingController();
  final TextEditingController codigoPostalController = TextEditingController();
  final TextEditingController telemovelController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController ccController = TextEditingController();
  final TextEditingController validadeController = TextEditingController();
  final TextEditingController nifController = TextEditingController();
  final TextEditingController outrasTarefasController = TextEditingController();

  bool hasTransport = false;
  bool aceitaRegras = false;
  String mensagemAdicional = "";


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

  /// Função para Firestore
  Future<void> _submeterFormulario() async {
    try {
      final firestore = FirebaseFirestore.instance;
      final currentUser = FirebaseAuth.instance.currentUser;
      final String uidUtilizador = currentUser?.uid ?? "desconhecido";
      final String uidAssociacao = widget.uidAssociacao;

      await firestore.collection("pedidosENotificacoes").add({
        "uidUtilizador": uidUtilizador,
        "oQuePretendeFazer": "Tornar-se Voluntario",
        "uidAssociacao": uidAssociacao,
        "confirmouTodosOsRequisitos": aceitaRegras,
        "mensagemAdicional": mensagemAdicional,
        "estado": "Pendente",
        "dataCriacao": FieldValue.serverTimestamp(),

        "dadosPreenchidos": {
          "Nome Completo": nomeController.text,
          "Morada": moradaController.text,
          "Localidade": localidadeController.text,
          "Distrito" : distritoController.text,
          "Código Postal": codigoPostalController.text,
          "Telemóvel": telemovelController.text,
          "Email": emailController.text,
          "Numero do Cartão de Cidadão": ccController.text,
          "Validade": validadeController.text,
          "NIF": nifController.text,
          "Tem Transporte": hasTransport,
          "Tarefas em que pretende fazer voluntariado": tasks.entries.where((entry) => entry.value).map((entry) => entry.key).toList(),
          "Outras Tarefas Sugeridas": outrasTarefasController.text,
        },
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
              title: Text("✨Enviar Inscrição como Voluntário✨"),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text("Iremos contacta-lo/la assim que possivel?"),
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


  Map<String, bool> tasks = {
    "Campanhas de angariação de alimentação e outros produtos": false,
    "Venda em feiras de bens doados à Associação": false,
    "Conhecimentos de construção (arranjos no nosso abrigo)": false,
    "Ajuda na captura de animais em risco": false,
    "Limpeza das boxes e passear animais no nosso abrigo": false,
    "Boleias aos animais (de/para o abrigo ou clínicas/veterinários)": false,
    "Disponibilidade para fazer recobro de animais": false,
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Tornar-se Voluntário"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("📌 Dados Pessoais"),
              _buildTextField("Nome", nomeController),
              _buildTextField("Morada", moradaController),
              _buildTextField("Localidade", localidadeController),
              _buildTextField("Distrito", distritoController),
              _buildTextField("Código Postal", codigoPostalController),
              _buildTextField("Telemóvel", telemovelController),
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

              Text("📋 Que tarefas está disponível para efectuar"),
              Column(
                children: tasks.keys.map((String key) {
                  return CheckboxListTile(
                    title: Text(key),
                    value: tasks[key],
                    tileColor: Colors.transparent,
                    onChanged: (bool? value) {
                      setState(() {
                        tasks[key] = value ?? false;
                      });
                    },
                  );
                }).toList(),
              ),
              SizedBox(height: 10),
              TextField(
                controller: outrasTarefasController,
                decoration: InputDecoration(
                  labelText: "Outras tarefas em que deseje participar",
                  border: OutlineInputBorder(),
                ),
              ),

              CheckboxListTile(
                title: Text("Confirmo que li e aceito as regras."),
                subtitle: Text("Aceito partilhar os meus dados pessoais com a associação que estou a contactar\nAceito ser contactado pela associação"),
                value: aceitaRegras,
                tileColor: Colors.transparent,
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
                      _mostrarPopupMensagemFinal(); // Mostra o popup com opção de mensagem

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


}
