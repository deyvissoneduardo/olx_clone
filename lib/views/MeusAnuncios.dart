import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:olx_clone/models/Anuncio.dart';
import 'package:olx_clone/routes/RoutesGenerate.dart';
import 'package:olx_clone/shared/database/Firebase.dart';
import 'package:olx_clone/shared/widgets/CarregandoAnuncios.dart';
import 'package:olx_clone/shared/widgets/ListViewWidget.dart';

class MeusAnuncios extends StatefulWidget {
  @override
  _MeusAnunciosState createState() => _MeusAnunciosState();
}

class _MeusAnunciosState extends State<MeusAnuncios> {
  /** instancias **/
  FirebaseStorage _storage = FirebaseStorage.instance;
  Firestore _banco = Firestore.instance;
  FirebaseAuth _auth = FirebaseAuth.instance;
  String _idUsuario;

  final _controller = StreamController<QuerySnapshot>.broadcast();

  /** recupera dados do usuairo logado **/
  _recuperaDadosUsuario() async {
    FirebaseUser usuarioLoagado = await _auth.currentUser();
    _idUsuario = usuarioLoagado.uid;
  }

  /** recupera dados do anuncio **/
  Future<Stream<QuerySnapshot>> _adcionarListenerAnuncio() async {
    await _recuperaDadosUsuario();

    Stream<QuerySnapshot> stream = _banco
        .collection(Firebase.COLECAO_MEUS_ANUNCIOS)
        .document(_idUsuario)
        .collection(Firebase.COLECAO_ANUNCIOS)
        .snapshots();

    stream.listen((dados) {
      _controller.add(dados);
    });
  }

  _removerAnuncio(String idAnuncio) {
    _banco
        .collection(Firebase.COLECAO_MEUS_ANUNCIOS)
        .document(_idUsuario)
        .collection(Firebase.COLECAO_ANUNCIOS)
        .document(idAnuncio)
        .delete();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _adcionarListenerAnuncio();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Meus anúcios',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        elevation: 7,
        foregroundColor: Colors.white,
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.pushReplacementNamed(
              context, RouteGenerate.TELA_NOVO_ANUNCIO);
        },
      ),
      body: StreamBuilder(
        stream: _controller.stream,
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
              return CarregandoAnuncio(texto: 'Carregando Anúncios');
              break;
            case ConnectionState.active:
            case ConnectionState.done:
              /** verifica possiveis erros **/
              if (snapshot.hasError) {
                return CarregandoAnuncio(texto: 'Erro ao carregar dados');
              }
              /** recupera os dados caso nao haja erro **/
              QuerySnapshot querySnapshot = snapshot.data;
              return ListView.builder(
                itemCount: querySnapshot.documents.length,
                itemBuilder: (_, index) {
                  List<DocumentSnapshot> anuncios =
                      querySnapshot.documents.toList();
                  DocumentSnapshot documentSnapshot = anuncios[index];
                  Anuncio anuncio =
                      Anuncio.fromDocumentsSnapshot(documentSnapshot);

                  return ListViewWidget(
                    anuncio: anuncio,
                    onPressedRemover: () {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Text('Confirmar'),
                              content: Text('Deseja excluir?'),
                              elevation: 5,
                              actions: <Widget>[
                                FlatButton(
                                  child: Text(
                                    'Cancelar',
                                    style: TextStyle(color: Colors.black),
                                  ),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                                FlatButton(
                                  child: Text(
                                    'Remover',
                                    style: TextStyle(color: Colors.black),
                                  ),
                                  onPressed: () {
                                    _removerAnuncio(anuncio.id);
                                    Navigator.of(context).pop();
                                  },
                                )
                              ],
                            );
                          });
                    },
                  );
                },
              );
          }
          return Container();
        },
      ),
    );
  }
}
