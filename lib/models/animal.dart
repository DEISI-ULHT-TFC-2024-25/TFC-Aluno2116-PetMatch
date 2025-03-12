import 'dart:convert';
import 'package:flutter/services.dart';

class Animal {
  int chip;                  // ID (chip)
  String fullName;
  int age;                   // Idade
  bool sterilized;
  int gender;                // 0 - Feminino, 1 - Masculino
  String legalOwner;
  String allergies;
  String size;
  String behavior;
  String breed;             // Raça
  String species;           // Espécie
  int numeroDePasseiosDados;
  bool hasGodFather;


  Animal({
    required this.chip,
    required this.fullName,
    required this.age,
    required this.sterilized,
    required this.gender,
    required this.legalOwner,
    required this.allergies,
    required this.size,
    required this.behavior,
    required this.breed,
    required this.species,
    required this.numeroDePasseiosDados,
    required this.hasGodFather,
  });


  factory Animal.fromMap(Map<String, dynamic> map) {
    return Animal(
      chip: map['chip'] ?? 0,
      fullName: map['fullName'] ?? '',
      age: map['age'] ?? 0,
      sterilized: map['sterilized'] ?? false,
      gender: map['gender'] ?? 0,
      legalOwner: map['legalOwner'] ?? '',
      allergies: map['allergies'] ?? '',
      size: map['size'] ?? '',
      behavior: map['behavior'] ?? '',
      breed: map['breed'] ?? '',
      species: map['species'] ?? '',
      numeroDePasseiosDados: map['numeroDePasseiosDados'] ?? 0,
      hasGodFather: map['hasGodFather'] ?? false,
    );
  }


  Map<String, dynamic> toMap() {
    return {
      'chip': chip,
      'fullName': fullName,
      'age': age,
      'sterilized': sterilized,
      'gender': gender,
      'legalOwner': legalOwner,
      'allergies': allergies,
      'size': size,
      'behavior': behavior,
      'breed': breed,
      'species': species,
      'numeroDePasseiosDados': numeroDePasseiosDados,
      'hasGodFather': hasGodFather,
    };
  }


  static Future<List<String>> loadDogBreeds() async {
    final String response = await rootBundle.loadString('assets/dogBreeds.txt');
    return response.split('\n').map((line) => line.trim()).toList();
  }


  static final List<Animal> todosAnimais = [
    Animal(
      chip: 1111,
      fullName: "Nikitta Coelho",
      age: 10,
      sterilized: true,
      gender: 0,
      legalOwner: "Catia Coelho",
      allergies: "só ao juizo",
      size: "Medium",
      behavior: "Acusada injustamente de todos os danos causados em casa",
      breed: "diabo-da-tasmânia",
      species: "dog",
      numeroDePasseiosDados: 0,
      hasGodFather: true,
    ),
    Animal(
      chip: 1112,
      fullName: "Ninja Coelho",
      age: 14,
      sterilized: true,
      gender: 1,
      legalOwner: "Diogo Coelho",
      allergies: "ao polen",
      size: "Medium",
      behavior: "só dorme e ressona",
      breed: "Chow-Chow",
      species: "dog",
      numeroDePasseiosDados: 0,
      hasGodFather: true,
    ),
    Animal(
      chip: 1113,
      fullName: "Gouda Coelho",
      age: 8,
      sterilized: true,
      gender: 0,
      legalOwner: "Hugo Coelho",
      allergies: "nenhumas",
      size: "Giant",
      behavior: "um bebé grande",
      breed: "indefinido",
      species: "dog",
      numeroDePasseiosDados: 0,
      hasGodFather: false,
    ),
    Animal(
      chip: 1114,
      fullName: "Miny Coelho",
      age: 12,
      sterilized: true,
      gender: 0,
      legalOwner: "Carmen Coelho",
      allergies: "a outros cães",
      size: "Medium",
      behavior: "não se dá com outros cães",
      breed: "pastor-alemão/pit",
      species: "dog",
      numeroDePasseiosDados: 0,
      hasGodFather: true,
    ),
    Animal(
      chip: 1115,
      fullName: "Patas Coelho",
      age: 11,
      sterilized: true,
      gender: 0,
      legalOwner: "Carmen Coelho",
      allergies: "a homens",
      size: "Medium",
      behavior: "questionável",
      breed: "indefinido",
      species: "dog",
      numeroDePasseiosDados: 0,
      hasGodFather: true,
    ),
  ];
}
