import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter/services.dart' show rootBundle;

class Animal {
  int chip; //id dos utilizadores
  String fullName;
  int age;
  bool sterilized;
  int gender; //0 - Femnino, 1 - Masculino,
  String legalOwner;
  String allergies;
  String size;
  String behavior;
  String breed; //fazer listas de raças
  String species; // fazer listas de especies
  int numeroDePasseiosDados;
  bool asGodFather;
  //fotos..

  // Construtor da classe
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
    required this.asGodFather,
  });


  static Future<List<String>> loadDogBreeds() async {
    final String response = await rootBundle.loadString('assets/dogBreeds.txt');
    return response.split('\n').map((line) => line.trim()).toList();

  }



  // Lista completa de animais para sugestões
  static final List<Animal> todosAnimais = [
    Animal(chip: 1111, fullName: "Nikitta Coelho", age:10, sterilized:true, gender: 0, legalOwner: "Catia Coelho", allergies:"só ao juizo", size:"Medium", behavior: "Acusada injustamente de todos os danos causados em casa", breed: "diabo-da-tasmânia", species: "dog", numeroDePasseiosDados: 0, asGodFather: true),
    Animal(chip: 1112, fullName: "Ninja Coelho", age:14, sterilized:true, gender: 1, legalOwner: "Diogo Coelho", allergies:"ao polen", size:"Medium", behavior: "so dorme e ressona", breed: "Chow-Chow", species: "dog", numeroDePasseiosDados: 0, asGodFather: true),
    Animal(chip: 1113, fullName: "Gouda Coelho", age:8, sterilized:true, gender: 0, legalOwner: "Hugo Coelho", allergies:"nenhumas", size:"Giant", behavior: "um bebe grande", breed: "indefenido", species: "dog", numeroDePasseiosDados: 0, asGodFather: false),
    Animal(chip: 1114, fullName: "Miny Coelho", age:12, sterilized:true, gender: 0, legalOwner: "Carmen Coelho", allergies:"a outros caes", size:"Medium", behavior: "não se dá a outros com outros cães", breed: "pastor-alemão/pit", species: "dog", numeroDePasseiosDados: 0, asGodFather: true),
    Animal(chip: 1115, fullName: "Patas Coelho", age:11, sterilized:true, gender: 0, legalOwner: "Carmen Coelho", allergies:"a homens", size:"Medium", behavior: "questionavel", breed: "indefenido", species: "dog", numeroDePasseiosDados: 0, asGodFather: true),
  ];

}