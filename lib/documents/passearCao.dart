import 'package:flutter/material.dart';
import 'package:tinder_para_caes/screens/vizualizarAssociacaoScreen.dart';

class PassearCaoScreen extends StatefulWidget {
  @override
  _PassearCaoScreenState createState() => _PassearCaoScreenState();
}

class _PassearCaoScreenState extends State<PassearCaoScreen> {
  // Controladores para capturar os inputs do utilizador
  final TextEditingController nomePasseadorController = TextEditingController();
  final TextEditingController moradaFiscalController = TextEditingController();
  final TextEditingController moradaContactoController = TextEditingController();
  final TextEditingController ccBiController = TextEditingController();
  final TextEditingController validadeCCController = TextEditingController();
  final TextEditingController tlmController = TextEditingController();
  final TextEditingController idadeController = TextEditingController();

  final TextEditingController nomeCaoController = TextEditingController();
  final TextEditingController chipController = TextEditingController();

  final TextEditingController comportamentoController = TextEditingController();
  final TextEditingController alergiasController = TextEditingController();
  final TextEditingController portePesoController = TextEditingController();
  final TextEditingController matriculaVeiculoController = TextEditingController();
  final TextEditingController local = TextEditingController();


  // Variáveis booleanas para as caixas de seleção
  bool temProblemaComportamento = false;
  bool temAlergias = false;
  bool estaEsterilizado = false;
  bool aceitaRegras = false; // Para o popup de confirmação

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Passear Cão 🐶")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 📌Dados do Passeador
            Text("📌 Dados do Passeador", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            TextField(controller: nomePasseadorController, decoration: InputDecoration(labelText: "Nome*")),
            TextField(controller: moradaFiscalController, decoration: InputDecoration(labelText: "Morada Fiscal*")),
            TextField(controller: moradaContactoController, decoration: InputDecoration(labelText: "Morada de Contacto*")),
            TextField(controller: ccBiController, decoration: InputDecoration(labelText: "CC/BI*")),
            TextField(controller: validadeCCController, decoration: InputDecoration(labelText: "Data de Validade*")),

            TextField(
              controller: tlmController,
              keyboardType: TextInputType.phone, // ✅ Correto
              decoration: InputDecoration(labelText: "TLM*"),
            ),

            TextField(
              controller: idadeController,
              keyboardType: TextInputType.number, // ✅ Correto
              decoration: InputDecoration(labelText: "Idade* (mínimo 18 anos)"),
            ),

            SizedBox(height: 20),

            //  Dados do Canídeo
            Text("🐕 Dados do Canídeo", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            TextField(controller: nomeCaoController, decoration: InputDecoration(labelText: "Nome do Canídeo*")),

            TextField(
              controller: chipController,
              keyboardType: TextInputType.number, // ✅ Correto
              decoration: InputDecoration(labelText: "Nº CHIP*"),
            ),

            SizedBox(height: 20),

            // Características do Canídeo
            Text("📋 Características do Canídeo", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            CheckboxListTile(
              title: Text("Problemas de comportamento"),
              value: temProblemaComportamento,
              onChanged: (bool? value) {
                setState(() {
                  temProblemaComportamento = value!;
                });
              },
            ),
            TextField(controller: comportamentoController, decoration: InputDecoration(labelText: "Descrição do problema")),

            CheckboxListTile(
              title: Text("Alergias ou restrições"),
              value: temAlergias,
              onChanged: (bool? value) {
                setState(() {
                  temAlergias = value!;
                });
              },
            ),
            TextField(controller: alergiasController, decoration: InputDecoration(labelText: "Descrição das alergias ou restrições")),

            TextField(controller: portePesoController, decoration: InputDecoration(labelText: "Porte/Peso")),

            CheckboxListTile(
              title: Text("Castrado/Estrelizada"),
              value: estaEsterilizado,
              onChanged: (bool? value) {
                setState(() {
                  estaEsterilizado = value!;
                });
              },
            ),

            SizedBox(height: 20),

            // 📍 Local do Passeio
            Text("📍 Local onde se vai realizar o passeio", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            TextField(controller: matriculaVeiculoController, decoration: InputDecoration(labelText: "Matrícula do veículo:")),
            TextField(controller: local, decoration: InputDecoration(labelText: "Local onde o vai passear:")),

            SizedBox(height: 20),

            // Botão de Submissão
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

  // 🔥 Popup para confirmar as regras antes da submissão
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
                Text("O passeador compromete-se a cumprir determinadas regras durante o passeio:"),
                Text("✅ Nunca soltar o canídeo."),
                Text("✅ Não permitir que terceiros se aproximem sem autorização."),
                Text("✅ Manter a integridade física do canídeo e evitar perigos."),
                Text("✅ Apanhar os dejetos do canídeo."),
                Text("✅ Limitar o passeio a duas horas."),
                CheckboxListTile(
                  title: Text("Confirmo que li e aceito as regras."),
                  value: aceitaRegras,
                  onChanged: (bool? value) {
                    setState(() {
                      aceitaRegras = value!;
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
                _mostrarPopupFinal();
              }
                  : null,
            ),
          ],
        );
      },
    );
  }

  //  Popup final com imagem e incentivo para tirar fotos
  void _mostrarPopupFinal() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("🐶 Passeio Registado com Sucesso!"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("Obrigado por registar o passeio!"),
              SizedBox(height: 10),

              SizedBox(height: 10),
              Text(
                "📸 Lembra-te de tirar fotos do passeio!\nPodes enviá-las para partilhar a experiência.",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          actions: [
            TextButton(
              child: Text("Fechar"),
              onPressed: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => VizualizarAssociacaoScreen()),
                );
              },
            ),
          ],
        );
      },
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Formulário submetido com sucesso! ✅")),
    );
  }
}
