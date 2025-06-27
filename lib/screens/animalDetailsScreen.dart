import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:tinder_para_caes/models/animal.dart';
import 'package:tinder_para_caes/documents/tornarPadrinho.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tinder_para_caes/screens/utilizadorHomeScreen.dart';

class AnimalDetailsScreen extends StatelessWidget {
  final Animal animal;
  final bool isAssoci;
  final String uidAssociacao;
  final String origem;


  const AnimalDetailsScreen({
    super.key,
    required this.animal,
    required this.isAssoci,
    required this.uidAssociacao,
    required this.origem,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.primaryColor;
    final String uid = uidAssociacao;

    final String fullName = animal.fullName;
    final String age = animal.calcularIdade();
    final bool sterilized = animal.sterilized;
    final String gender = animal.gender;
    final String allergies = animal.allergies;
    final String size = animal.size;
    final String behavior = animal.behavior;
    final String breed = animal.breed;
    final String species = animal.species;
    final int numeroDePasseiosDados = animal.numeroDePasseiosDados;
    final bool asGoFather = animal.hasGodFather;
    final String? imagemPerfil = animal.imagens.isNotEmpty ? animal.imagens.first : null;

    final uidAtual = FirebaseAuth.instance.currentUser?.uid;
    final bool donoDoAnimal = animal.donoID == uidAtual;



    return Scaffold(
      appBar: AppBar(
        title: const Text('Perfil do Animal'),
        backgroundColor: primaryColor,
        actions: [
          if( donoDoAnimal)
            IconButton(
              icon: Icon(Icons.delete, color: Colors.white),
              tooltip: 'Eliminar animal',
              onPressed: () => confirmarRemocaoAnimal(context, animal),
            ),
        ],
      ),

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                height: 300,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: primaryColor, width: 2),
                  image: imagemPerfil != null
                      ? DecorationImage(
                    image: NetworkImage(imagemPerfil),
                    fit: BoxFit.cover,
                  )
                      : null,
                  color: theme.primaryColor,
                ),
                child: imagemPerfil == null
                    ? Center(
                  child: Icon(
                    Icons.pets,
                    size: 50,
                    color: Colors.white,
                  ),
                )
                    : null,
              ),

            if (donoDoAnimal)
              Align(
                alignment: Alignment.topRight,
                child: IconButton(
                  icon: Icon(Icons.add_a_photo, color: primaryColor),
                  onPressed: () async {
                    await mostrarPopupAdicionarFotos(context, animal.uid);
                  },
                ),
              ),


