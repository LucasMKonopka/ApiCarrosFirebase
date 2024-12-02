import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:trabalho4/services/carro_service.dart';
import 'package:trabalho4/view/home_page.dart';


class CarroPage extends StatefulWidget {
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

  Future<void> _saveCarro() async {
    final String marca = _marcaController.text;
    final String modelo = _modeloController.text;
    final int ano = int.tryParse(_anoController.text) ?? 0;
    final String cor = _corController.text;
    final String categoria = _categoriaController.text;

    if (_editingCarroId == null) {
      await _carroService.createCarro(
        marca: marca,
        modelo: modelo,
        ano: ano,
        cor: cor,
        categoria: categoria,
        userId: 'userIdDoUsuario',
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
    
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => HomePage()),
    );
    
  }

  void _editCarro(Map<String, dynamic> carro, String carroId) {
    setState(() {
      _editingCarroId = carroId;
      _marcaController.text = carro['marca'];
      _modeloController.text = carro['modelo'];
      _anoController.text = carro['ano'].toString();
      _corController.text = carro['cor'];
      _categoriaController.text = carro['categoria'];
    });
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
