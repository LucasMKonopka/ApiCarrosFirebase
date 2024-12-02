class Carro {
  final String id;
  final String marca;
  final String modelo;
  final String ano;
  final String cor;
  final String categoria;
  final String? img;
  final String userId; // Campo obrigatório

  Carro({
    required this.id,
    required this.marca,
    required this.modelo,
    required this.ano,
    required this.cor,
    required this.categoria,
    this.img,
    required this.userId, // Garantia de que será informado
  });
}
