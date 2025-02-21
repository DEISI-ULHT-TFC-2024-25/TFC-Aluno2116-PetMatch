import 'associacao.dart';

class Utilizador {
    int nif; //id dos utilizadores
    String fullName;
    int cellphone;
    bool isAdult;
    int gender; //0 - Femnino, 1 - Masculino, 2 - Outros
    String email;
    String address;
    String local;
    String zipCode;
    String password;

    List<Associacao> associacoesEmQueEstaEnvolvido = [];
    bool associacao = false;

    
    // Construtor da classe
    Utilizador({
    required this.nif,
    required this.fullName,
    required this.cellphone,
    required this.isAdult,
    required this.gender,
    required this.email,
    required this.address,
    required this.local,
    required this.zipCode,
    required this.password,
    required this.associacoesEmQueEstaEnvolvido,
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

// Exemplo de dados do utilizador e associações
    static final Utilizador user = new Utilizador(
        nif: 1234567,
        fullName: "Pedro Alves",
        cellphone: 999999999,
        isAdult: true,
        gender: 1,
        email: "pedro.alves@ulusofona.pt",
        address: "Campo Grande 376",
        local: "Lisboa",
        zipCode: "123456-123",
        password: "123abc",

        associacoesEmQueEstaEnvolvido: [
            Associacao(name: "Associação A", local: "Lisboa", nif:0, sigla: '', generalEmail: '', secundaryEmail: '', mainCellphone: 0, address: '', secundaryCellphone: 0, showAddress: false, site: '', funcionalidades: [], animais: [], pedidosRealizados:[]),
            Associacao(name: "Associação B", local: "Porto", nif:0, sigla: '', generalEmail: '', secundaryEmail: '', mainCellphone: 0, address: '', secundaryCellphone: 0, showAddress: false, site: '', funcionalidades: [], animais: [], pedidosRealizados:[]),
            Associacao(name: "Associação C", local: "Porto", nif:0, sigla: '', generalEmail: '', secundaryEmail: '', mainCellphone: 0, address: '', secundaryCellphone: 0, showAddress: false, site: '', funcionalidades: [], animais: [], pedidosRealizados:[]),
            Associacao(name: "Associação D", local: "Porto", nif:0, sigla: '', generalEmail: '', secundaryEmail: '', mainCellphone: 0, address: '', secundaryCellphone: 0, showAddress: false, site: '', funcionalidades: [], animais: [], pedidosRealizados:[]),

        ],
    );
}
