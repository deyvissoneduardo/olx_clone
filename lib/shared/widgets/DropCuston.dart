import 'package:flutter/material.dart';
import 'package:validadores/Validador.dart';

class DropCuston extends StatelessWidget {
  String hint;
  String itemSelecinado;
  List<DropdownMenuItem> lista;
  String valorSelecinado;

  DropCuston(
      {@required this.hint,
      @required this.itemSelecinado,
      @required this.lista,
      @required this.valorSelecinado});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: EdgeInsets.all(8),
        child: DropdownButtonFormField(
          hint: Text(this.hint),
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
