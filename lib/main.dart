import 'package:flutter/material.dart';
import 'package:olx_clone/routes/RoutesGenerate.dart';
import 'package:olx_clone/views/Anuncios.dart';
import 'package:olx_clone/views/Login.dart';
import 'package:olx_clone/shared/ThemeData.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'OLX Clone',
    home: Anuncios(),
    initialRoute: RouteGenerate.TELA_ANUNCIO,
    onGenerateRoute: RouteGenerate.genetareRoutes,
    theme: temaPadrao,
  ));
}
