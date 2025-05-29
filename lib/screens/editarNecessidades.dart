import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tinder_para_caes/firebaseLogic/associacaoProvider.dart';
import 'package:tinder_para_caes/models/funcionalidades.dart';
import 'package:tinder_para_caes/models/associacao.dart';

class EditarNecessidades extends StatefulWidget {
  const EditarNecessidades({super.key});

  @override
  _EditarNecessidadesState createState() => _EditarNecessidadesState();
}

class _EditarNecessidadesState extends State<EditarNecessidades> {
  List<Funcionalidades> funcionalidadesSelecionadas = [];


  @override
  void initState() {
    super.initState();
  }

  void _guardarAlteracoes() async {
    final associacao = Provider.of<AssociacaoProvider>(context, listen: false).association;
    funcionalidadesSelecionadas = Provider.of<AssociacaoProvider>(context, listen: false).association!.funcionalidades;

    await FirebaseFirestore.instance
        .collection('associacao')
        .doc(associacao?.uid)
        .update({
      'funcionalidades': funcionalidadesSelecionadas.map((f) => f.toString().split('.').last).toList(),
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Funcionalidades atualizadas com sucesso!')),
    );
    Navigator.pop(context); // opcional: volta atrás
  }

  @override
  Widget build(BuildContext context) {
    final associacao = Provider.of<AssociacaoProvider>(context).association;
    funcionalidadesSelecionadas = Provider.of<AssociacaoProvider>(context).association!.funcionalidades;

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
                children: Funcionalidades.values.map((func) {
                  return CheckboxListTile(
                    title: Text(func.toString().split('.').last),
                    value: funcionalidadesSelecionadas.contains(func),
                    onChanged: (bool? value) {
                      setState(() {
                        if (value == true) {
                          funcionalidadesSelecionadas.add(func);
                        } else {
                          funcionalidadesSelecionadas.remove(func);
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
