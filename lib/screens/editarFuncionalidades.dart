import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tinder_para_caes/firebaseLogic/associacaoProvider.dart';
import 'package:tinder_para_caes/models/funcionalidades.dart';
import 'package:tinder_para_caes/models/associacao.dart';

class EditarFuncionalidades extends StatefulWidget {
  const EditarFuncionalidades({super.key});

  @override
  _EditarFuncionalidadesState createState() => _EditarFuncionalidadesState();
}

class _EditarFuncionalidadesState extends State<EditarFuncionalidades> {
  List<String> funcionalidadesSelecionadas = [];


  @override
  void initState() {
    super.initState();
  }

  void _guardarAlteracoes() async {
    final associacao = Provider.of<AssociacaoProvider>(context, listen: false).association;
    funcionalidadesSelecionadas = Provider.of<AssociacaoProvider>(context, listen: false).association!.funcionalidades;

    await FirebaseFirestore.instance.collection('associacao').doc(associacao?.uid).update({
      'funcionalidades': funcionalidadesSelecionadas,
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Funcionalidades atualizadas com sucesso!')),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final associacao = Provider.of<AssociacaoProvider>(context).association;
    funcionalidadesSelecionadas = Provider.of<AssociacaoProvider>(context).association!.funcionalidades;
    List<String> funcionalidades = ["Voluntariado", "Ir passear um Cão", "Apadrinhamento de um animal", "Tornar-se Sócio", "Partilha de Eventos", "Tornar-se em Família de Acolhimento Temporária", "Lista de Necessidades"];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar Funcionalidades'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'As suas funcionalidades escolhidas:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView(
                children: funcionalidades.map((f) {
                  return CheckboxListTile(
                    title: Text(f),
                    value: funcionalidadesSelecionadas.any((fs) => fs == f),
                    onChanged: (bool? value) {
                      setState(() {
                        if (value == true) {
                          funcionalidadesSelecionadas.add(f);
                        } else {
                          funcionalidadesSelecionadas.remove(f);
                        }
                      });
                    },
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: _guardarAlteracoes,
                child: const Text('Guardar Alterações'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
