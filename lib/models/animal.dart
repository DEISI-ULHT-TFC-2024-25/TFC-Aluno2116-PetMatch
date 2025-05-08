import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';

class Animal {
  int chip;
  String fullName;
  DateTime dataNascimento;
  bool sterilized;
  String gender;
  String legalOwner;
  String donoID;
  String allergies;
  String size;
  String behavior;
  String breed;
  String species;
  int numeroDePasseiosDados;
  bool hasGodFather;
  bool hasFat;
  List<String> imagens;
  String uid;
  bool visivel;

  Animal({
    required this.chip,
    required this.fullName,
    required this.dataNascimento,
    required this.sterilized,
    required this.gender,
    required this.legalOwner,
    required this.donoID,
    required this.allergies,
    required this.size,
    required this.behavior,
    required this.breed,
    required this.species,
    required this.numeroDePasseiosDados,
    required this.hasGodFather,
    required this.hasFat,
    required this.imagens,
    required this.uid,
    required this.visivel,
  });

  factory Animal.fromMap(Map<String, dynamic> map) {
    return Animal(
      chip: map['chip'] ?? 0,
      fullName: map['nome'] ?? '',
      dataNascimento: (map['dataNascimento'] as Timestamp).toDate(),
      sterilized: map['castrado'] ?? false,
      gender: map['genero'] ?? "",
      legalOwner: map['donoLegal'] ?? '',
      donoID: map['donoID'] ?? '',
      allergies: map['alergias'] ?? '',
      size: map['porte'] ?? '',
      behavior: map['comportamento'] ?? '',
      breed: map['raca'] ?? '',
      species: map['especie'] ?? '',
      numeroDePasseiosDados: map['numeroDePasseiosDados'] ?? 0,
      hasGodFather: map['temPadrinho'] ?? false,
      hasFat: map['temFat']?? false,
      imagens: List<String>.from(map['imagens'] ?? []),
      uid: map['uid'] ?? '',
      visivel: map['visivel'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'chip': chip,
      'fullName': fullName,
      'dataNascimento': dataNascimento,
      'sterilized': sterilized,
      'gender': gender,
      'legalOwner': legalOwner,
      'donoID': donoID,
      'allergies': allergies,
      'size': size,
      'behavior': behavior,
      'breed': breed,
      'species': species,
      'numeroDePasseiosDados': numeroDePasseiosDados,
      'hasGodFather': hasGodFather,
      'hasFat': hasFat,
      'imagens': imagens,
      'uid' : uid,
      'visivel' : visivel,
    };
  }

  static Future<List<String>> loadDogBreeds() async {
    final String response = await rootBundle.loadString('assets/dogBreeds.txt');
    return response.split('\n').map((line) => line.trim()).toList();
  }

  String calcularIdade() {
    final hoje = DateTime.now();
    int anos = hoje.year - dataNascimento.year;
    int meses = hoje.month - dataNascimento.month;
    int dias = hoje.day - dataNascimento.day;
    if (dias < 0) {
      meses--;
    }
    if (meses < 0) {
      anos--;
      meses += 12;
    }
    if (anos < 1) {
      return '$meses mês${meses == 1 ? '' : 'es'}';
    } else {
      return '$anos ano${anos == 1 ? '' : 's'}';
    }
  }



}
