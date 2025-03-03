import 'package:flutter/material.dart';

class ChatUsuarioScreen extends StatefulWidget {
  final String associacao;
  final String oQuePretendeFazer;
  final bool confirmouTodosOsRequisitos;
  final String mensagemInicial;

  ChatUsuarioScreen({
    required this.associacao,
    required this.oQuePretendeFazer,
    required this.confirmouTodosOsRequisitos,
    required this.mensagemInicial,
  });

  @override
  _ChatUsuarioScreenState createState() => _ChatUsuarioScreenState();
}

class _ChatUsuarioScreenState extends State<ChatUsuarioScreen> {
  List<Map<String, String>> messages = [];
  TextEditingController messageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    messages.add({
      "sender": "Você",
      "message": "Olá, estou interessado em ajudar.\n"
          "O que pretendo fazer: ${widget.oQuePretendeFazer}\n"
          "Associação: ${widget.associacao}\n"
          "Confirmou requisitos: ${widget.confirmouTodosOsRequisitos ? "Sim" : "Não"}\n"
          "Mensagem adicional: ${widget.mensagemInicial}"
    });
  }

  void sendMessage(String message) {
    if (message.trim().isNotEmpty) {
      setState(() {
        messages.add({"sender": "Você", "message": message});
      });
      messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Chat com ${widget.associacao}"),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(8.0),
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final message = messages[index];
                final isUserMessage = message["sender"] == "Você";
                return Align(
                  alignment:
                  isUserMessage ? Alignment.centerRight : Alignment.centerLeft,
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

