import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:olx_clone/models/Anuncio.dart';
import 'package:olx_clone/routes/RoutesGenerate.dart';
import 'package:olx_clone/shared/database/Firebase.dart';
import 'package:olx_clone/shared/utils/Configuracao.dart';
import 'package:olx_clone/shared/widgets/CarregandoAnuncios.dart';
import 'package:olx_clone/shared/widgets/ListViewWidget.dart';
import 'package:olx_clone/shared/widgets/TextFildCuston.dart';

class Anuncios extends StatefulWidget {
  @override
  _AnunciosState createState() => _AnunciosState();
}

class _AnunciosState extends State<Anuncios> {
  /** instacia do firebase **/
  FirebaseAuth _auth = FirebaseAuth.instance;
  Firestore _banco = Firestore.instance;

  /** controladores **/
  final _controller = StreamController<QuerySnapshot>.broadcast();

  /** inicia variaveis **/
  List<String> itensMenu = [];
  List<DropdownMenuItem<String>> _listaDropEstatos;
  List<DropdownMenuItem<String>> _listaDropCategoria;
  String _itemEstadoSelecionado;
  String _itemCategoriaSelecionada;

  _escolhaMenuItem(String itemEscolhido) {
    switch (itemEscolhido) {
      case 'Meus anúncios':
        Navigator.pushNamed(context, RouteGenerate.TELA_MEUS_ANUNCIOS);
        break;
      case 'Entrar / Cadastra':
        Navigator.pushNamed(context, RouteGenerate.TELA_LOGIN);
        break;
      case 'Deslogar':
        _deslogarUsuario();
        break;
    }
  }

  _deslogarUsuario() async {
    await _auth.signOut();
    Navigator.pushNamed(context, RouteGenerate.TELA_ANUNCIO);
  }

  Future _verificaUsuarioLogado() async {
    /** recupera usuario logado **/
    FirebaseUser usuarioLogado = await _auth.currentUser();

    if (usuarioLogado == null) {
      itensMenu = ['Entrar / Cadastra'];
    } else {
      itensMenu = ['Meus anúncios', 'Deslogar'];
    }
  }

  _carregaItensDrop() {
    /** lista de estados **/
    _listaDropEstatos = Configuracoes.getEstados();
    /** lista de categoria **/
    _listaDropCategoria = Configuracoes.getCategorias();
  }

  /** metodo que recupera lista de anuncios do banco **/
  Future<Stream<QuerySnapshot>> _adcionarListenerAnuncio() async {
    Stream<QuerySnapshot> stream =
        _banco.collection(Firebase.COLECAO_ANUNCIOS).snapshots();

    stream.listen((dados) {
      _controller.add(dados);
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _carregaItensDrop();
    _verificaUsuarioLogado();
    _adcionarListenerAnuncio();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('OLX'),
        elevation: 0,
        actions: <Widget>[
          PopupMenuButton<String>(
            onSelected: _escolhaMenuItem,
            itemBuilder: (context) {
              return itensMenu.map((String item) {
                return PopupMenuItem<String>(
                  value: item,
                  child: Text(item),
                );
              }).toList();
            },
          )
        ],
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            /** filtros **/
            Row(
              children: <Widget>[
                /** regiao **/
                Expanded(
                  child: DropdownButtonHideUnderline(
                    child: Center(
                      child: DropdownButton(
                        iconEnabledColor: Color(0xff9c27b0),
                        value: _itemEstadoSelecionado,
                        items: _listaDropEstatos,
                        style: TextStyle(fontSize: 22, color: Colors.black),
                        onChanged: (estado) {
                          _itemEstadoSelecionado = estado;
                        },
                      ),
                    ),
                  ),
                ),
                /** container de divisao **/
                Container(
                  color: Colors.grey[600],
                  height: 30,
                  width: 1.1,
                ),
                /** categoria **/
                Expanded(
                  child: DropdownButtonHideUnderline(
                    child: Center(
                      child: DropdownButton(
                        iconEnabledColor: Color(0xff9c27b0),
                        value: _itemCategoriaSelecionada,
                        items: _listaDropCategoria,
                        style: TextStyle(fontSize: 22, color: Colors.black),
                        onChanged: (categoria) {
                          _itemCategoriaSelecionada = categoria;
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
            /** listagem **/
            StreamBuilder(
              stream: _controller.stream,
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.none:
                  case ConnectionState.waiting:
                    return CarregandoAnuncio(texto: 'Carregando Anúncios');
                    break;
                  case ConnectionState.active:
                  case ConnectionState.done:
                    QuerySnapshot querySnapshot = snapshot.data;
                    if (querySnapshot.documents.length == 0) {
                      return Container(
                        padding: EdgeInsets.all(10),
                        child: Text(
                          'Nenhum Anúmcio',
                          style: TextStyle(fontSize: 20),
                        ),
                      );
                    }
                    return Expanded(
                      child: ListView.builder(
                        itemCount: querySnapshot.documents.length,
                        itemBuilder: (_, index) {
                          /** transforma snapshot em lista **/
                          List<DocumentSnapshot> anuncios =
                              querySnapshot.documents.toList();

                          /** pega pelo index **/
                          DocumentSnapshot documentSnapshot = anuncios[index];

                          /** muda anuncio para tipo snapshot **/
                          Anuncio anuncio =
                              Anuncio.fromDocumentsSnapshot(documentSnapshot);

                          return ListViewWidget(
                            anuncio: anuncio,
                          );
                        },
                      ),
                    );
                }
                return Container();
              },
            )
          ],
        ),
      ),
    );
  }
}
