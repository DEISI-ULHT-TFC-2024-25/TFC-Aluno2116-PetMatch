import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class TornarFAT extends StatefulWidget {
  final String uidAssociacao;
  const TornarFAT({super.key, required this.uidAssociacao});
  @override
  _TornarFATState createState() => _TornarFATState();
}


class _TornarFATState extends State<TornarFAT> {
  final _formKey = GlobalKey<FormState>();

  // Variáveis para capturar os valores do formulário
  bool aceitaWhatsApp = false;
  String? tipoHabitacao;
  String? situacaoProfissional;
  bool teveGatos = false;
  bool conscienteBarulho = false;
  bool condicaoFisica = false;
  String mensagemAdicional = "";


  // Controladores de texto
  final TextEditingController nomeController = TextEditingController();
  final TextEditingController idadeController = TextEditingController();
  final TextEditingController moradaController = TextEditingController();
  final TextEditingController codigoPostalController = TextEditingController();
  final TextEditingController localidadeController = TextEditingController();
  final TextEditingController profissaoController = TextEditingController();
  final TextEditingController numPessoasController = TextEditingController();
  final TextEditingController numCriancasController = TextEditingController();
  final TextEditingController animaisCasaController = TextEditingController();
  final TextEditingController motivacaoController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Ficha de Candidatura"),
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
              _buildTextField("Idade", idadeController, isNumeric: true),
              _buildTextField("Morada", moradaController),
              _buildTextField("Código Postal", codigoPostalController),
              _buildTextField("Localidade", localidadeController),
              _buildTextField("Profissão", profissaoController),

              Text("🏠 Tipologia da Habitação", style: _titleStyle()),
              _buildDropdown(["Apartamento", "Moradia", "Casa térrea", "Anexo"],
                      (value) => setState(() => tipoHabitacao = value)),

              _buildTextField("Número de pessoas na habitação", numPessoasController, isNumeric: true),
              _buildTextField("Número de crianças (< 10 anos)", numCriancasController, isNumeric: true),

              Text("💼 Situação Profissional", style: _titleStyle()),
              _buildDropdown([
                "Tempo inteiro (fora de casa)", "Part-time (fora de casa)",
                "Tempo inteiro (teletrabalho)", "Part-time (teletrabalho)",
                "Regime híbrido", "Desempregado"
              ], (value) => setState(() => situacaoProfissional = value)),

              _buildTextField("Outros animais em casa (quantos e quais)", animaisCasaController),

              _buildCheckbox("Já teve gatos ou lidou com gatos?", (value) => setState(() => teveGatos = value)),
              _buildCheckbox("Está consciente que gatos fazem barulho?", (value) => setState(() => conscienteBarulho = value)),
              _buildCheckbox("Aceita enviar fotos e vídeos por WhatsApp?", (value) => setState(() => aceitaWhatsApp = value)),
              _buildCheckbox("Tem alguma condição física incompatível com gatos?", (value) => setState(() => condicaoFisica = value)),

              _buildTextField("Motivação para ser família de acolhimento", motivacaoController, maxLines: 5),
              SizedBox(height: 20),

              Center(
                child: ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      _mostrarPopupConfirmacao();
                    }
                  },
                  child: Text("Submeter Candidatura ✅"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Função para capturar dados dos campos de texto
  Widget _buildTextField(String label, TextEditingController controller, {bool isNumeric = false, int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        keyboardType: isNumeric ? TextInputType.number : TextInputType.text,
        maxLines: maxLines,
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

  /// Dropdown genérico
  Widget _buildDropdown(List<String> options, Function(String?) onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(border: OutlineInputBorder()),
        items: options.map((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
        onChanged: onChanged,
        validator: (value) => value == null ? 'Escolha uma opção' : null,
      ),
    );
  }


  Widget _buildCheckbox(String label, Function(bool) onChanged) {
    return CheckboxListTile(
      title: Text(label),
      value: onChanged != null,
      onChanged: (bool? value) {
        onChanged(value ?? false);
      },
    );
  }

  Future<void> _submeterFormulario() async {
    try {
      final firestore = FirebaseFirestore.instance;
      final currentUser = FirebaseAuth.instance.currentUser;

      final String uidUtilizador = currentUser?.uid ?? "desconhecido";
      final String uidAssociacao = widget.uidAssociacao;

      await firestore.collection("pedidosENotificacoes").add({
        "uidUtilizador": uidUtilizador,
        "oQuePretendeFazer": "Tornar-se em Família de Acolhimento Temporária",
        "uidAssociacao": uidAssociacao,
        "confirmouTodosOsRequisitos": true,
        "mensagemAdicional": mensagemAdicional,
        "estado": "pendente",
        "dataCriacao": FieldValue.serverTimestamp(),

        "dadosPreenchidos": {
          "nomeCompleto": nomeController.text,
          "idade": int.tryParse(idadeController.text) ?? 0,
          "morada": moradaController.text,
          "codigoPostal": codigoPostalController.text,
          "localidade": localidadeController.text,
          "profissao": profissaoController.text,
          "tipoHabitacao": tipoHabitacao,
          "numPessoas": int.tryParse(numPessoasController.text) ?? 0,
          "numCriancas": int.tryParse(numCriancasController.text) ?? 0,
          "situacaoProfissional": situacaoProfissional,
          "animaisCasa": animaisCasaController.text,
          "teveGatos": teveGatos,
          "conscienteBarulho": conscienteBarulho,
          "aceitaWhatsApp": aceitaWhatsApp,
          "condicaoFisica": condicaoFisica,
          "motivacao": motivacaoController.text,
        },
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Candidatura submetida com sucesso! ✅")),
      );

    } catch (e) {
      print("Erro ao submeter candidatura: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erro ao submeter a candidatura ❌")),
      );
    }
  }

  /// Popup de confirmação após submissão
  void _mostrarPopupConfirmacao() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        bool mostrarCampoMensagem = false;
        TextEditingController mensagemController = TextEditingController();

        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text("🎉 Candidatura pronta a enviar"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text("Deseja adicionar alguma mensagem adicional antes de submeter?"),
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
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text("Cancelar ❌"),
                ),
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
                    Navigator.of(context).pop(); // Fecha o popup
                    await _submeterFormulario(); // Submete com mensagem
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
