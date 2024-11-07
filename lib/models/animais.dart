class Utilizador {
  int chip; //id dos utilizadores
  String fullName;
  int age;
  bool sterilized;
  int gender; //0 - Femnino, 1 - Masculino, 2 - Outros
  String legalOwner;
  String allergies;
  String size;
  String behavior;
  //fotos..

  // Construtor da classe
  Utilizador({
    required this.chip,
    required this.fullName,
    required this.age,
    required this.sterilized,
    required this.gender,
    required this.legalOwner,
    required this.allergies,
    required this.size,
    required this.behavior,
  });

}