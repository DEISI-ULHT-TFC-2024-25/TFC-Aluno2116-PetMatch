import 'package:firebase_auth/firebase_auth.dart' show FirebaseAuth;
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
  String distrito;
  bool showAddress;
  String address;
  String site;
  int nif;
  List<String> funcionalidades;
  List<String> animais;
  List<String> pedidosRealizados;
  List<Eventos> eventos;
  List<String> necessidades;
  bool associacao;
  String? iban;

  Associacao({
    required this.uid,
    required this.name,
    required this.sigla,
    required this.generalEmail,
    required this.secundaryEmail,
    required this.mainCellphone,
    required this.secundaryCellphone,
    required this.distrito,
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
    this.iban,

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
      distrito: map['distrito'] ?? '',
      showAddress: map['mostrarMorada'] ?? false,
      address: map['morada'] ?? '',
      site: map['site'] ?? '',
      nif: map['nif'] ?? 0,
      funcionalidades: List<String>.from(map['funcionalidades'] ?? []),
      animais: List<String>.from(map['animais'] ?? []),
      pedidosRealizados: (List<String>.from(map['pedidosRealizados'] ?? [])),
      eventos: (map['eventos'] as List<dynamic>?)
          ?.map((e) => Eventos.fromMap(e as Map<String, dynamic>, e['id'] ?? 'id_desconhecido'))
          .toList() ??
          [],
      necessidades: List<String>.from(map['necessidades'] ?? []),
      iban: map['iban'] ?? '',
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
      'distrito': distrito,
      'mostrarMorada': showAddress,
      'morada': address,
      'site': site,
      'nif': nif,
      'funcionalidades': funcionalidades,
      'animais': animais,
      'pedidosRealizados': pedidosRealizados,
      'eventos': eventos.map((e) => e.toMap()).toList(),
      'necessidades': necessidades,
      'iban': iban,
    };
  }

  factory Associacao.fromFirestore(DocumentSnapshot doc) {
    return Associacao.fromMap(doc.id, doc.data() as Map<String, dynamic>);
  }

  Future<List<Animal>> fetchAnimals(List<String> animalUids) async {
    List<Animal> animals = [];
    for (String uid in animalUids) {
      DocumentSnapshot doc =
      await FirebaseFirestore.instance.collection('animal').doc(uid).get(); // <- nome certo
      if (doc.exists) {
        final data = doc.data();

        if (data is Map<String, dynamic>) {
          animals.add(Animal.fromMap(data));
        } else {
          print("Erro: Documento $uid não contém um Map válido. Tipo: ${data.runtimeType}, Conteúdo: $data");
        }
      }
    }
    return animals;
  }


  Future<List<Pedido>> fetchPedidos(List<String> tiposDePedidos, String assocId) async {
    List<Pedido> pedidos = [];

    for (String tipo in tiposDePedidos) {
      // Vai buscar a subcoleção com nome tipo dentro do documento da associação
      final snapshot = await FirebaseFirestore.instance
          .collection('pedidosENotificacoes')
          .doc(assocId)
          .collection(tipo)
          .get();

      for (var doc in snapshot.docs) {
        final data = doc.data();
        pedidos.add(Pedido.fromMap(data, doc.id)); // Supondo que fromMap aceita o ID
      }
    }
    return pedidos;
  }


  static Future<List<Associacao>> getTodasAssociacoesFirebase() async {
    final snapshot = await FirebaseFirestore.instance.collection('associacao').get();
    return snapshot.docs
        .map((doc) => Associacao.fromFirestore(doc))
        .toList();
  }



  static Future<List<Associacao>> getSugestoesAssociacoesFirebase(String distrito) async {
    final snapshot = await FirebaseFirestore.instance.collection('associacao').get();

    return snapshot.docs
        .map((doc) => Associacao.fromFirestore(doc))
        .where((associacao) => associacao.distrito == distrito)
        .toList();
  }

  static Future <String> getNomeAssociacao(String uid) async {
    final snapshot = await FirebaseFirestore.instance.collection('associacao').get();
    final associacao = snapshot.docs
        .map((doc) => Associacao.fromFirestore(doc))
        .firstWhere((a) => a.uid == uid);
    return associacao.name;
  }

    static Future <String?> getIbanAssociacao(String uid) async {
    final snapshot = await FirebaseFirestore.instance.collection('associacao').get();
    final associacao = snapshot.docs
        .map((doc) => Associacao.fromFirestore(doc))
        .firstWhere((a) => a.uid == uid);
    return associacao.iban;
  }


}


