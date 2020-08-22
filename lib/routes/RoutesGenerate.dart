import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:olx_clone/views/Anuncios.dart';
import 'package:olx_clone/views/DetalhesAnuncio.dart';
import 'package:olx_clone/views/Login.dart';
import 'package:olx_clone/views/MeusAnuncios.dart';
import 'package:olx_clone/views/NovoAnuncio.dart';

class RouteGenerate {
  static const String TELA_ANUNCIO = '/';
  static const String TELA_LOGIN = '/login';
  static const String TELA_MEUS_ANUNCIOS = '/meus_anuncios';
  static const String TELA_NOVO_ANUNCIO = '/novo_anuncio';
  static const String TELA_DETALHES_ANUNCIO = '/detalhes_anuncio';

  static Route<dynamic> genetareRoutes(RouteSettings settings) {
    final args = settings.arguments;

    switch (settings.name) {
      case TELA_ANUNCIO:
        return MaterialPageRoute(builder: (_) => Anuncios());
      case TELA_LOGIN:
        return MaterialPageRoute(builder: (_) => Login());
      case TELA_MEUS_ANUNCIOS:
        return MaterialPageRoute(builder: (_) => MeusAnuncios());
      case TELA_NOVO_ANUNCIO:
        return MaterialPageRoute(builder: (_) => NovoAnuncio());
      case TELA_DETALHES_ANUNCIO:
        return MaterialPageRoute(builder: (_) => DetalhesAnuncio(args));
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
