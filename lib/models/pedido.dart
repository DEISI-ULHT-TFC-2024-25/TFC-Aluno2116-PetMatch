import 'package:tinder_para_caes/models/animal.dart';
import 'package:tinder_para_caes/models/associacao.dart';
import 'package:tinder_para_caes/models/funcionalidades.dart';
import 'package:tinder_para_caes/models/utilizador.dart';


class Pedido {
  Utilizador utilizadorQueRealizaOpedido;
  Funcionalidade oQuePretendeFazer;
  Animal animalRequesitado;
  Associacao associacao;
  bool confirmouTodosOsRequisitos;
  String mensagemAdicional;


  Pedido({
    required this.utilizadorQueRealizaOpedido,
    required this.oQuePretendeFazer,
    required this.animalRequesitado,
    required this.associacao,
    required this.confirmouTodosOsRequisitos,
    required this.mensagemAdicional,
  });


  factory Pedido.fromMap(String documentId, Map<String, dynamic> map) {
    return Pedido(
      utilizadorQueRealizaOpedido: Utilizador.fromMap(
        map['utilizadorQueRealizaOpedido']['uid'] ?? documentId,
        map['utilizadorQueRealizaOpedido'] as Map<String, dynamic>,
      ),
      oQuePretendeFazer: Funcionalidade.fromMap(
        map['oQuePretendeFazer'] as Map<String, dynamic>,
        map['oQuePretendeFazer']['id'] ?? '',
      ),
      animalRequesitado: Animal.fromMap(
        map['animalRequesitado'] as Map<String, dynamic>,
      ),
      associacao: Associacao.fromMap(
        map['associacao']['uid'] ?? documentId,
        map['associacao'] as Map<String, dynamic>,
      ),
      confirmouTodosOsRequisitos: map['confirmouTodosOsRequisitos'] ?? false,
      mensagemAdicional: map['mensagemAdicional'] ?? '',
    );
  }


  Map<String, dynamic> toMap() {
    return {
      'utilizadorQueRealizaOpedido': utilizadorQueRealizaOpedido.toMap(),
      'oQuePretendeFazer': oQuePretendeFazer.toMap(),
      'animalRequesitado': animalRequesitado.toMap(),
      'associacao': associacao.toMap(),
      'confirmouTodosOsRequisitos': confirmouTodosOsRequisitos,
      'mensagemAdicional': mensagemAdicional,
    };
  }
}
