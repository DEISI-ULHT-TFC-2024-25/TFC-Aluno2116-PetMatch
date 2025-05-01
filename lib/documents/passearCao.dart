import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tinder_para_caes/screens/vizualizarAssociacaoScreen.dart';

class PassearCaoScreen extends StatefulWidget {
  final String uidAssociacao;
  const PassearCaoScreen({Key? key, required this.uidAssociacao}) : super(key: key);

  @override
  _PassearCaoScreenState createState() => _PassearCaoScreenState();
}

class _PassearCaoScreenState extends State<PassearCaoScreen> {
  // Controladores para capturar os inputs do utilizador
  final TextEditingController nomePasseadorController = TextEditingController();
  final TextEditingController moradaFiscalController = TextEditingController();
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
  String mensagemAdicional = "";



  Future<void> _submeterFormulario() async {
    try {
      final firestore = FirebaseFirestore.instance;
      final currentUser = FirebaseAuth.instance.currentUser;


      final String uidUtilizador = currentUser?.uid ?? "desconhecido";
      final String uidAnimal = "uidAnimal123";
      final String uidAssociacao = widget.uidAssociacao;


      final docRef = await firestore.collection("pedidosENotificacoes").add({
        "oQuePretendeFazer": "PassearCao",
        "utilizadorUid": uidUtilizador,
        "associacao": uidAssociacao,
        "confirmouTodosOsRequisitos": aceitaRegras,
        "mensagemAdicional": mensagemAdicional,
        "estado": "pendente",
        "dataCriacao": FieldValue.serverTimestamp(),

        "dadosPreenchidos": {
          "nomeCompleto": nomePasseadorController.text,
          "moradaFiscal": moradaFiscalController.text,
          "ccBi": ccBiController.text,
          "validadeCC": validadeCCController.text,
          "tlm": tlmController.text,
          "idade": int.tryParse(idadeController.text) ?? 0,

          "nomeCao": nomeCaoController.text,
          "chip": chipController.text,

          "temProblemaComportamento": temProblemaComportamento,
          "comportamentoDescricao": comportamentoController.text,
          "temAlergias": temAlergias,
          "alergiasDescricao": alergiasController.text,
          "portePeso": portePesoController.text,
          "estaEsterilizado": estaEsterilizado,

          "matriculaVeiculo": matriculaVeiculoController.text,
          "localPasseio": local.text,
        },
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Pedido de passeio submetido com sucesso! ✅")),
      );

    } catch (e) {
      print("Erro ao submeter formulário: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erro ao submeter pedido! ❌")),
      );
    }
  }



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
              title: Text("Castrado/Esterelizada"),
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
                StatefulBuilder(
                  builder: (BuildContext context, StateSetter setStateDialog) {
                    return CheckboxListTile(
                      title: Text("Confirmo que li e aceito as regras."),
                      value: aceitaRegras,
                      onChanged: (bool? value) {
                        setState(() {
                          aceitaRegras = value!;
                        });
                        setStateDialog(() {}); // <- Atualiza só o conteúdo do popup
                      },
                    );
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
              onPressed: aceitaRegras
                  ? () async {
                Navigator.of(context).pop(); // 🔄 Fecha o popup de regras
                _mostrarPopupFinal();       // ✨ Abre o popup para submeter (com mensagem opcional)

              }
                  : null,
              child: Text("Aceitar ✅"),
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
        bool mostrarCampoMensagem = false;
        TextEditingController mensagemController = TextEditingController();

        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text("🐶 Passeio Registado com Sucesso!"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text("Obrigado por registar o passeio!"),
                  SizedBox(height: 10),
                  Text(
                    "📸 Lembra-te de tirar fotos do passeio!\nPodes enviá-las para partilhar a experiência.",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                  if (mostrarCampoMensagem)
                    Padding(
                      padding: const EdgeInsets.only(top: 16.0),
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
                  child: Text(mostrarCampoMensagem ? "Esconder mensagem" : "Adicionar mensagem ✍️"),
                ),
                ElevatedButton(
                  onPressed: () async {
                    setState(() {
                      mensagemAdicional = mensagemController.text;
                    });
                    Navigator.of(context).pop(); // fecha popup
                    await _submeterFormulario(); // guarda os dados
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
}
