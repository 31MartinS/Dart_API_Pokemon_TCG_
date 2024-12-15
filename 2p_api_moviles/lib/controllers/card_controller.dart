import 'package:flutter/material.dart';
import '../models/card_model.dart';

class CardController extends ChangeNotifier {
  List<PokemonCard> _rankedCards = [];

  // Obtener las cartas rankeadas
  List<PokemonCard> get rankedCards => _rankedCards;

  // Agregar una carta al ranking
  void addCard(PokemonCard card) {
    _rankedCards.add(card);
    sortCards(); // Ordenar automáticamente después de agregar una carta
    notifyListeners();
  }

  // Eliminar una carta del ranking por su ID
  void removeCard(String cardId) {
    _rankedCards.removeWhere((card) => card.id == cardId);
    notifyListeners();
  }

  // Ordenar las cartas por el tier (S -> A -> B -> C -> F)
  void sortCards() {
    _rankedCards.sort((a, b) {
      // Definir el orden de los tiers
      const tierOrder = ['S', 'A', 'B', 'C', 'F'];
      return tierOrder.indexOf(a.tier).compareTo(tierOrder.indexOf(b.tier));
    });
    notifyListeners();
  }

  // Actualizar el tier de una carta y ordenar las cartas automáticamente
  void updateCardTier(String cardId, String newTier) {
    final cardIndex = _rankedCards.indexWhere((card) => card.id == cardId);
    if (cardIndex != -1) {
      _rankedCards[cardIndex].tier = newTier;
      sortCards(); // Volver a ordenar las cartas después de actualizar el tier
      notifyListeners();
    }
  }
}
