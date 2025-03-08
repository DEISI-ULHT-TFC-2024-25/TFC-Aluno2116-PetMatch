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
  int nif; // ID
  List<Funcionalidades> funcionalidades = [];
  List<Animal> animais = [];
  List<Pedido> pedidosRealizados = [];
  List<Eventos> eventos = [];
  List<String> necessidades = [];
  bool associacao = true;

  // Construtor principal
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
    // eventos e necessidades podem ser inicializados externamente, se quiser
  });

  /// Construtor para criar uma Associacao a partir de um Map (ex.: dados do Firestore)
  factory Associacao.fromMap(Map<String, dynamic> map) {
    return Associacao(
      name: map['nome'] ?? '',
      sigla: map['sigla'] ?? '',
      generalEmail: map['emailGeral'] ?? '',
      secundaryEmail: map['emailParaAlgumaCoisa'] ?? '',
      mainCellphone: map['telemovelPrincipal'] ?? 0,
      secundaryCellphone: map['telemovelSecundario'] ?? 0,
      local: map['localidade'] ?? '',
      showAddress: map['mostrarMorada'] ?? false,
      address: map['morada'] ?? '',
      site: map['site'] ?? '',
      nif: map['nif'] ?? 0,
      funcionalidades: [],        // Ajustar se quiser carregar do Firestore
      animais: [],                // Ajustar se quiser carregar do Firestore
      pedidosRealizados: [],      // Ajustar se quiser carregar do Firestore
    );
  }

  /// Converte o objeto Associacao em Map (para salvar em Firestore ou gerar JSON)
  Map<String, dynamic> toMap() {
    return {
      'nome': name,
      'sigla': sigla,
      'emailGeral': generalEmail,
      'emailParaAlgumaCoisa': secundaryEmail,
      'telemovelPrincipal': mainCellphone,
      'telemovelSecundario': secundaryCellphone,
      'localidade': local,
      'mostrarMorada': showAddress,
      'morada': address,
      'site': site,
      'nif': nif,
      // Se quiser salvar listas de objetos:
      // 'animais': animais.map((animal) => animal.toMap()).toList(),
      // 'funcionalidades': funcionalidades.map((f) => f.toMap()).toList(),
      // 'pedidosRealizados': pedidosRealizados.map((p) => p.toMap()).toList(),
      // 'eventos': eventos.map((e) => e.toMap()).toList(),
      // 'necessidades': necessidades,
    };
  }

  // Função para adicionar um animal à lista de animais
  void adicionarAnimais(Animal anim) {
    animais.add(anim);
  }

  // Exemplo de método para filtrar associações por local
  static List<Associacao> getSugestoesAssociacoes(String local) {
    return todasAssociacoes.where((associacao) => associacao.local == local).toList();
  }

  // Exemplo de método para procurar associação por índice
  static Associacao procurarAssociacao(int id) {
    if (id < 0 || id >= todasAssociacoes.length) {
      throw Exception("Índice $id fora dos limites.");
    }
    return todasAssociacoes[id];
  }
}

// Lista estática de associações para exemplo (em uma aplicação real, viria da base de dados)
List<Associacao> todasAssociacoes = [
  Associacao(
    name: "Associação E",
    local: "Porto",
    nif: 0,
    sigla: '',
    generalEmail: '',
    secundaryEmail: '',
    mainCellphone: 0,
    address: '',
    secundaryCellphone: 0,
    showAddress: false,
    site: '',
    funcionalidades: [],
    animais: Animal.todosAnimais, // Exemplo usando a lista estática de Animal
    pedidosRealizados: [],
  ),
  Associacao(
    name: "Associação F",
    local: "Porto",
    nif: 0,
    sigla: '',
    generalEmail: '',
    secundaryEmail: '',
    mainCellphone: 0,
    address: '',
    secundaryCellphone: 0,
    showAddress: false,
    site: '',
    funcionalidades: [],
    animais: [],
    pedidosRealizados: [],
  ),
  // ... Adicione quantas associações quiser
];
