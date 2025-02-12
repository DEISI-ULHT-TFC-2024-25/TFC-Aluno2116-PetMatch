import 'package:flutter/material.dart';
import 'package:tinder_para_caes/screens/vizualizarAssociacaoScreen.dart';

class TornarVoluntarioApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: TornarVoluntarioScreen(),
    );
  }
}

class TornarVoluntarioScreen extends StatefulWidget {
  @override
  _TornarVoluntarioScreenState createState() => _TornarVoluntarioScreenState();
}

class _TornarVoluntarioScreenState extends State<TornarVoluntarioScreen> {
  final _formKey = GlobalKey<FormState>();
  bool hasTransport = false;
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
        title: Text("Tornar-se Voluntário 🏠"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("📌 Dados Pessoais", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            _buildTextField("Nome"),
            _buildTextField("Morada"),
            _buildTextField("Localidade"),
            _buildTextField("Código Postal"),
            _buildTextField("Telemóvel"),
            _buildTextField("Telefone"),
            _buildTextField("E-mail"),
            _buildTextField("CC/BI"),
            _buildTextField("Validade"),
            _buildTextField("NIF"),
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
            Text("📋 Que tarefas está disponível para efectuar", style: TextStyle(fontWeight: FontWeight.bold)),
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
            _buildTextField("Outras tarefas"),
            SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  _mostrarPopupRegras();
                },
                child: Text("Submeter Formulário ✅"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _mostrarPopupRegras() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("📜 Termos e Responsabilidades"),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("O voluntário compromete-se a cumprir determinadas regras:"),
                Text("✅ Cumprir horários e compromissos."),
                Text("✅ Tratar os animais com respeito e carinho."),
                Text("✅ Seguir todas as diretrizes da organização."),
                CheckboxListTile(
                  title: Text("Confirmo que li e aceito as regras."),
                  value: aceitaRegras,
                  onChanged: (bool? value) {
                    setState(() {
                      aceitaRegras = value ?? false;
                    });
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              child: Text("Cancelar ❌"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              child: Text("Aceitar ✅"),
              onPressed: aceitaRegras
                  ? () {
                Navigator.of(context).pop();
              }
                  : null,
            ),
          ],
        );
      },
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
}


