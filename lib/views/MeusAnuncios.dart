import 'package:flutter/material.dart';
import 'package:olx_clone/routes/RoutesGenerate.dart';

class MeusAnuncios extends StatefulWidget {
  @override
  _MeusAnunciosState createState() => _MeusAnunciosState();
}

class _MeusAnunciosState extends State<MeusAnuncios> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Meus anúcios',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        elevation: 7,
        foregroundColor: Colors.white,
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.pushReplacementNamed(
              context, RouteGenerate.TELA_NOVO_ANUNCIO);
        },
      ),
      body: Container(),
    );
  }
}
