import 'funcionalidades.dart';

class Associacao {
  String name;
  String sigla;
  String generalEmail;
  String secundaryEmail;
  int mainCellphone;
  int secundaryCellphone;
  String local;
  bool showAddress;
  String address;
  String site;
  int nif; //id
  //preferencias
  List<Funcionalidades?> funcionalidades = [];

  // Construtor da classe
  Associacao({
    required this.name,
    required this.sigla,
    required this.generalEmail,
    required this.secundaryEmail,
    required this.mainCellphone,
    required this.secundaryCellphone,
    required this.local,
    required this.showAddress,
    required this.address,
    required this.site,
    required this.nif,
    required this.funcionalidades,
  });

  //Associacao.simple()
  //  : name = "0",
  //    local = "0";


  factory Associacao.fromMap(Map<String, dynamic> map) {
    return Associacao(
      name: map['nome'],
      sigla: map['sigla'],
      generalEmail: map['emailGeral'],
      secundaryEmail: map['emailParaAlgumaCoisa'],
      mainCellphone: map['telemovelPrincipal'],
      secundaryCellphone: map['telemovelSecundario'],
      local: map['localidade'],
      showAddress: map['mostrarMorada'],
      address: map['morada'],
      site: map['site'],
      nif: map['nif'],
      funcionalidades: [],
    );
  }

  // Método para converter o objeto User em um mapa (útil para converter o objeto em JSON)
  Map<String, dynamic> toMap() {
    return {
      'nome': name,
      'emailGeral': generalEmail,
      'emailParaAlgumaCoisa': secundaryEmail,
      'telemovelPrincipal': mainCellphone,
      'telemovelSecundario': secundaryCellphone,
      'localidade': local,
      'mostrarMorada': showAddress,
      'morada': address,
      'site': site,
      'nif': nif,
      'funcionalidades': funcionalidades
    };
  }

  // Lista completa de associações para sugestões (em uma aplicação real, isso viria de uma API)
  static final List<Associacao> todasAssociacoes = [
    Associacao(name: "Associação E", local: "Porto", nif:0, sigla: '', generalEmail: '', secundaryEmail: '', mainCellphone: 0, address: '', secundaryCellphone: 0, showAddress: false, site: '', funcionalidades: []),
    Associacao(name: "Associação F", local: "Porto", nif:0, sigla: '', generalEmail: '', secundaryEmail: '', mainCellphone: 0, address: '', secundaryCellphone: 0, showAddress: false, site: '', funcionalidades: []),
    Associacao(name: "Associação G", local: "Portimão", nif:0, sigla: '', generalEmail: '', secundaryEmail: '', mainCellphone: 0, address: '', secundaryCellphone: 0, showAddress: false, site: '', funcionalidades: []),
    Associacao(name: "Associação H", local: "Lisboa", nif:0, sigla: '', generalEmail: '', secundaryEmail: '', mainCellphone: 0, address: '', secundaryCellphone: 0, showAddress: false, site: '', funcionalidades: []),
    Associacao(name: "Associação I", local: "Lisboa", nif:0, sigla: '', generalEmail: '', secundaryEmail: '', mainCellphone: 0, address: '', secundaryCellphone: 0, showAddress: false, site: '', funcionalidades: []),
    Associacao(name: "Associação J", local: "Porto", nif:0, sigla: '', generalEmail: '', secundaryEmail: '', mainCellphone: 0, address: '', secundaryCellphone: 0, showAddress: false, site: '', funcionalidades: []),
    Associacao(name: "Associação K", local: "Lisboa", nif:0, sigla: '', generalEmail: '', secundaryEmail: '', mainCellphone: 0, address: '', secundaryCellphone: 0, showAddress: false, site: '', funcionalidades: []),
    Associacao(name: "Associação L", local: "Porto", nif:0, sigla: '', generalEmail: '', secundaryEmail: '', mainCellphone: 0, address: '', secundaryCellphone: 0, showAddress: false, site: '', funcionalidades: []),
  ];
}
