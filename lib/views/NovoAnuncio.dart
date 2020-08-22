import 'dart:io';

import 'package:brasil_fields/brasil_fields.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:olx_clone/models/Anuncio.dart';
import 'package:olx_clone/shared/database/Firebase.dart';
import 'package:olx_clone/shared/utils/Configuracao.dart';
import 'package:olx_clone/shared/widgets/BotaoCuston.dart';
import 'package:olx_clone/shared/widgets/TextFildCuston.dart';
import 'package:validadores/Validador.dart';

class NovoAnuncio extends StatefulWidget {
  @override
  _NovoAnuncioState createState() => _NovoAnuncioState();
}

class _NovoAnuncioState extends State<NovoAnuncio> {
  /** instancias **/
  FirebaseStorage _storage = FirebaseStorage.instance;
  Firestore _banco = Firestore.instance;
  FirebaseAuth _auth = FirebaseAuth.instance;

  /** context global **/
  BuildContext _dialogContext;

  /**  chave de validacao form **/
  final _formKey = GlobalKey<FormState>();

  String _estadoSelecionado;
  String _categoriaSelecionada;
  Anuncio _anuncio;

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
    _listaDropEstatos = Configuracoes.getEstados();
    /** lista de categoria **/
      _listaDropCategoria = Configuracoes.getCategorias();

  }

  /** metodo que exibe popup de salvando anuncio **/
  _abriDailog(BuildContext context) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                CircularProgressIndicator(
                  backgroundColor: Color(0xff9c27b0),
                ),
                SizedBox(height: 20),
                Text('Salvando Anuncio...')
              ],
            ),
          );
        });
  }

  _salvarAnuncio() async {
    _abriDailog(_dialogContext);
    /** upload das imagens **/
    await _uploadImages();
    //print('Lista de fotos: ${_anuncio.fotos.toString()}');
    /** salva anuncio no banco **/
    _salvarDadosDoAnuncio();
  }

  Future _salvarDadosDoAnuncio() async {
    /** recupera usuario logado **/
    FirebaseUser usuarioLoagado = await _auth.currentUser();
    String idUsuario = usuarioLoagado.uid;

    _banco
        .collection(Firebase.COLECAO_MEUS_ANUNCIOS)
        .document(idUsuario)
        .collection(Firebase.COLECAO_ANUNCIOS)
        .document(_anuncio.id)
        .setData(_anuncio.toMap())
        .then((_) {
      /** salva anuncio publico **/
      _banco
          .collection(Firebase.COLECAO_ANUNCIOS)
          .document(_anuncio.id)
          .setData(_anuncio.toMap())
          .then((_) =>
              {Navigator.pop(_dialogContext), Navigator.of(context).pop()});
    });
  }

  Future _uploadImages() async {
    StorageReference pastaRaiz = _storage.ref();
    for (var images in _listaImagens) {
      String nomeImage = DateTime.now().millisecondsSinceEpoch.toString();
      StorageReference arquivo = pastaRaiz
          .child(Firebase.COLECAO_MEUS_ANUNCIOS)
          .child(_anuncio.id)
          .child(nomeImage);
      /** comeca upload **/
      StorageUploadTask uploadTask = arquivo.putFile(images);
      StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;
      String url = await taskSnapshot.ref.getDownloadURL();
      _anuncio.fotos.add(url);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _carregaItensDrop();
    _anuncio = Anuncio.geraId();
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
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.all(8),
                        child: DropdownButtonFormField(
                          value: _estadoSelecionado,
                          hint: Text("Estados"),
                          onSaved: (estado) {
                            _anuncio.estado = estado;
                          },
                          style: TextStyle(color: Colors.black, fontSize: 20),
                          items: _listaDropEstatos,
                          validator: (valor) {
                            return Validador()
                                .add(Validar.OBRIGATORIO,
                                    msg: "Campo obrigatório")
                                .valido(valor);
                          },
                          onChanged: (valor) {
                            setState(() {
                              _estadoSelecionado = valor;
                            });
                          },
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.all(8),
                        child: DropdownButtonFormField(
                          value: _categoriaSelecionada,
                          hint: Text("Categorias"),
                          onSaved: (categoria) {
                            _anuncio.categoria = categoria;
                          },
                          style: TextStyle(color: Colors.black, fontSize: 20),
                          items: _listaDropCategoria,
                          validator: (valor) {
                            return Validador()
                                .add(Validar.OBRIGATORIO,
                                    msg: "Campo obrigatório")
                                .valido(valor);
                          },
                          onChanged: (valor) {
                            setState(() {
                              _categoriaSelecionada = valor;
                            });
                          },
                        ),
                      ),
                    ),
                  ],
                ),

                /** caixas de texto de btn **/
                TextFildCuston(
                  hint: 'Titulo',
                  onSaved: (titulo) {
                    _anuncio.titulo = titulo;
                  },
                  validator: (valor) {
                    return Validador()
                        .add(Validar.OBRIGATORIO, msg: 'Campo Obrigatorio')
                        .valido(valor);
                  },
                ),
                TextFildCuston(
                  hint: 'Preço',
                  onSaved: (preco) {
                    _anuncio.preco = preco;
                  },
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
                  onSaved: (telefone) {
                    _anuncio.telefone = telefone;
                  },
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
                  onSaved: (descricao) {
                    _anuncio.descricao = descricao;
                  },
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
                    if (_formKey.currentState.validate()) {
                      /** salva dados do form **/
                      _formKey.currentState.save();

                      /** configura o context do dialog**/
                      _dialogContext = context;

                      /** salva o anuncio **/
                      _salvarAnuncio();
                    }
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
