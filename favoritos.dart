import 'package:flutter/material.dart';
import 'database_helper.dart';

class FavoritosScreen extends StatefulWidget {
  @override
  _FavoritosScreenState createState() => _FavoritosScreenState();
}

class _FavoritosScreenState extends State<FavoritosScreen> {
  List<Map<String, dynamic>> favoritos = [];

  @override
  void initState() {
    super.initState();
    carregarFavoritos();
  }

  Future<void> carregarFavoritos() async {
    final data = await DatabaseHelper.instance.getFavoritos();
    setState(() {
      favoritos = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Favoritos")),
      body: favoritos.isEmpty
          ? Center(child: Text("Nenhum favorito ainda."))
          : ListView.builder(
              itemCount: favoritos.length,
              itemBuilder: (context, index) {
                final fav = favoritos[index];
                return Card(
                  margin: EdgeInsets.all(10),
                  child: ListTile(
                    contentPadding: EdgeInsets.all(10),
                    leading: Image.network(fav["imagem"], width: 80, fit: BoxFit.cover),
                    title: Text(fav["nome"], style: TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text("${fav["localizacao"]}\n${fav["valor"]}"),
                    isThreeLine: true,
                    trailing: IconButton(
                      icon: Icon(Icons.delete, color: Colors.red),
                      onPressed: () async {
                        await DatabaseHelper.instance.deleteFavorito(fav["id"]);
                        carregarFavoritos();
                      },
                    ),
                  ),
                );
              },
            ),
    );
  }
}
