import 'package:flutter/material.dart';
import 'database_helper.dart';

class FavoritosScreen extends StatefulWidget {
  final List<Map<String, dynamic>> favoritos;
  final Function(List<Map<String, dynamic>>) onFavoritosChanged;

  FavoritosScreen({
    required this.favoritos,
    required this.onFavoritosChanged,
  });

  @override
  _FavoritosScreenState createState() => _FavoritosScreenState();
}

class _FavoritosScreenState extends State<FavoritosScreen> {
  Future<void> removerFavorito(int id) async {
    await DatabaseHelper.instance.deleteFavorito(id);
    final data = await DatabaseHelper.instance.getFavoritos();
    widget.onFavoritosChanged(data);
  }

  @override
  Widget build(BuildContext context) {
    final favoritos = widget.favoritos;

    return favoritos.isEmpty
        ? Center(child: Text("Nenhum favorito ainda."))
        : ListView.builder(
      itemCount: favoritos.length,
      itemBuilder: (context, index) {
        final fav = favoritos[index];
        return Card(
          margin: EdgeInsets.all(10),
          child: ListTile(
            contentPadding: EdgeInsets.all(10),
            leading: Image.network(
              fav["imagem"],
              width: 80,
              fit: BoxFit.cover,
            ),
            title: Text(
              fav["nome"],
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text("${fav["localizacao"]}\n${fav["valor"]}"),
            isThreeLine: true,
            trailing: IconButton(
              icon: Icon(Icons.delete, color: Colors.lightGreen),
              onPressed: () => removerFavorito(fav["id"]),
            ),
          ),
        );
      },
    );
  }
}
