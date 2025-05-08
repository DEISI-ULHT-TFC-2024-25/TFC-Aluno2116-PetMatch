import 'package:flutter/material.dart';
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


  const AnimalDetailsScreen({
    super.key,
    required this.animal,
    required this.isAssoci,
    required this.uidAssociacao,
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

    return Scaffold(
      appBar: AppBar(
        title: const Text('Perfil do Animal'),
        backgroundColor: primaryColor,
        actions: [
          if (isAssoci)
            TextButton(
              onPressed: () async {
                final novoValor = !animal.visivel;
                await FirebaseFirestore.instance
                    .collection('animal')
                    .doc(animal.chip.toString())
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
            ),
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
                height: 200,
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
                  color: theme.colorScheme.surfaceVariant,
                ),
                child: imagemPerfil == null
                    ? Center(
                  child: Icon(
                    Icons.pets,
                    size: 50,
                    color: theme.colorScheme.onSurface,
                  ),
                )
                    : null,
              ),

              if (isAssoci)
                Align(
                  alignment: Alignment.topRight,
                  child: IconButton(
                    icon: Icon(Icons.add_a_photo, color: primaryColor),
                    onPressed: () async {
                      await mostrarPopupAdicionarFotos(context, animal);
                    },
                  ),
                ),

              const SizedBox(height: 16),
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
              _buildInfoRow(
                context,
                gender == "0" ? Icons.female : Icons.male,
                'Gênero:',
                gender == "0" ? 'Feminino' : 'Masculino',
              ),
              _buildInfoRow(context, Icons.healing, 'Esterilizado:', sterilized ? 'Sim' : 'Não'),
              _buildInfoRow(context, Icons.warning, 'Alergias:', allergies.isEmpty ? 'Nenhuma' : allergies),
              _buildInfoRow(context, Icons.rule, 'Tamanho:', size),
              _buildInfoRow(context, Icons.emoji_emotions, 'Comportamento:', behavior),
              _buildInfoRow(context, Icons.directions_walk, 'Passeios dados:', '$numeroDePasseiosDados'),
              _buildInfoRow(context, Icons.family_restroom, 'Pode apadrinhar:', asGoFather ? 'Não' : 'Sim'),

              if (!isAssoci && !animal.hasGodFather )
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

              const SizedBox(height: 20),
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
        children: [
          Icon(icon, color: theme.primaryColor),
          const SizedBox(width: 8),
          Text(
            label,
            style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              style: theme.textTheme.bodyLarge,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> mostrarPopupAdicionarFotos(BuildContext context, Animal animal) async {
    return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return Dialog(
          insetPadding: const EdgeInsets.all(20),
          child: Container(
            height: MediaQuery.of(context).size.height * 0.8,
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Text(
                  'Deseja adicionar fotos ao perfil?',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 30),
                ElevatedButton.icon(
                  onPressed: () async {
                    Navigator.pop(context);
                    await selecionarEGuardarFotos(context, animal);
                  },
                  icon: const Icon(Icons.photo),
                  label: const Text('Escolher e adicionar'),
                ),
                const SizedBox(height: 10),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancelar'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> selecionarEGuardarFotos(BuildContext context, Animal animal) async {
    final picker = ImagePicker();
    final pickedFiles = await picker.pickMultiImage();

    if (pickedFiles != null && pickedFiles.isNotEmpty) {
      List<String> urls = [];

      for (var file in pickedFiles) {
        File imageFile = File(file.path);
        final ref = FirebaseStorage.instance
            .ref()
            .child('animais/${animal.chip}/${DateTime.now().millisecondsSinceEpoch}.jpg');

        await ref.putFile(imageFile);
        String url = await ref.getDownloadURL();
        urls.add(url);
      }

      await FirebaseFirestore.instance
          .collection('animal')
          .doc(animal.chip.toString())
          .update({
        'imagens': FieldValue.arrayUnion(urls),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Fotos adicionadas com sucesso!')),
      );
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
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => UtilizadorHomeScreen(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Future<void> apagarAnimal(Animal animal, BuildContext context) async {
    final firestore = FirebaseFirestore.instance;

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

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Animal eliminado com sucesso.')),
      );

      Navigator.pop(context); // Volta ao ecrã anterior
    } catch (e) {
      print('Erro ao eliminar animal: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao eliminar o animal.')),
      );
    }
  }




}
