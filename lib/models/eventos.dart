import 'package:cloud_firestore/cloud_firestore.dart';

class Eventos {
  String id;
  String titulo;
  String date;
  String descricao;

  Eventos({
    required this.id,
    required this.titulo,
    required this.date,
    required this.descricao,
  });

  // Criar a partir de um DocumentSnapshot (quando os dados vêm do Firestore)
  factory Eventos.fromDocumentSnapshot(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Eventos(
      id: doc.id,
      titulo: data['titulo'] ?? '',
      date: data['date'] ?? '',
      descricao: data['descricao'] ?? '',
    );
  }

  // Criar a partir de um Map<String, dynamic> (quando os dados já estão formatados como mapa)
  factory Eventos.fromMap(Map<String, dynamic> map, String id) {
    return Eventos(
      id: id,
      titulo: map['titulo'] ?? '',
      date: map['date'] ?? '',
      descricao: map['descricao'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'titulo': titulo,
      'date': date,
      'descricao': descricao,
    };
  }

  // Adicionar um evento ao Firestore
  static Future<void> addEvento(Eventos evento) async {
    await FirebaseFirestore.instance.collection('eventos').add(evento.toMap());
  }

  // Atualizar um evento existente no Firestore
  static Future<void> updateEvento(Eventos evento) async {
    await FirebaseFirestore.instance.collection('eventos').doc(evento.id).update(evento.toMap());
  }

  // Apagar um evento do Firestore
  static Future<void> deleteEvento(String id) async {
    await FirebaseFirestore.instance.collection('eventos').doc(id).delete();
  }

  // Obter todos os eventos do Firestore
  static Stream<List<Eventos>> getEventos() {
    return FirebaseFirestore.instance.collection('eventos').snapshots().map(
          (snapshot) => snapshot.docs.map((doc) => Eventos.fromDocumentSnapshot(doc)).toList(),
    );
  }
}
