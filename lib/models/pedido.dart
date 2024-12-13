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

  // Construtor da classe
  Pedido({
    required this.utilizadorQueRealizaOpedido,
    required this.oQuePretendeFazer,
    required this.animalRequesitado,
    required this.associacao,
    required this.confirmouTodosOsRequisitos,

  });


  static List<Pedido> getTodosPedidos(){
    List<Pedido> todosOsPedidos = [
      Pedido(utilizadorQueRealizaOpedido: Utilizador.user, oQuePretendeFazer: Funcionalidades.passeiosDosCandeos, animalRequesitado: Animal.todosAnimais.first, associacao: Associacao.procurarAssociacao(0), confirmouTodosOsRequisitos: true),
    ];

    return todosOsPedidos;
  }

}

List<Pedido> todosOsPedidos = [
  Pedido(utilizadorQueRealizaOpedido: Utilizador.user, oQuePretendeFazer: Funcionalidades.passeiosDosCandeos, animalRequesitado: Animal.todosAnimais.first, associacao: Associacao.procurarAssociacao(0), confirmouTodosOsRequisitos: true),
];
