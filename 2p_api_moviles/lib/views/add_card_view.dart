import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../controllers/card_controller.dart';
import '../models/card_model.dart';

class AddCardView extends StatefulWidget {
  final CardController controller;

  const AddCardView({super.key, required this.controller});

  @override
  State<AddCardView> createState() => _AddCardViewState();
}

class _AddCardViewState extends State<AddCardView> {
  final _searchController = TextEditingController();
  List<PokemonCard> _searchResults = [];
  bool _isLoading = false;

  // Método para buscar cartas usando la API
  Future<void> _searchCards(String query) async {
    setState(() {
      _isLoading = true;
      _searchResults = [];
    });

    const String apiUrl = "https://api.pokemontcg.io/v2/cards";
    const String apiKey = "TU_API_KEY"; // Reemplaza esto con tu API Key

    try {
      final response = await http.get(
        Uri.parse('$apiUrl?q=name:$query'),
        headers: {
          "X-Api-Key": apiKey,
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List cards = data['data'];

        setState(() {
          _searchResults = cards.map((card) {
            return PokemonCard(
              id: card['id'],
              name: card['name'],
              imageUrl: card['images']['small'],
              rank: 0, // Puedes asignar un rank por defecto si lo deseas
            );
          }).toList();
        });
      } else {
        throw Exception("Error al buscar cartas");
      }
    } catch (e) {
      print("Error: $e");
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Buscar Cartas Pokémon"),
        backgroundColor: Colors.redAccent,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: [0.4, 0.5, 1.0],  // Posición de los colores en el degradado
            colors: [
              Colors.redAccent, // Parte superior roja (parte superior de la Pokéball)
              Colors.black.withOpacity(0.2), // Color oscuro en el centro
              Colors.white, // Parte inferior blanca (parte inferior de la Pokéball)
            ],
          ),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _searchController,
                decoration: const InputDecoration(
                  labelText: "Nombre de la carta",
                  border: OutlineInputBorder(),
                ),
                onSubmitted: _searchCards, // Realiza la búsqueda al presionar Enter
              ),
            ),
            _isLoading
                ? const CircularProgressIndicator()
                : Expanded(
              child: ListView.builder(
                itemCount: _searchResults.length,
                itemBuilder: (context, index) {
                  final card = _searchResults[index];
                  return ListTile(
                    leading: Image.network(card.imageUrl),
                    title: Text(card.name),
                    onTap: () {
                      widget.controller.addCard(card);
                      Navigator.pop(context);
                    },
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
