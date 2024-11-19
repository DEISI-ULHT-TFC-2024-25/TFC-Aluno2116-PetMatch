import 'package:flutter/material.dart';

class AdicionarAnimalScreen extends StatelessWidget {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Adicionar Animal"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: "Nome do Animal",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                final newAnimal = _controller.text.trim();
                if (newAnimal.isNotEmpty) {
                  // Aqui você pode adicionar lógica para salvar o novo animal
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Animal '$newAnimal' adicionado!")),
                  );
                }
              },
              child: Text("Salvar"),
            ),
          ],
        ),
      ),
    );
  }
}
