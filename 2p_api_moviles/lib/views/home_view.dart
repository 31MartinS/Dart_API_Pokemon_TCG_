import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/card_controller.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Ranking de Cartas Pokémon", style: TextStyle(fontSize: 24)),
        centerTitle: true,
        backgroundColor: Colors.redAccent,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          color: Color(0xFFF5F5F5), // Fondo color coconut
          backgroundBlendMode: BlendMode.softLight, // Sutil efecto de mezcla para textura
        ),
        child: Consumer<CardController>(
          builder: (context, controller, child) {
            final cards = controller.rankedCards;

            if (cards.isEmpty) {
              return const Center(
                child: Text("No hay cartas en el ranking. ¡Agrega algunas!", style: TextStyle(fontSize: 18, color: Colors.black)),
              );
            }

            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // 2 columnas por fila
                  crossAxisSpacing: 10, // Espacio entre las cartas
                  mainAxisSpacing: 10, // Espacio entre las filas
                  childAspectRatio: 0.95, // Ajusta la relación de aspecto para más espacio en la imagen
                ),
                itemCount: cards.length,
                itemBuilder: (context, index) {
                  final card = cards[index];
                  return Card(
                    elevation: 8, // Menor elevación para un aspecto más sutil
                    shape: RoundedRectangleBorder(
                      side: BorderSide(
                        color: _getTierColor(card.tier), // Colores más intensos para el borde según el tier
                        width: 3, // Grosor del borde reducido
                      ),
                      borderRadius: BorderRadius.circular(16), // Esquinas más redondeadas
                    ),
                    color: Colors.white, // Color de fondo blanco para la carta
                    shadowColor: Colors.black.withOpacity(0.1), // Sombra más suave para menos intensidad
                    child: IntrinsicHeight( // Asegura que la altura se ajuste al contenido
                      child: Column(
                        mainAxisSize: MainAxisSize.min, // Hace que la columna ocupe solo el espacio necesario
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(16), // Esquinas redondeadas para la imagen
                            child: Image.network(
                              card.imageUrl,
                              width: double.infinity, // Hace que la imagen ocupe el ancho completo de la tarjeta
                              height: 375, // Aumentamos la altura de la imagen para que sea más grande
                              fit: BoxFit.contain, // Asegura que la imagen se ajuste sin recortarse
                              errorBuilder: (context, error, stackTrace) => const Icon(
                                Icons.image_not_supported,
                                size: 50,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                          const SizedBox(height: 8), // Espacio entre la imagen y el nombre
                          Text(
                            card.name,
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 8), // Espacio entre el nombre y el rank
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text("Rank: ", style: TextStyle(fontSize: 14)),
                              DropdownButton<String>(
                                value: card.tier,
                                onChanged: (String? newValue) {
                                  if (newValue != null) {
                                    controller.updateCardTier(card.id, newValue);
                                  }
                                },
                                items: <String>['S', 'A', 'B', 'C', 'F']
                                    .map<DropdownMenuItem<String>>((String value) {
                                  return DropdownMenuItem<String>(value: value, child: Text(value));
                                }).toList(),
                              ),
                            ],
                          ),
                          const SizedBox(height: 2), // Espacio entre el rank y el botón de eliminación
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () => _confirmDelete(context, controller, card.id),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/addCard');
        },
        child: const Icon(Icons.add),
        backgroundColor: Colors.redAccent,
      ),
    );
  }

  // Método para confirmar la eliminación de una carta
  void _confirmDelete(BuildContext context, CardController controller, String cardId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Eliminar carta"),
          content: const Text("¿Estás seguro de que quieres eliminar esta carta del ranking?"),
          actions: [
            TextButton(
              child: const Text("Cancelar"),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: const Text("Eliminar"),
              onPressed: () {
                controller.removeCard(cardId);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  // Método para obtener el color del borde según el tier
  Color _getTierColor(String tier) {
    switch (tier) {
      case 'S':
        return Colors.red.shade700; // Rojo oscuro para S
      case 'A':
        return Colors.orange.shade700; // Naranja oscuro para A
      case 'B':
        return Colors.yellow.shade700; // Amarillo oscuro para B
      case 'C':
        return Colors.green.shade700; // Verde oscuro para C
      case 'F':
        return Colors.blue.shade700; // Azul oscuro para F
      default:
        return Colors.grey.shade700; // Color gris oscuro por defecto
    }
  }
}
