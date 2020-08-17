import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:olx_clone/views/Anuncios.dart';
import 'package:olx_clone/views/Login.dart';

class RouteGenerate {
  static const String TELA_ANUNCIO = '/';
  static const String TELA_LOGIN = '/login';

  static Route<dynamic> genetareRoutes(RouteSettings settings) {
    final args = settings.arguments;

    switch (settings.name) {
      case TELA_ANUNCIO:
        return MaterialPageRoute(builder: (_) => Anuncios());
      case TELA_LOGIN:
        return MaterialPageRoute(builder: (_) => Login());
      default:
        _erroRota();
    }
  }

  static Route<dynamic> _erroRota() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        backgroundColor: Colors.red,
        appBar: AppBar(
          title: Text('Tela Não Encontrada'),
        ),
        body: Center(
          child: Text('Tela Não Encontrada'),
        ),
      );
    });
  }
}
