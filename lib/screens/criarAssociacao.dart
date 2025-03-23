import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:tinder_para_caes/screens/associacaoHomeScreen.dart';
import 'package:tinder_para_caes/models/associacao.dart';
import 'package:tinder_para_caes/firebaseLogic/authenticationService.dart';
import 'package:provider/provider.dart';
import 'package:tinder_para_caes/firebaseLogic/associacaoProvider.dart';
import '../models/funcionalidades.dart' show Funcionalidades;
import '../theme/theme.dart'; // Importação do tema

class CriarAssociacao extends StatefulWidget {
  const CriarAssociacao({super.key});

  @override
  _CriarAssociacaoState createState() => _CriarAssociacaoState();
}

class _CriarAssociacaoState extends State<CriarAssociacao> {
  bool shareLocation = false;
  final Authenticationservice authService = Authenticationservice();
  final TextEditingController nomeController = TextEditingController();
  final TextEditingController email1Controller = TextEditingController();
  final TextEditingController email2Controller = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  final TextEditingController telefone1Controller = TextEditingController();
  final TextEditingController telefone2Controller = TextEditingController();
  final TextEditingController moradaController = TextEditingController();
  final TextEditingController distritoController = TextEditingController();

  List<Funcionalidades> funcionalidadesSelecionadas = [];

  void _mostrarPopUpFuncionalidades() async {
    List<Funcionalidades> selecionadasTemp = List.from(funcionalidadesSelecionadas);

    bool? resultado = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Escolha as Funcionalidades"),
          content: SizedBox(
            width: MediaQuery.of(context).size.width * 0.9,
            height: MediaQuery.of(context).size.height * 0.7,
            child: StatefulBuilder(
              builder: (context, setStateDialog) {
                return ListView(
                  children: Funcionalidades.values.map((func) {
                    return CheckboxListTile(
                      title: Text(func.toString().split('.').last),
                      value: selecionadasTemp.contains(func),
                      onChanged: (bool? value) {
                        setStateDialog(() {
                          if (value == true) {
                            selecionadasTemp.add(func);
                          } else {
                            selecionadasTemp.remove(func);
                          }
                        });
                      },
                    );
                  }).toList(),
                );
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text("Cancelar"),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  funcionalidadesSelecionadas = selecionadasTemp;
                });
                Navigator.pop(context, true);
              },
              child: const Text("Confirmar"),
            ),
          ],
        );
      },
    );

    if (resultado == true) {
      setState(() {});
    }
  }

  void register() async {
    if (passwordController.text != confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("❌ As palavras-passe não coincidem!")),
      );
      return;
    }
    if (passwordController.text.isEmpty || email1Controller.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("❌ Email e senha são obrigatórios")),
      );
      return;
    }

    Map<String, dynamic> associacaoData = {
      "nome": nomeController.text,
      "emailGeral": email1Controller.text,
      "emailParaAlgumaCoisa": email2Controller.text.isNotEmpty ? email2Controller.text : null,
      "telemovelPrincipal": telefone1Controller.text,
      "telemovelSecundario": telefone2Controller.text,
      "morada": shareLocation ? moradaController.text : null, // Morada apenas se shareLocation for true
      "distrito": distritoController.text, // Distrito sempre presente
      "tipo": "associacao",
      "animais": [],
      "pedidos": [],
      "eventos": [],
      "necessidades": [],
      "funcionalidades": funcionalidadesSelecionadas.map((f) => f.toString().split('.').last).toList(),
    };

    var firebaseUser = await authService.registerAssociacao(
      email1Controller.text,
      passwordController.text,
      associacaoData,
    );

    if (firebaseUser != null) {
      final uid = firebaseUser.uid;
      final docRef = FirebaseFirestore.instance.collection('associacao').doc(uid);
      final docSnap = await docRef.get();
      final data = docSnap.data();

      if (data != null) {
        final minhaAssociacao = Associacao.fromMap(uid, data);
        Provider.of<AssociacaoProvider>(context, listen: false).setAssociation(minhaAssociacao);
      }

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const AssociacaoHomeScreen()),
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("✅ Associação registada com sucesso!")),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("❌ Erro ao registrar associação")),
      );
    }
  }

  List<String> distritos = [];

  @override
  void initState() {
    super.initState();
    _initializeDistritos();
  }

  static Future<List<String>> loadDistritos() async {
    final String response = await rootBundle.loadString('assets/distritos.txt');
    return response.split('\n').map((line) => line.trim()).toList();
  }

  Future<void> _initializeDistritos() async {
    try {
      final distritosLista = await loadDistritos();
      setState(() {
        distritos = distritosLista;
      });
    } catch (e) {
      print('Erro ao carregar os distritos: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context); // Obtém o tema

    return Scaffold(
      appBar: AppBar(title: const Text('Formulário de Associação')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            TextField(
              controller: nomeController,
              decoration: InputDecoration(labelText: 'Nome'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(labelText: 'Palavra-passe'),
              obscureText: true,
            ),
            const SizedBox(height: 10),
            TextField(
              controller: confirmPasswordController,
              decoration: InputDecoration(labelText: 'Confirmação da Palavra-passe'),
              obscureText: true,
            ),
            const SizedBox(height: 10),
            TextField(
              controller: telefone1Controller,
              decoration: InputDecoration(labelText: 'Telemóvel 1'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: telefone2Controller,
              decoration: InputDecoration(labelText: 'Telemóvel 2'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: email1Controller,
              decoration: InputDecoration(labelText: 'Email 1'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: email2Controller,
              decoration: InputDecoration(labelText: 'Email 2'),
            ),
            const SizedBox(height: 10),
            CheckboxListTile(
              title: const Text('Partilhar localização?'),
              value: shareLocation,
              onChanged: (bool? value) {
                setState(() {
                  shareLocation = value ?? false;
                });
              },
            ),
            Autocomplete<String>(
              optionsBuilder: (TextEditingValue textEditingValue) {
                if (textEditingValue.text.isEmpty) {
                  return const Iterable<String>.empty();
                }
                return distritos.where((String distrito) =>
                    distrito.toLowerCase().contains(textEditingValue.text.toLowerCase()));
              },
              fieldViewBuilder: (BuildContext context, TextEditingController textEditingController, FocusNode focusNode, VoidCallback onFieldSubmitted) {
                distritoController.text = textEditingController.text;
                return TextField(
                  controller: textEditingController,
                  focusNode: focusNode,
                  decoration: const InputDecoration(labelText: 'Distrito'),
                );
              },
              onSelected: (String selection) {
                distritoController.text = selection;
              },
            ),

            if (shareLocation) ...[
              TextField(
                controller: moradaController,
                decoration: const InputDecoration(labelText: 'Morada'),
              ),
            ],
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: theme.primaryColor),
              onPressed: _mostrarPopUpFuncionalidades,
              child: const Text("Escolher Funcionalidades"),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: theme.primaryColor),
              onPressed: register,
              child: const Text("Submeter"),
            ),
          ],
        ),
      ),
    );
  }
}