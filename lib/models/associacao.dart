import 'package:tinder_para_caes/models/animal.dart';
import 'package:tinder_para_caes/models/pedido.dart';
import 'package:tinder_para_caes/models/eventos.dart';

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
  List<Funcionalidades> funcionalidades = [];
  //animais da associação
  List<Animal> animais = [];

  //notificação de pedidos feitos a utilizadores
  List<Pedido> pedidosRealizados = [];

  //Eventos
  List<Eventos> eventos =[];
  List<String> necessidades = [];


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
    required this.animais,
    required this.pedidosRealizados,
  });

  //Associacao.simple()
  //  : name = "0",
  //    local = "0";



  static Associacao procurarAssociacao(int id) {
    if (id < 0 || id >= todasAssociacoes.length) {
      throw Exception("Índice $id fora dos limites.");
    }
    return todasAssociacoes[id];
  }

  static Associacao procurarAssociacao_old(int id) {
    List<Associacao> Associacoes = [
      Associacao(name: "Associação E", local: "Porto", nif:0, sigla: '', generalEmail: '', secundaryEmail: '', mainCellphone: 0, address: '', secundaryCellphone: 0, showAddress: false, site: '', funcionalidades: [], animais: Animal.todosAnimais, pedidosRealizados:Pedido.getTodosPedidos()),
      Associacao(name: "Associação F", local: "Porto", nif:0, sigla: '', generalEmail: '', secundaryEmail: '', mainCellphone: 0, address: '', secundaryCellphone: 0, showAddress: false, site: '', funcionalidades: [], animais: [], pedidosRealizados:[]),
      Associacao(name: "Associação G", local: "Portimão", nif:0, sigla: '', generalEmail: '', secundaryEmail: '', mainCellphone: 0, address: '', secundaryCellphone: 0, showAddress: false, site: '', funcionalidades: [], animais: [], pedidosRealizados:[]),
      Associacao(name: "Associação H", local: "Lisboa", nif:0, sigla: '', generalEmail: '', secundaryEmail: '', mainCellphone: 0, address: '', secundaryCellphone: 0, showAddress: false, site: '', funcionalidades: [],animais: [],pedidosRealizados:[]),
      Associacao(name: "Associação I", local: "Lisboa", nif:0, sigla: '', generalEmail: '', secundaryEmail: '', mainCellphone: 0, address: '', secundaryCellphone: 0, showAddress: false, site: '', funcionalidades: [], animais: [], pedidosRealizados:[]),
      Associacao(name: "Associação J", local: "Porto", nif:0, sigla: '', generalEmail: '', secundaryEmail: '', mainCellphone: 0, address: '', secundaryCellphone: 0, showAddress: false, site: '', funcionalidades: [], animais: [], pedidosRealizados:[]),
      Associacao(name: "Associação K", local: "Lisboa", nif:0, sigla: '', generalEmail: '', secundaryEmail: '', mainCellphone: 0, address: '', secundaryCellphone: 0, showAddress: false, site: '', funcionalidades: [], animais: [], pedidosRealizados:[]),
      Associacao(name: "Associação L", local: "Porto", nif:0, sigla: '', generalEmail: '', secundaryEmail: '', mainCellphone: 0, address: '', secundaryCellphone: 0, showAddress: false, site: '', funcionalidades: [], animais: [], pedidosRealizados:[]),
    ];

    return Associacoes[id];
  }

  // Função para filtrar associações sugeridas com base na localidade do usuário
  static List<Associacao> getSugestoesAssociacoes(String local) {
    return todasAssociacoes.where((associacao) =>
    associacao.local == local
    ).toList();
  }


  /*static Associacao procurarAssociacaoPorNome(String nome) {
    return todasAssociacoes.firstWhere(
          (associacao) => associacao.name == nome,
          orElse: () => throw Exception("Associação com o nome '$nome' não encontrada."),
    );
  }*/



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
      animais: [],
      pedidosRealizados: []

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

  // Função para adicionar animais
  void adicionarAnimais(Associacao assoc, Animal anim) {
    return assoc.animais.add(anim);
  }

}

// Lista completa de associações para sugestões (em uma aplicação real, isso viria da base de dados)
List<Associacao> todasAssociacoes = [
  Associacao(name: "Associação E", local: "Porto", nif:0, sigla: '', generalEmail: '', secundaryEmail: '', mainCellphone: 0, address: '', secundaryCellphone: 0, showAddress: false, site: '', funcionalidades: [], animais: Animal.todosAnimais, pedidosRealizados: []),
  Associacao(name: "Associação F", local: "Porto", nif:0, sigla: '', generalEmail: '', secundaryEmail: '', mainCellphone: 0, address: '', secundaryCellphone: 0, showAddress: false, site: '', funcionalidades: [], animais: [], pedidosRealizados:[]),
  Associacao(name: "Associação G", local: "Portimão", nif:0, sigla: '', generalEmail: '', secundaryEmail: '', mainCellphone: 0, address: '', secundaryCellphone: 0, showAddress: false, site: '', funcionalidades: [], animais: [], pedidosRealizados:[]),
  Associacao(name: "Associação H", local: "Lisboa", nif:0, sigla: '', generalEmail: '', secundaryEmail: '', mainCellphone: 0, address: '', secundaryCellphone: 0, showAddress: false, site: '', funcionalidades: [],animais: [Animal.todosAnimais.first],pedidosRealizados:[]),
  Associacao(name: "Associação I", local: "Lisboa", nif:0, sigla: '', generalEmail: '', secundaryEmail: '', mainCellphone: 0, address: '', secundaryCellphone: 0, showAddress: false, site: '', funcionalidades: [], animais: [], pedidosRealizados:[]),
  Associacao(name: "Associação J", local: "Porto", nif:0, sigla: '', generalEmail: '', secundaryEmail: '', mainCellphone: 0, address: '', secundaryCellphone: 0, showAddress: false, site: '', funcionalidades: [], animais: [], pedidosRealizados:[]),
  Associacao(name: "Associação K", local: "Lisboa", nif:0, sigla: '', generalEmail: '', secundaryEmail: '', mainCellphone: 0, address: '', secundaryCellphone: 0, showAddress: false, site: '', funcionalidades: [], animais: [], pedidosRealizados:[]),
  Associacao(name: "Associação L", local: "Porto", nif:0, sigla: '', generalEmail: '', secundaryEmail: '', mainCellphone: 0, address: '', secundaryCellphone: 0, showAddress: false, site: '', funcionalidades: [], animais: [], pedidosRealizados:[]),
];