import 'package:flutter/material.dart';
import 'package:olx_clone/shared/ThemeData.dart';

class CarregandoAnuncio extends StatelessWidget {
  String texto;

  CarregandoAnuncio({@required this.texto});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Column(
          children: <Widget>[Text(this.texto), CircularProgressIndicator(
            backgroundColor: temaPadrao.primaryColor,
          )],
        ),
      ),
    );
  }
}
