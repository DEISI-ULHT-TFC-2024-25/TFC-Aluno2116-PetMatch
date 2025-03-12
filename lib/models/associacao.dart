import 'package:tinder_para_caes/models/animal.dart';
import 'package:tinder_para_caes/models/pedido.dart';
import 'package:tinder_para_caes/models/eventos.dart';
import 'funcionalidades.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Associacao {
  String uid;
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
  int nif;
  List<Funcionalidade> funcionalidades;
  List<Animal> animais;
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
      mainCellphone: map['telemovelPrincipal'] ?? 0,
      secundaryCellphone: map['telemovelSecundario'] ?? 0,
      local: map['localidade'] ?? '',
      showAddress: map['mostrarMorada'] ?? false,
      address: map['morada'] ?? '',
      site: map['site'] ?? '',
      nif: map['nif'] ?? 0,
      funcionalidades: (map['funcionalidades'] as List<dynamic>?)?.map((f) {
        return Funcionalidade.fromMap(f as Map<String, dynamic>, f['id']);
      }).toList() ?? [],
      animais: (map['animais'] as List<dynamic>?)?.map((a) {
        return Animal.fromMap(a as Map<String, dynamic>);
      }).toList() ?? [],
      pedidosRealizados: (map['pedidosRealizados'] as List<dynamic>?)?.map((p) {
        return Pedido.fromMap(
          p['id'] ?? '',
          p as Map<String, dynamic>,
        );
      }).toList() ?? [],
      eventos: (map['eventos'] as List<dynamic>?)?.map((e) {
        String eventoId = e['id'] ?? 'id_desconhecido';
        return Eventos.fromMap(e as Map<String, dynamic>, eventoId);
      }).toList() ?? [],
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
      'funcionalidades': funcionalidades.map((f) => f.toMap()).toList(),
      'animais': animais.map((a) => a.toMap()).toList(),
      'pedidosRealizados': pedidosRealizados.map((p) => p.toMap()).toList(),
      'eventos': eventos.map((e) => e.toMap()).toList(),
      'necessidades': necessidades,
    };
  }


  factory Associacao.fromFirestore(DocumentSnapshot doc) {
    return Associacao.fromMap(doc.id, doc.data() as Map<String, dynamic>);
  }


  void adicionarAnimais(Animal anim) {
    animais.add(anim);
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
    uid: "associacaoE123",
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
    animais: Animal.todosAnimais,
    pedidosRealizados: [],
    eventos: [],
    necessidades: [],
  ),
  Associacao(
    uid: "associacaoF456",
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
    eventos: [],
    necessidades: [],
  ),
];
