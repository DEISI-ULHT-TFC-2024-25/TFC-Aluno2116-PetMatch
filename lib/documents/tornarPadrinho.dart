import 'package:flutter/material.dart';
import 'package:tinder_para_caes/screens/vizualizarAssociacaoScreen.dart';

class TornarPadrinhoScreen extends StatefulWidget {
  @override
  _TornarPadrinhoScreenState createState() => _TornarPadrinhoScreenState();
}

class _TornarPadrinhoScreenState extends State<TornarPadrinhoScreen> {
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
              _buildTextField("Nome Completo"),
              _buildTextField("Morada"),
              _buildTextField("Código Postal"),
              _buildTextField("Localidade"),
              _buildTextField("E-mail"),
              _buildTextField("Telemóvel"),
              SizedBox(height: 20),
              Text("🐕 Escolha do Animal", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              _buildTextField("Nome do Animal que deseja apadrinhar"),
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
                      _mostrarPopupConfirmacao();
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

  Widget _buildDropdownApadrinhamento() {
    List<String> opcoes = ["Ajuda financeira", "Apoio com alimentação", "Custos veterinários", "Outro"];
    String selectedOpcao = opcoes[0];

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(border: OutlineInputBorder()),
        value: selectedOpcao,
        items: opcoes.map((String value) {
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
