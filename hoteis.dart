import 'package:flutter/material.dart';
import 'favoritos.dart';
import 'database_helper.dart';

class HotelScreen extends StatefulWidget {
  @override
  _HotelScreenState createState() => _HotelScreenState();
}

class _HotelScreenState extends State<HotelScreen> {
  int selectedIndex = 2; // inicialmente Hotéis
  List<Map<String, dynamic>> favoritos = [];

  final List<Map<String, String>> hoteis = [
    {
      "nome": "Hotel Windsor Excelsior",
      "localizacao": "Rio de Janeiro, RJ",
      "valor": "R\$ 350/noite",
      "imagem":
      "https://www.dicasdonossobrasil.com.br/wp-content/uploads/2018/04/Rio-de-Janeiro-Hotel-Windsor-Excalibur.jpg"
    },
    {
      "nome": "Recanto Cataratas - Thermas, Resort e Convention",
      "localizacao": "Foz do Iguaçu, PR",
      "valor": "R\$ 480/noite",
      "imagem":
      "https://cf.bstatic.com/xdata/images/hotel/max1024x768/414575437.jpg?k=d3017567c933fbd5bd22aae99e9bbb5565cbe46b29066ccb5cf5e477689d1f92&o="
    },
    {
      "nome": "Matsubara Hotel",
      "localizacao": "Maceió, AL",
      "valor": "R\$ 2.200/noite",
      "imagem":
      "https://lh3.googleusercontent.com/gps-cs-s/AC9h4nqOdK9r6hFhJbUoWtDNdRuQ9cA9DRuIn-FsHiaQvOqv7283BwookOXDBpyYFvCw49UqKt5bcLqZOK_LecVLU_Okzsbqh1ZTrf5KXsufmrRmjdzv2jbLAGxg3jLALCA5eEhWhI2N=w287-h192-n-k-rw-no-v1"
    },
    {
      "nome": "Hotel Cercano",
      "localizacao": "Gramado, RS",
      "valor": "R\$ 4.559,99/noite",
      "imagem":
      "https://dynamic-media-cdn.tripadvisor.com/media/photo-o/1a/f1/16/80/hotel-cercano.jpg?w=900&h=500&s=1"
    },
  ];

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

  bool isFavorito(String nome) {
    return favoritos.any((f) => f["nome"] == nome);
  }

  Future<void> toggleFavorito(Map<String, String> hotel) async {
    if (isFavorito(hotel["nome"]!)) {
      final fav = favoritos.firstWhere((f) => f["nome"] == hotel["nome"]);
      await DatabaseHelper.instance.deleteFavorito(fav["id"]);
    } else {
      await DatabaseHelper.instance.insertFavorito({
        "nome": hotel["nome"],
        "localizacao": hotel["localizacao"],
        "valor": hotel["valor"],
        "imagem": hotel["imagem"],
      });
    }
    carregarFavoritos();
  }

  @override
  Widget build(BuildContext context) {
    Widget body;

    switch (selectedIndex) {
      case 0:
        body = Center(child: Text('Home', style: TextStyle(fontSize: 30)));
        break;
      case 1:
        body = Center(child: Text('Cronograma', style: TextStyle(fontSize: 30)));
        break;
      case 2:
        body = buildHotelList();
        break;
      case 3:
        body = FavoritosScreen(
          favoritos: favoritos,
          onFavoritosChanged: (novaLista) {
            setState(() {
              favoritos = novaLista;
            });
          },
        );
        break;
      default:
        body = Center(child: Text('Perfil', style: TextStyle(fontSize: 30)));
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Hotéis"),
        backgroundColor: Colors.green,
      ),
      body: body,
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.green[900],
        currentIndex: selectedIndex,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white54,
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          setState(() {
            selectedIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.event), label: 'Cronograma'),
          BottomNavigationBarItem(icon: Icon(Icons.hotel), label: 'Hotéis'),
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Favoritos'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Perfil'),
        ],
      ),
    );
  }

  Widget buildHotelList() {
    return ListView.builder(
      itemCount: hoteis.length,
      itemBuilder: (context, index) {
        final hotel = hoteis[index];
        bool favorito = isFavorito(hotel["nome"]!);

        return Card(
          margin: EdgeInsets.all(10),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15)),
          elevation: 5,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  ClipRRect(
                    borderRadius:
                    BorderRadius.vertical(top: Radius.circular(15)),
                    child: Image.network(
                      hotel["imagem"]!,
                      height: 200,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned(
                    top: 10,
                    right: 10,
                    child: IconButton(
                      icon: Icon(
                        favorito ? Icons.favorite : Icons.favorite_border,
                        color: favorito ? Colors.lightGreen : Colors.white,
                        size: 30,
                      ),
                      onPressed: () => toggleFavorito(hotel),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      hotel["nome"]!,
                      style: TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 5),
                    Text(
                      hotel["localizacao"]!,
                      style: TextStyle(color: Colors.grey[700]),
                    ),
                    SizedBox(height: 5),
                    Text(
                      hotel["valor"]!,
                      style: TextStyle(
                          fontSize: 16,
                          color: Colors.green,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
