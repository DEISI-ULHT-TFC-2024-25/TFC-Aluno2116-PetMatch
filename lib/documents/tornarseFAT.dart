import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CandidaturaFATScreen extends StatefulWidget {
  const CandidaturaFATScreen({super.key});

  @override
  _CandidaturaFATScreenState createState() => _CandidaturaFATScreenState();
}

class _CandidaturaFATScreenState extends State<CandidaturaFATScreen> {
  final _formKey = GlobalKey<FormState>();

  // Variáveis para capturar os valores do formulário
  bool aceitaWhatsApp = false;
  String? tipoHabitacao;
  String? situacaoProfissional;
  bool teveGatos = false;
  bool conscienteBarulho = false;
  bool condicaoFisica = false;

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
        title: Text("Ficha de Candidatura 🐱"),
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
                      await _submeterFormulario(); // Guarda no Firestore
                      _mostrarPopupConfirmacao(); // Mostra popup após salvar
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

  /// Checkbox genérico
  Widget _buildCheckbox(String label, Function(bool) onChanged) {
    return CheckboxListTile(
      title: Text(label),
      value: onChanged != null,
      onChanged: (bool? value) {
        onChanged(value ?? false);
      },
    );
  }

  /// Função para salvar no Firebase Firestore
  Future<void> _submeterFormulario() async {
    try {
      // Obtém o ID do utilizador autenticado
      String uidAssociacao = FirebaseAuth.instance.currentUser?.uid ?? "desconhecido";

      // Referência ao Firestore
      FirebaseFirestore firestore = FirebaseFirestore.instance;

      // Criar um novo pedido na subcoleção "familiaAcolhimentoTemporario"
      await firestore
          .collection("pedidoENotificacoes") // 📂 Coleção principal
          .doc(uidAssociacao) // 📄 Documento do utilizador
          .collection("familiaAcolhimentoTemporario") // 📂 Subcoleção específica
          .add({
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
        "status": "pendente",
        "dataCriacao": FieldValue.serverTimestamp(),
      });

    } catch (e) {
      print("Erro ao submeter candidatura: $e");
    }
  }

  /// Popup de confirmação após submissão
  void _mostrarPopupConfirmacao() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("🎉 Candidatura Enviada!"),
          content: Text("Obrigado por se candidatar! Entraremos em contacto em breve."),
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
