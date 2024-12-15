class PokemonCard {
  final String id;
  final String name;
  final String imageUrl;
  int rank; // El rank ahora se guardará como un número para ordenar
  String tier; // Campo para el tier (S, A, B, C, F)

  PokemonCard({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.rank,
    this.tier = 'C', // Valor predeterminado de tier
  });
}
