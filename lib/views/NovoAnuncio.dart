import 'dart:io';

import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:olx_clone/shared/widgets/BotaoCuston.dart';
import 'package:olx_clone/shared/widgets/DropCuston.dart';
import 'package:olx_clone/shared/widgets/TextFildCuston.dart';
import 'package:validadores/Validador.dart';

class NovoAnuncio extends StatefulWidget {
  @override
  _NovoAnuncioState createState() => _NovoAnuncioState();
}

class _NovoAnuncioState extends State<NovoAnuncio> {
  /**  chave de validacao form **/
  final _formKey = GlobalKey<FormState>();

  String _estadoSelecionado;
  String _categoriaSelecionada;

  /** inicia listas **/
  List<File> _listaImagens = List();
  List<DropdownMenuItem<String>> _listaDropEstatos = List();
  List<DropdownMenuItem<String>> _listaDropCategoria = List();

  _selecionarImagem() async {
    File imagemSelecionada =
        await ImagePicker.pickImage(source: ImageSource.gallery);

    if (imagemSelecionada != null) {
      setState(() {
        _listaImagens.add(imagemSelecionada);
      });
    }
  }

  _carregaItensDrop() {
    /** lista de estados **/
    for (var estados in Estados.listaEstadosAbrv) {
      _listaDropEstatos.add(DropdownMenuItem(
        child: Text(estados),
        value: estados,
      ));
    }
    /** lista de categoria **/
    _listaDropCategoria.add(DropdownMenuItem(
      child: Text('Automovel'),
      value: 'auto',
    ));
    _listaDropCategoria.add(DropdownMenuItem(
      child: Text('Imovel'),
      value: 'imovel',
    ));
    _listaDropCategoria.add(DropdownMenuItem(
      child: Text('Eletronicos'),
      value: 'eletro',
    ));
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _carregaItensDrop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Novo anúncio',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                /** area de imagens **/
                FormField<List>(
                  initialValue: _listaImagens,
                  validator: (images) {
                    if (images.length == 0) {
                      return 'Necessário ao menos uma imagem';
                    }
                    return null;
                  },
                  builder: (state) {
                    return Column(
                      children: <Widget>[
                        Container(
                          height: 100,
                          child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: _listaImagens.length + 1,
                              itemBuilder: (context, index) {
                                /** btn fake para adc imagem **/
                                if (index == _listaImagens.length) {
                                  return Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 8),
                                    child: GestureDetector(
                                      onTap: () {
                                        _selecionarImagem();
                                      },
                                      child: CircleAvatar(
                                        backgroundColor: Colors.grey[500],
                                        radius: 50,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: <Widget>[
                                            Icon(
                                              Icons.add_a_photo,
                                              size: 40,
                                              color: Colors.grey[100],
                                            ),
                                            Text(
                                              'Adicionar',
                                              style: TextStyle(
                                                  color: Colors.grey[100],
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w400),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                }
                                if (_listaImagens.length > 0) {
                                  /** exibe imagens selecionada **/
                                  return Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 8),
                                    child: GestureDetector(
                                      onTap: () {
                                        showDialog(
                                            context: context,
                                            builder: (context) => Dialog(
                                                  child: Column(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: <Widget>[
                                                      Image.file(
                                                          _listaImagens[index]),
                                                      FlatButton(
                                                        child: Text('Excluir'),
                                                        textColor: Colors.red,
                                                        onPressed: () {
                                                          setState(() {
                                                            _listaImagens
                                                                .removeAt(
                                                                    index);
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                          });
                                                        },
                                                      )
                                                    ],
                                                  ),
                                                ));
                                      },
                                      child: CircleAvatar(
                                        radius: 50,
                                        backgroundImage:
                                            FileImage(_listaImagens[index]),
                                        child: Container(
                                          color: Color.fromRGBO(
                                              255, 255, 255, 0.4),
                                          alignment: Alignment.center,
                                          child: Icon(
                                            Icons.delete,
                                            color: Colors.red,
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                }
                                return Container();
                              }),
                        ),
                        /** caso haja erro no carregamendo da imagem **/
                        if (state.hasError)
                          Container(
                            child: Text(
                              '[${state.errorText}]',
                              style: TextStyle(color: Colors.red, fontSize: 14),
                            ),
                          )
                      ],
                    );
                  },
                ),
                /** meus dropdowm**/
                Row(
                  children: <Widget>[
                    DropCuston(
                      hint: 'Estados',
                      lista: _listaDropEstatos,
                      itemSelecinado: _estadoSelecionado,
                      valorSelecinado: _estadoSelecionado,
                    ),
                    DropCuston(
                      hint: 'Categoria',
                      lista: _listaDropCategoria,
                      itemSelecinado: _categoriaSelecionada,
                      valorSelecinado: _categoriaSelecionada,
                    ),
                  ],
                ),
                /** caixas de texto de btn **/
                TextFildCuston(
                  hint: 'Titulo',
                  validator: (valor) {
                    return Validador()
                        .add(Validar.OBRIGATORIO, msg: 'Campo Obrigatorio')
                        .valido(valor);
                  },
                ),
                TextFildCuston(
                  hint: 'Preço',
                  type: TextInputType.number,
                  inputFormatters: [
                    WhitelistingTextInputFormatter.digitsOnly,
                    RealInputFormatter(centavos: true)
                  ],
                  validator: (valor) {
                    return Validador()
                        .add(Validar.OBRIGATORIO, msg: 'Campo Obrigatorio')
                        .valido(valor);
                  },
                ),
                TextFildCuston(
                  hint: 'Telefone',
                  type: TextInputType.phone,
                  inputFormatters: [
                    WhitelistingTextInputFormatter.digitsOnly,
                    TelefoneInputFormatter()
                  ],
                  validator: (valor) {
                    return Validador()
                        .add(Validar.OBRIGATORIO, msg: 'Campo Obrigatorio')
                        .valido(valor);
                  },
                ),
                TextFildCuston(
                  hint: 'Descrição (200 caracteres)',
                  maxLines: null,
                  validator: (valor) {
                    return Validador()
                        .add(Validar.OBRIGATORIO, msg: 'Campo Obrigatorio')
                        .maxLength(200, msg: 'Maximo 200 caracteres')
                        .valido(valor);
                  },
                ),
                BotaoCuston(
                  texto: 'Cadastra anúncio',
                  onPressed: () {
                    if (_formKey.currentState.validate()) {}
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
