import 'package:flutter/material.dart';
import 'package:validadores/Validador.dart';

class DropCuston extends StatelessWidget {
  String hint;
  String itemSelecinado;
  List<DropdownMenuItem> lista;
  String valorSelecinado;
  final Function(String) onSaved;

  DropCuston(
      {@required this.hint,
      @required this.itemSelecinado,
      @required this.lista,
      @required this.valorSelecinado,
      this.onSaved});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: EdgeInsets.all(8),
        child: DropdownButtonFormField<dynamic>(
          hint: Text(this.hint),
          onSaved: this.onSaved,
          value: this.itemSelecinado,
          style: TextStyle(color: Colors.black87, fontSize: 20),
          items: this.lista,
          onChanged: (valor) {
            this.valorSelecinado = valor;
          },
          validator: (valor) {
            return Validador()
                .add(Validar.OBRIGATORIO, msg: 'Campo Obrigatorio')
                .valido(valor);
          },
        ),
      ),
    );
  }
}
