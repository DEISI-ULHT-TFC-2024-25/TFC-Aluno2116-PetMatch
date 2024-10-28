import 'funcionalidades.dart';

class Associacao {
  String nome;
  String sigla;
  String emailGeral;
  String emailParaAlgumaCoisa;
  int telemovelPrincipal;
  int telemovelSecundario;
  String localidade;
  bool mostrarMorada;
  String morada;
  String site;
  int nif; //id
  //preferencias
  List<Funcionalidades?> statusArray = [];

  // Construtor da classe
  Associacao({
    required this.nome,
    required this.sigla,
    required this.emailGeral,
    required this.emailParaAlgumaCoisa,
    required this.telemovelPrincipal,
    required this.telemovelSecundario,
    required this.localidade,
    required this.mostrarMorada,
    required this.morada,
    required this.site,
    required this.nif,

    // TODO descobrir como passar o array das funcionalidades


  });

  factory Associacao.fromMap(Map<String, dynamic> map) {
    return Associacao(
      nome: map['nome'],
      sigla: map['sigla'],
      emailGeral: map['emailGeral'],
      emailParaAlgumaCoisa: map['emailParaAlgumaCoisa'],
      telemovelPrincipal: map['telemovelPrincipal'],
      telemovelSecundario: map['telemovelSecundario'],
      localidade: map['localidade'],
      mostrarMorada: map['mostrarMorada'],
      morada: map['morada'],
      site: map['site'],
      nif: map['nif'],

      //TODO ver como ler o list
    );
  }


  // Método para converter o objeto User em um mapa (útil para converter o objeto em JSON)
  Map<String, dynamic> toMap() {
    return {
      'nome': nome,
      'emailGeral': emailGeral,
      'emailParaAlgumaCoisa': emailParaAlgumaCoisa,
      'telemovelPrincipal': telemovelPrincipal,
      'telemovelSecundario': telemovelSecundario,
      'localidade': localidade,
      'mostrarMorada': mostrarMorada,
      'morada': morada,
      'site': site,
      'nif': nif,

      // TODO mudar a considerar o novo array
      
    };
  }

  // Método para imprimir informações do utilizador (opcional)
  
}
