import 'package:tinder_para_caes/models/animal.dart';
import 'package:tinder_para_caes/models/pedido.dart';
import 'package:tinder_para_caes/models/eventos.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'funcionalidades.dart';

class Associacao {
  String uid;
  String name;
  String sigla;
  String generalEmail;
  String secundaryEmail;
  String mainCellphone;
  String secundaryCellphone;
  String local;
  bool showAddress;
  String address;
  String site;
  int nif;
  List<Funcionalidades> funcionalidades; // Ajustado para corresponder ao enum
  List<String> animais;
  List<Pedido> pedidosRealizados;
  List<Eventos> eventos;
  List<String> necessidades;
  bool associacao;

  Associacao({
    required this.uid,
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
    required this.eventos,
    required this.necessidades,
    this.associacao = true,
  });

  factory Associacao.fromMap(String documentId, Map<String, dynamic> map) {
    return Associacao(
      uid: documentId,
      name: map['nome'] ?? '',
      sigla: map['sigla'] ?? '',
      generalEmail: map['emailGeral'] ?? '',
      secundaryEmail: map['emailParaAlgumaCoisa'] ?? '',
      mainCellphone: map['telemovelPrincipal'] ?? '',
      secundaryCellphone: map['telemovelSecundario'] ?? '',
      local: map['localidade'] ?? '',
      showAddress: map['mostrarMorada'] ?? false,
      address: map['morada'] ?? '',
      site: map['site'] ?? '',
      nif: map['nif'] ?? 0,
      funcionalidades: (map['funcionalidades'] as List<dynamic>?)
          ?.map((f) => Funcionalidades.values.firstWhere(
              (element) => element.toString().split('.').last == f)).toList() ??
          [],
      animais: List<String>.from(map['animais'] ?? []),
      pedidosRealizados: (map['pedidosRealizados'] as List<dynamic>?)
          ?.map((p) => Pedido.fromMap(p['id'] ?? '', p as Map<String, dynamic>))
          .toList() ??
          [],
      eventos: (map['eventos'] as List<dynamic>?)
          ?.map((e) => Eventos.fromMap(e as Map<String, dynamic>, e['id'] ?? 'id_desconhecido'))
          .toList() ??
          [],
      necessidades: List<String>.from(map['necessidades'] ?? []),
    );
  }

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
      'funcionalidades': funcionalidades.map((f) => f.toString().split('.').last).toList(),
      'animais': animais,
      'pedidosRealizados': pedidosRealizados.map((p) => p.toMap()).toList(),
      'eventos': eventos.map((e) => e.toMap()).toList(),
      'necessidades': necessidades,
    };
  }

  factory Associacao.fromFirestore(DocumentSnapshot doc) {
    return Associacao.fromMap(doc.id, doc.data() as Map<String, dynamic>);
  }

  Future<List<Animal>> fetchAnimals(List<String> animalUids) async {
    List<Animal> animals = [];

    for (String uid in animalUids) {
      DocumentSnapshot doc =
      await FirebaseFirestore.instance.collection('animals').doc(uid).get();
      if (doc.exists) {
        animals.add(Animal.fromMap(doc.data() as Map<String, dynamic>));
      }
    }

    return animals;
  }

  static List<Associacao> getSugestoesAssociacoes(String local) {
    return todasAssociacoes.where((associacao) => associacao.local == local).toList();
  }

  static Associacao procurarAssociacao(int id) {
    if (id < 0 || id >= todasAssociacoes.length) {
      throw Exception("Índice $id fora dos limites.");
    }
    return todasAssociacoes[id];
  }
}

List<Associacao> todasAssociacoes = [
  Associacao(
    uid: "associacaoF456",
    name: "Associação F",
    local: "Porto",
    nif: 0,
    sigla: '',
    generalEmail: '',
    secundaryEmail: '',
    mainCellphone: " ",
    address: '',
    secundaryCellphone: " ",
    showAddress: false,
    site: '',
    funcionalidades: [],
    animais: [],
    pedidosRealizados: [],
    eventos: [],
    necessidades: [],
  ),
];
