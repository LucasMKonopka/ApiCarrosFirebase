import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Para o logout
import 'package:trabalho4/services/carro_service.dart';
import 'package:trabalho4/view/carro_page.dart';
import 'package:trabalho4/view/carro_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final CarroService _carroService = CarroService();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<QuerySnapshot> _getCarros() {
    final userId = _auth.currentUser?.uid;

    return _firestore
        .collection('carros')
        .where('userId', isEqualTo: userId)
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text('Carros', style: TextStyle(color: Colors.white),),
        
        actions: [
          IconButton(
            icon: Icon(Icons.logout, color: Colors.white,),
            onPressed: _logout,
          ),
        ],
      ),
      
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CarroPage(carroId: ''),
                  ),
                );
              },
              child: Text('Adicionar Carro', style: TextStyle(color: Colors.black)),
            ),
          ),
          Expanded(
            child: StreamBuilder(
              stream: _carroService
                  .readCarros(FirebaseAuth.instance.currentUser?.uid ?? ''),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(child: Text('Nenhum carro encontrado.'));
                }

                final carros = snapshot.data!.docs;

                return ListView.builder(
                  itemCount: carros.length,
                  itemBuilder: (context, index) {
                    final carro = carros[index];
                    final docId = carro.id;
                    final marca = carro['marca'];
                    final modelo = carro['modelo'];
                    final ano = carro['ano'];
                    final cor = carro['cor'];
                    final categoria = carro['categoria'];

                    return ListTile(
                      title: Text('$marca - $modelo'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(Icons.edit),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      CarroPage(carroId: docId),
                                ),
                              );
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () {
                              _deleteCarro(docId);
                            },
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          )
        ],
      ),
    );
  }

  Future<void> _logout() async {
    try {
      await _auth.signOut();
      Navigator.pushReplacementNamed(context, '/login');
    } catch (e) {
      print("Erro ao fazer logout: $e");
    }
  }

  Future<void> _deleteCarro(String docId) async {
  final shouldDelete = await showDialog<bool>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text("Confirmar Exclusão"),
        content: Text("Tem certeza que deseja excluir este carro?"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(false);
            },
            child: Text("Cancelar"),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(true);
            },
            child: Text("Excluir"),
          ),
        ],
      );
    },
  );

  if (shouldDelete == true) {
    try {
      await _carroService.deleteCarro(docId);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Carro excluído com sucesso!'),
          duration: Duration(seconds: 2),
        ),
      );
    } catch (e) {
      print('Erro ao excluir o carro: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Falha ao excluir o carro.'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }
}
}
