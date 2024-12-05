import 'package:cloud_firestore/cloud_firestore.dart';

class CarroService {
  final CollectionReference carrosCollection =
      FirebaseFirestore.instance.collection('carros');

  bool _isAnoValido(int ano) {
    return ano >= 0 && ano <= 2025;
  }

  // Criar um carro
  Future<void> createCarro({
    required String marca,
    required String modelo,
    required int ano,
    required String cor,
    required String categoria,
    required String userId,
  }) { 
    if (marca.isEmpty || modelo.isEmpty || cor.isEmpty || categoria.isEmpty) {
      throw Exception("Todos os campos são obrigatórios.");
    }

    if (!_isAnoValido(ano)) {
      throw Exception("O ano do carro deve ser entre 0 e 2025.");
    }
    return carrosCollection.add({
      'marca': marca,
      'modelo': modelo,
      'ano': ano,
      'cor': cor,
      'categoria': categoria,
      'userId': userId,
    });
  }

  Stream<QuerySnapshot> readCarros(String userId) {
    return carrosCollection.where('userId', isEqualTo: userId).snapshots();
  }

  Future<void> updateCarro({
    required String docId,
    String? marca,
    String? modelo,
    int? ano,
    String? cor,
    String? categoria,
  }) {
    Map<String, dynamic> updatedCarro = {};
    if (marca != null && marca.isNotEmpty) {
      updatedCarro['marca'] = marca;
    }
    if (modelo != null && modelo.isNotEmpty) {
      updatedCarro['modelo'] = modelo;
    }
    if (ano != null) {
      updatedCarro['ano'] = ano;
    }
    if (cor != null && cor.isNotEmpty) {
      updatedCarro['cor'] = cor;
    }
    if (categoria != null && categoria.isNotEmpty) {
      updatedCarro['categoria'] = categoria;
    }
    return carrosCollection.doc(docId).update(updatedCarro);
  }

  Future<Map<String, dynamic>> getCarro(String docId) async {
    DocumentSnapshot doc = await carrosCollection.doc(docId).get();
    return doc.data() as Map<String, dynamic>;
  }

  Future<void> deleteCarro(String docId) {
    return carrosCollection.doc(docId).delete();
  }
}
