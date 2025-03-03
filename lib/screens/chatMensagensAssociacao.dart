import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  final String utilizador;
  final String genero;
  final String mensagemInicial;
  final String oQuePretendeFazer;
  final String associacao;
  final bool confirmouTodosOsRequisitos;

  ChatScreen({
    required this.utilizador,
    required this.genero,
    required this.mensagemInicial,
    required this.oQuePretendeFazer,
    required this.associacao,
    required this.confirmouTodosOsRequisitos,
  });

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  List<Map<String, String>> messages = []; // ONDE É PARA GUARDAR AS MENSAGENS POSTERIORMENTE NO FIRESTORE
  TextEditingController messageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    messages.add({
      "sender": widget.utilizador,
      "message": "Olá, meu nome é ${widget.utilizador}.\n"
          "Gênero: ${widget.genero}\n"
          "O que pretendo fazer: ${widget.oQuePretendeFazer}\n"
          "Associação: ${widget.associacao}\n"
          "Confirmou requisitos: ${widget.confirmouTodosOsRequisitos ? "Sim" : "Não"}\n"
          "Mensagem adicional: ${widget.mensagemInicial}"
    });
  }

  void sendMessage(String message) {
    if (message.trim().isNotEmpty) {
      setState(() {
        messages.add({"sender": "Associação", "message": message});
      });
      messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Chat com ${widget.utilizador}"),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(8.0),
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final message = messages[index];
                final isUserMessage = message["sender"] == widget.utilizador;
                return Align(
                  alignment:
                  isUserMessage ? Alignment.centerLeft : Alignment.centerRight,
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
                  onPressed: () => sendMessage(messageController.text),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}


