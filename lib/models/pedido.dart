import 'package:tinder_para_caes/models/animal.dart';
import 'package:tinder_para_caes/models/associacao.dart';
import 'package:tinder_para_caes/models/utilizador.dart';
import 'package:tinder_para_caes/models/funcionalidades.dart';

class Pedido {
  Utilizador utilizadorQueRealizaOpedido;
  Funcionalidades oQuePretendeFazer;
  Animal animalRequesitado;
  Associacao associacao;
  bool confirmouTodosOsRequisitos;
  String mensagemAdicional ;

  // Construtor da classe
  Pedido({
    required this.utilizadorQueRealizaOpedido,
    required this.oQuePretendeFazer,
    required this.animalRequesitado,
    required this.associacao,
    required this.confirmouTodosOsRequisitos,
    required this.mensagemAdicional,

  });


  static List<Pedido> getTodosPedidos(){
    List<Pedido> todosOsPedidos = [
      Pedido(utilizadorQueRealizaOpedido: Utilizador.user, oQuePretendeFazer: Funcionalidades.passeiosDosCandeos, animalRequesitado: Animal.todosAnimais.first, associacao: Associacao.procurarAssociacao(0), confirmouTodosOsRequisitos: true, mensagemAdicional: ""),
    ];

    return todosOsPedidos;
  }

}

List<Pedido> todosOsPedidos = [
  Pedido(utilizadorQueRealizaOpedido: Utilizador.user, oQuePretendeFazer: Funcionalidades.passeiosDosCandeos, animalRequesitado: Animal.todosAnimais.first, associacao: Associacao.procurarAssociacao(0), confirmouTodosOsRequisitos: true, mensagemAdicional: ""),
];
