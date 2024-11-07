import 'package:flutter/material.dart';

class UHomeScreen extends StatefulWidget {
  @override
  _UHomeScreenState createState() => _UHomeScreenState();
}

class _UHomeScreenState extends State<UHomeScreen> {
  String _selectedLocation = "Sua localização atual";

  // Função para abrir o pop-up e escolher uma nova localização
  void _chooseLocation() async {
    String? newLocation = await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        String locationInput = "";
        return AlertDialog(
          title: Text("Escolha uma localização"),
          content: TextField(
            onChanged: (value) {
              locationInput = value;
            },
            decoration: InputDecoration(hintText: "Digite a zona desejada"),
          ),
          actions: <Widget>[
            TextButton(
              child: Text("Cancelar"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text("Confirmar"),
              onPressed: () {
                Navigator.of(context).pop(locationInput);
              },
            ),
          ],
        );
      },
    );

    if (newLocation != null && newLocation.isNotEmpty) {
      setState(() {
        _selectedLocation = newLocation;
        // Aqui você poderá integrar a API de mapa no futuro
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("UHomeScreen"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Texto "Perto de si" e botão para escolher localização
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Perto de si",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                TextButton(
                  onPressed: _chooseLocation,
                  child: Text("Escolher outra localização"),
                ),
              ],
            ),
            // Espaço para o nome da localização selecionada
            Text(
              "Localização: $_selectedLocation",
              style: TextStyle(fontSize: 16, color: Colors.grey[700]),
            ),
            SizedBox(height: 16.0),
            // Espaço em branco para o futuro mapa
            Container(
              height: 200,
              color: Colors.grey[300],
              alignment: Alignment.center,
              child: Text(
                "Espaço para o mapa",
                style: TextStyle(color: Colors.grey[600]),
              ),
            ),
            SizedBox(height: 24.0),
            // Título da lista
            Text(
              "Patudos recentemente passeados",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 12.0),
            // Lista com uma posição em branco por agora
            Expanded(
              child: ListView.builder(
                itemCount: 1,
                itemBuilder: (context, index) {
                  return Container(
                    height: 80,
                    margin: EdgeInsets.symmetric(vertical: 8.0),
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      "Espaço em branco - posição $index",
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
