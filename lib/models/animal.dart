import 'package:flutter/services.dart';

class Animal {
  int chip;
  String fullName;
  int age;
  bool sterilized;
  String gender;
  String legalOwner;
  String allergies;
  String size;
  String behavior;
  String breed;
  String species;
  int numeroDePasseiosDados;
  bool hasGodFather;
  bool hasFat;
  List<String> imagens; // NOVO CAMPO

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
    required this.hasFat,
    required this.imagens,
  });

  factory Animal.fromMap(Map<String, dynamic> map) {
    return Animal(
      chip: map['chip'] ?? 0,
      fullName: map['nome'] ?? '',
      age: map['idade'] ?? 0,
      sterilized: map['castrado'] ?? false,
      gender: map['genero'] ?? "",
      legalOwner: map['donoLegal'] ?? '',
      allergies: map['alergias'] ?? '',
      size: map['porte'] ?? '',
      behavior: map['comportamento'] ?? '',
      breed: map['raca'] ?? '',
      species: map['especie'] ?? '',
      numeroDePasseiosDados: map['numeroDePasseiosDados'] ?? 0,
      hasGodFather: map['temPadrinho'] ?? false,
      hasFat: map['temFat']?? false,
      imagens: List<String>.from(map['imagens'] ?? []),
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
      'hasFat': hasFat,
      'imagens': imagens,
    };
  }

  static Future<List<String>> loadDogBreeds() async {
    final String response = await rootBundle.loadString('assets/dogBreeds.txt');
    return response.split('\n').map((line) => line.trim()).toList();
  }

}
