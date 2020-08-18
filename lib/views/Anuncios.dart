import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:olx_clone/routes/RoutesGenerate.dart';
import 'package:olx_clone/shared/widgets/TextFildCuston.dart';

class Anuncios extends StatefulWidget {
  @override
  _AnunciosState createState() => _AnunciosState();
}

class _AnunciosState extends State<Anuncios> {
  /** instacia do firebase **/
  FirebaseAuth _auth = FirebaseAuth.instance;

  List<String> itensMenu = [];

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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _verificaUsuarioLogado();
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
        child: Text('Anuncios'),
      ),
    );
  }
}
