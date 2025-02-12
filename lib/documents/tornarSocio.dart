import 'package:flutter/material.dart';
import 'package:tinder_para_caes/screens/vizualizarAssociacaoScreen.dart';

class TornarSocioScreen extends StatefulWidget {
  @override
  _TornarSocioScreenState createState() => _TornarSocioScreenState();
}

class _TornarSocioScreenState extends State<TornarSocioScreen> {
  final _formKey = GlobalKey<FormState>();
  bool aceitaRegras = false;

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
        title: Text("Tornar-se Sócio 🏡"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("📌 Dados Pessoais", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              _buildTextField("Nome Completo"),
              _buildTextField("Morada"),
              _buildTextField("Código Postal"),
              _buildTextField("Localidade"),
              _buildTextField("E-mail"),
              _buildTextField("Telemóvel"),
              _buildTextField("NIF"),
              SizedBox(height: 20),
              Text("💰 Escolha o Tipo de Quota", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
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
                  onPressed: () {
                    if (_formKey.currentState!.validate() && aceitaRegras) {
                      _mostrarPopupConfirmacao();
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

  Widget _buildTextField(String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
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

  Widget _buildDropdownQuota() {
    List<String> quotas = ["5€/mês", "10€/mês", "15€/mês", "Outro"];
    String selectedQuota = quotas[0];

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
