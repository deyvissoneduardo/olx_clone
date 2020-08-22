import 'package:flutter/material.dart';
import 'package:olx_clone/shared/ThemeData.dart';

class BotaoCuston extends StatelessWidget {
  final String texto;
  final Color corTexto;
  final VoidCallback onPressed;

  BotaoCuston(
      {@required this.texto, this.corTexto = Colors.white, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Text(
        this.texto,
        style: TextStyle(color: this.corTexto, fontSize: 20),
      ),
      color: temaPadrao.primaryColor,
      padding: EdgeInsets.fromLTRB(32, 16, 32, 16),
      onPressed: this.onPressed,
    );
  }
}