              const SizedBox(height: 10),
              Text(
                fullName,
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: primaryColor,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              _buildInfoRow(context, Icons.pets, 'Espécie:', species),
              _buildInfoRow(context, Icons.badge, 'Raça:', breed),
              _buildInfoRow(context, Icons.cake, 'Idade:', age ),
              _buildInfoRow(context, gender == "Feminino" ? Icons.female : Icons.male,'Gênero:',gender),
              _buildInfoRow(context, Icons.healing, 'Castrado/Esterilizada:', sterilized ? 'Sim' : 'Não'),
              _buildInfoRow(context, Icons.warning, 'Problemas de Saude/Alergias:', allergies.isEmpty ? 'Nenhuma' : allergies),
              _buildInfoRow(context, Icons.rule, 'Porte:', size),
              _buildInfoRow(context, Icons.emoji_emotions, 'Comportamento:', behavior),
              _buildInfoRow(context, Icons.directions_walk, 'Passeios dados:', '$numeroDePasseiosDados'),

              if (isAssoci && !donoDoAnimal )
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => TornarPadrinhoScreen(uidAssociacao: uid)),
                      );
                    },
                    child: const Text("Apadrinhar este animal "),
                  ),
                ),

              const SizedBox(height: 10),
              if (uidAtual == uidAssociacao)
                Align(
                    alignment: Alignment.center,
                    child: TextButton(
                      onPressed: () async {
                        final novoValor = !animal.visivel;
                        await FirebaseFirestore.instance
                            .collection('animal')
                            .doc(animal.uid.toString())
                            .update({'visivel': novoValor});

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(novoValor
                                ? 'Animal visível novamente.'
                                : 'Animal não visível.'),
                          ),
                        );

                        Navigator.pop(context);
                      },
                      child: Text(
                        animal.visivel ? 'Tornar não visível' : 'Tornar visível',
                        style: TextStyle(color: Colors.white),
                      ),
                    )
                ),

              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.pets, size: 32, color: primaryColor),
                  const SizedBox(width: 8),
                  Icon(Icons.pets, size: 32, color: primaryColor),
                  const SizedBox(width: 8),
                  Icon(Icons.pets, size: 32, color: primaryColor),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }


  Widget _buildInfoRow(BuildContext context, IconData icon, String label, String value) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: theme.primaryColor),
          const SizedBox(width: 8),
          Expanded(
            child: Text.rich(
              TextSpan(
                text: '$label ',
                style: theme.textTheme.bodyLarge,
                children: [
                  TextSpan(
                    text: value,
                    style: theme.textTheme.bodyMedium,
                  ),
                ],
              ),
              softWrap: true,
            ),
          ),
        ],
      ),
    );
  }


  Future<void> mostrarPopupAdicionarFotos(BuildContext context, String animalId) async {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Dialog(
          insetPadding: EdgeInsets.all(20),
          child: Container(
            height: MediaQuery.of(context).size.height * 0.8,
            padding: EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Deseja adicionar fotos ao animal agora?',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 30),
                ElevatedButton.icon(
                  onPressed: () async {
                    Navigator.pop(context); // fecha o popup
                    await selecionarEGuardarFotos(animalId);
                  },
                  icon: Icon(Icons.photo),
                  label: Text('Adicionar fotos agora'),
                ),
                SizedBox(height: 10),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context); // fecha o popup
                  },
                  child: Text('Mais tarde'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }


  Future<void> selecionarEGuardarFotos(String animalId) async {
    final picker = ImagePicker();
    final pickedFiles = await picker.pickMultiImage(); // permite selecionar várias imagens

    if (pickedFiles != null && pickedFiles.isNotEmpty) {
      List<String> downloadUrls = [];

      for (var pickedFile in pickedFiles) {
        File imageFile = File(pickedFile.path);
        final fileName = DateTime.now().millisecondsSinceEpoch.toString();
        final storageRef = FirebaseStorage.instance
            .ref()
            .child('animais/$animalId/$fileName.jpg');

        await storageRef.putFile(imageFile);
        String url = await storageRef.getDownloadURL();
        downloadUrls.add(url);
      }

      // Atualizar Firestore com os URLs das imagens
      await FirebaseFirestore.instance
          .collection('animal')
          .doc(animalId)
          .update({
        'imagens': FieldValue.arrayUnion(downloadUrls),
      });

    }
  }


  void confirmarRemocaoAnimal(BuildContext context, Animal animal) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Eliminar Animal'),
        content: Text('De certeza que pretendes eliminar este animal? Esta ação é irreversível.'),
        actions: [
          TextButton(
            child: Text('Cancelar'),
            onPressed: () => Navigator.pop(context),
          ),
          TextButton(
            child: Text('Eliminar', style: TextStyle(color: Colors.red[300])),
            onPressed: () async {
              await apagarAnimal(animal, context);
            },
          ),
        ],
      ),
    );
  }


  Future<void> apagarAnimal(Animal animal, BuildContext context) async {
    final firestore = FirebaseFirestore.instance;
    final uidAtual = FirebaseAuth.instance.currentUser?.uid;

    try {
      // Apaga imagens no Firebase Storage
      for (String url in animal.imagens) {
        try {
          final ref = FirebaseStorage.instance.refFromURL(url);
          await ref.delete();
        } catch (e) {
          print('Erro a apagar imagem: $e');
        }
      }

      // Apaga documento Firestore
      await firestore.collection('animal').doc(animal.uid.toString()).delete();
      // Remover o UID do animal da lista de animais da associação ou do utilizador
      if (isAssoci) {
        await firestore.collection('associacao').doc(uidAtual).update({
          'animais': FieldValue.arrayRemove([animal.uid])

        });
      } else {
        await firestore.collection('utilizador').doc(uidAtual).update({
          'osSeusAnimais': FieldValue.arrayRemove([animal.uid])
        });
      }

      if (!context.mounted) return;

      // Fecha o diálogo explicitamente (caso ainda esteja aberto)
      Navigator.of(context, rootNavigator: true).pop();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Animal eliminado com sucesso.')),
      );

      Navigator.pop(context, {
        'apagado': true,
        'origem': origem,
      });

    } catch (e) {
      print('Erro ao eliminar animal: $e');
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao eliminar o animal.')),
      );
    }
  }




}
