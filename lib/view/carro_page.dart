import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:trabalho4/services/carro_service.dart';

class CarroPage extends StatefulWidget {
  final String carroId;

  CarroPage({required this.carroId});

  @override
  _CarroPageState createState() => _CarroPageState();
}

class _CarroPageState extends State<CarroPage> {
  final CarroService _carroService = CarroService();

  final TextEditingController _marcaController = TextEditingController();
  final TextEditingController _modeloController = TextEditingController();
  final TextEditingController _anoController = TextEditingController();
  final TextEditingController _corController = TextEditingController();
  final TextEditingController _categoriaController = TextEditingController();

  String? _editingCarroId;

  @override
  void initState() {
    super.initState();
    //_editingCarroId = widget.carroId;
    if (widget.carroId.isNotEmpty) {
      _loadCarroData(widget.carroId); // Carregar os dados do carro para edição
    }
  }
  Future<String?> getCurrentUserId() async {
  final user = FirebaseAuth.instance.currentUser;
  print(user?.uid); // Verifique o ID do usuário
  return user?.uid;
}

  Future<void> _loadCarroData(String carroId) async {
  try {
    final carroData = await _carroService.getCarro(carroId);
    setState(() {
      _editingCarroId = carroId; // Atualiza o ID do carro em edição
      _marcaController.text = carroData['marca'];
      _modeloController.text = carroData['modelo'];
      _anoController.text = carroData['ano'].toString();
      _corController.text = carroData['cor'];
      _categoriaController.text = carroData['categoria'];
    });
  } catch (e) {
    print("Erro ao carregar dados do carro: $e");
  }
}

  Future<void> _saveCarro() async {
  final String marca = _marcaController.text.trim();
  final String modelo = _modeloController.text.trim();
  final int ano = int.tryParse(_anoController.text) ?? 0;
  final String cor = _corController.text.trim();
  final String categoria = _categoriaController.text.trim();

  if (marca.isEmpty || modelo.isEmpty || cor.isEmpty || categoria.isEmpty || ano <= 0) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Preencha todos os campos corretamente.')),
    );
    return;
  }

  try {
    final String? userId = await getCurrentUserId();
    if (userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro: Usuário não autenticado.')),
      );
      return;
    }

    if (_editingCarroId == null) {
      await _carroService.createCarro(
        marca: marca,
        modelo: modelo,
        ano: ano,
        cor: cor,
        categoria: categoria,
        userId: userId,
      );
    } else {
      await _carroService.updateCarro(
        docId: _editingCarroId!,
        marca: marca,
        modelo: modelo,
        ano: ano,
        cor: cor,
        categoria: categoria,
      );
    }

    _clearFields();
    Navigator.pop(context);
  } catch (e) {
    print('Erro ao salvar carro: $e');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Erro ao salvar o carro: $e')),
    );
  }
}
  void _clearFields() {
    setState(() {
      _editingCarroId = null;
      _marcaController.clear();
      _modeloController.clear();
      _anoController.clear();
      _corController.clear();
      _categoriaController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_editingCarroId == null ? 'Adicionar Carro' : 'Editar Carro'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _marcaController,
              decoration: InputDecoration(labelText: 'Marca'),
            ),
            TextField(
              controller: _modeloController,
              decoration: InputDecoration(labelText: 'Modelo'),
            ),
            TextField(
              controller: _anoController,
              decoration: InputDecoration(labelText: 'Ano'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _corController,
              decoration: InputDecoration(labelText: 'Cor'),
            ),
            TextField(
              controller: _categoriaController,
              decoration: InputDecoration(labelText: 'Categoria'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveCarro,
              child: Text('Salvar'),
            ),
          ],
        ),
      ),
    );
  }
}
