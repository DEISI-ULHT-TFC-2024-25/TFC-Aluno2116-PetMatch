import 'package:flutter/material.dart';
import 'package:tinder_para_caes/models/animal.dart';

class AnimalDetailsScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    Animal animalExemplo = Animal.todosAnimais[3];

    final String fullName = animalExemplo.fullName;
    final int age = animalExemplo.age;
    final bool sterilized = animalExemplo.sterilized;
    final int gender = animalExemplo.gender; // 0 - Feminino, 1 - Masculino
    final String allergies = animalExemplo.allergies;
    final String size = animalExemplo.size;
    final String behavior = animalExemplo.behavior;
    final String breed = animalExemplo.breed;
    final String species = animalExemplo.species;
    final int numeroDePasseiosDados = animalExemplo.numeroDePasseiosDados;
    final bool asGoFather = animalExemplo.asGodFather;



    return Scaffold(
      appBar: AppBar(
        title: Text('Perfil do Animal'),
        backgroundColor: Colors.redAccent,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Espaço para foto do animal
              Container(
                height: 200,
                decoration: BoxDecoration(
                  color: Colors.grey[400],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.redAccent, width: 2),
                ),
                child: Center(
                  child: Icon(
                    Icons.add_a_photo,
                    size: 50,
                    color: Colors.redAccent,
                  ),
                ),
              ),
              SizedBox(height: 16),
              // Nome do Animal
              Text(
                fullName,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.redAccent,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 8),
              // Informações do animal
              _buildInfoRow(Icons.pets, 'Espécie:', species),
              _buildInfoRow(Icons.badge, 'Raça:', breed),
              _buildInfoRow(Icons.cake, 'Idade:', '$age anos'),
              _buildInfoRow(
                gender == 0 ? Icons.female : Icons.male,
                'Gênero:',
                gender == 0 ? 'Feminino' : 'Masculino',
              ),
              _buildInfoRow(Icons.healing, 'Esterilizado:', sterilized ? 'Sim' : 'Não'),
              _buildInfoRow(Icons.warning, 'Alergias:', allergies.isEmpty ? 'Nenhuma' : allergies),
              _buildInfoRow(Icons.rule, 'Tamanho:', size),
              _buildInfoRow(Icons.emoji_emotions, 'Comportamento:', behavior),
              _buildInfoRow(Icons.directions_walk, 'Passeios dados:', '$numeroDePasseiosDados'),
              _buildInfoRow(Icons.family_restroom, 'Pode apadrinhar:', asGoFather ? 'Não' : 'Sim'),
              // Ícones de patinhas decorativas
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.pets, size: 32, color: Colors.redAccent),
                  SizedBox(width: 8),
                  Icon(Icons.pets, size: 32, color: Colors.redAccent),
                  SizedBox(width: 8),
                  Icon(Icons.pets, size: 32, color: Colors.redAccent),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, color: Colors.redAccent),
          SizedBox(width: 8),
          Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              style: TextStyle(fontSize: 16),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
