/*import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tinder_para_caes/firebaseLogic/associacaoProvider.dart';
import 'package:tinder_para_caes/firebaseLogic/utilizadorProvider.dart';
import 'package:tinder_para_caes/models/pedido.dart';

class ChatDeMensagens extends StatefulWidget {
  @override
  _ChatDeMensagensState createState() => _ChatDeMensagensState();
}

class _ChatDeMensagensState extends State<ChatDeMensagens> {
  List<Map<String, String>> messages = [];
  TextEditingController messageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<AssociacaoProvider>(context).association;

      if (provider == null) {
        final provider = Provider.of<UtilizadorProvider>(context).user;
      }

      if (provider!.associacao) {
        messages.add({
          "sender": "Sistema",
          "message": "Pedido recebido:\n"
              "Usuário: ${provider.pedidosRealizados?.utilizadorQueRealizaOpedido}\n"
              "O que pretende fazer: ${provider.pedidosRealizados?.oQuePretendeFazer}\n"
              "Animal: ${provider.pedidosRealizados?.animalRequesitado}\n"
              "Confirmou requisitos: ${provider.pedidosRealizados!.confirmouTodosOsRequisitos ? "Sim" : "Não"}\n"
              "Mensagem adicional: ${provider.pedidosRealizados?.mensagemAdicional}"
        });
      }
    });
  }

  void sendMessage(String message) {
    if (message.trim().isNotEmpty) {
      final provider = Provider.of<Provider>(context, listen: false);
      setState(() {
        messages.add({
          "sender": provider.isAssociacao ? "Associação" : "Usuário",
          "message": message
        });
      });
      messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ProviderAtivo>(context);
    bool isAssociacao = provider.isAssociacao;

    return Scaffold(
      appBar: AppBar(
        title: Text("Chat"),
        actions: isAssociacao
            ? [
          IconButton(
            icon: Icon(Icons.check, color: Colors.green[300]),
            onPressed: () {
              // Implementar lógica de aceitar pedido
            },
          ),
          IconButton(
            icon: Icon(Icons.close, color: Colors.red[300]),
            onPressed: () {
              // Implementar lógica de recusar pedido
            },
          ),
        ]
            : null,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(8.0),
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final message = messages[index];
                final isUserMessage = message["sender"] == "Usuário";
                return Align(
                  alignment: isUserMessage ? Alignment.centerLeft : Alignment.centerRight,
                  child: Container(
                    padding: EdgeInsets.all(10),
                    margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    decoration: BoxDecoration(
                      color: isUserMessage ? Colors.blue[100] : Colors.green[100],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          message["sender"]!,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 5),
                        Text(message["message"]!),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: messageController,
                    decoration: InputDecoration(
                      hintText: "Escreva uma mensagem...",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: isAssociacao || provider.pedido != null ? () => sendMessage(messageController.text) : null,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}*/

