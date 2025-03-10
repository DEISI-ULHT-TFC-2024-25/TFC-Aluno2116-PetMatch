import 'package:flutter/material.dart';

class CandidaturaFATScreen extends StatefulWidget {
  @override
  _CandidaturaFATScreenState createState() => _CandidaturaFATScreenState();
}

class _CandidaturaFATScreenState extends State<CandidaturaFATScreen> {
  final _formKey = GlobalKey<FormState>();
  bool aceitaWhatsApp = false;
  String? tipoHabitacao;
  String? situacaoProfissional;
  bool teveGatos = false;
  bool conscienteBarulho = false;
  bool condicaoFisica = false;

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
              _buildTextField("Nome Completo"),
              _buildTextField("Idade", isNumeric: true),
              _buildTextField("Morada"),
              _buildTextField("Código Postal"),
              _buildTextField("Localidade"),
              _buildTextField("Profissão"),

              Text("🏠 Tipologia da Habitação", style: _titleStyle()),
              _buildDropdown([
                "Apartamento", "Moradia", "Casa térrea", "Anexo"
              ], (value) => setState(() => tipoHabitacao = value)),

              _buildTextField("Número de pessoas na habitação", isNumeric: true),
              _buildTextField("Número de crianças (< 10 anos)", isNumeric: true),

              Text("💼 Situação Profissional", style: _titleStyle()),
              _buildDropdown([
                "Tempo inteiro (fora de casa)", "Part-time (fora de casa)",
                "Tempo inteiro (teletrabalho)", "Part-time (teletrabalho)",
                "Regime híbrido", "Desempregado"
              ], (value) => setState(() => situacaoProfissional = value)),

              _buildTextField("Outros animais em casa (quantos e quais)"),

              _buildCheckbox("Já teve gatos ou lidou com gatos?", (value) => setState(() => teveGatos = value)),
              _buildCheckbox("Está consciente que gatos fazem barulho?", (value) => setState(() => conscienteBarulho = value)),
              _buildCheckbox("Aceita enviar fotos e vídeos por WhatsApp?", (value) => setState(() => aceitaWhatsApp = value)),
              _buildCheckbox("Tem alguma condição física incompatível com gatos?", (value) => setState(() => condicaoFisica = value)),

              _buildTextField("Motivação para ser família de acolhimento", maxLines: 5),
              SizedBox(height: 20),

              Center(
                child: ElevatedButton(
                  onPressed: () {
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

  Widget _buildTextField(String label, {bool isNumeric = false, int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
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
