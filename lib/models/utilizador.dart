class Utilizador {
    int nif; //id dos utilizadores
    String nomeCompleto;
    int telemovel;
    bool maiorDeIdade;
    int sexo; //0 - Femnino, 1 - Masculino, 2 - Outros
    String email;
    String morada;
    String codigoPostal;
    String passe;
    
    // Construtor da classe
    Utilizador({
    required this.nif,
    required this.nomeCompleto,
    required this.telemovel,
    required this.maiorDeIdade,
    required this.sexo,
    required this.email,
    required this.morada,
    required this.codigoPostal,
    required this.passe,
    }) ;


  /* Método para criar um objeto Utilizador a partir de um mapa (útil para converter JSON em um objeto Utilizador) faz sentido para os ccaes secalhar
  // ignore: empty_constructor_bodies
  factory Utilizador.fromMap(Map<String, dynamic> map) {
    return Utilizador(
      email: map['email'], 
      nif: null, 
      passe: '', 
      codigoPostal: '', 
      morada: '', 
      sexoOutro: null, 
      nomeCompleto: '', 
      telemovel: null, 
      maiorDeIdade: null, 
      sexoFemenino: null, 
      sexoMasculino: null,
    );
  }

  // Método para converter o objeto Utilizador em um mapa (útil para converter o objeto em JSON)
    Map<String, dynamic> toMap() {
    return {
        'nif': nif,
        'nomeCompleto': nomeCompleto,
        'telemovel': telemovel,
        'maiorDeIdade': maiorDeIdade,
        'sexoFemenino': sexoFemenino,
        'sexoMasculino': sexoMasculino,
        'sexoOutro': sexoOutro,
        'email': email,
        'morada': morada,
        'codigoPostal': codigoPostal,
    };
    }*/


}



