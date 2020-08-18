import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:olx_clone/models/Usuario.dart';
import 'package:olx_clone/routes/RoutesGenerate.dart';
import 'package:olx_clone/shared/widgets/BotaoCuston.dart';
import 'package:olx_clone/shared/widgets/TextFildCuston.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  /** controladores **/
  TextEditingController _controllerEmail = TextEditingController();
  TextEditingController _controllerSenha = TextEditingController();

  /** mensagens padrao **/
  String _mensagemError = '';
  String _textoBotao = 'Entrar';

  /** instacia do firebase **/
  FirebaseAuth _auth = FirebaseAuth.instance;

  bool _cadastra = false;

  /** valida os campos para logar ou cadastra **/
  _validarCampos() {
    /** recupera valores digitados **/
    String email = _controllerEmail.text;
    String senha = _controllerSenha.text;

    /** verifica se os texto sao validos **/
    if (email.isNotEmpty && email.contains('@')) {
      if (senha.isNotEmpty && senha.length > 6) {
        /** configura usuario **/
        Usuario usuario = Usuario();
        usuario.email = email;
        usuario.senha = senha;

        /** cadastra ou logar **/
        switch (_cadastra) {
          case true:
            _cadastraUsuario(usuario);
            break;
          case false:
            _logarUsuario(usuario);
            break;
        }
      } else {
        setState(() {
          _mensagemError = 'Senha Invalida e/ou minimo de 7 caracteres';
        });
      }
    } else {
      setState(() {
        _mensagemError = 'Favor Digite e-mail valido';
      });
    }
  }

  _cadastraUsuario(Usuario usuario) {
    _auth
        .createUserWithEmailAndPassword(
            email: usuario.email, password: usuario.senha)
        .then((firebaseUser) {
      /** redireciona tela principal **/
      Navigator.pushReplacementNamed(context, RouteGenerate.TELA_ANUNCIO);
    });
  }

  _logarUsuario(Usuario usuario) {
    _auth
        .signInWithEmailAndPassword(
            email: usuario.email, password: usuario.senha)
        .then((firabaseUser) {
      /** redireciona tela principal **/
      Navigator.pushReplacementNamed(context, RouteGenerate.TELA_ANUNCIO);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(''),
        ),
        body: Container(
            padding: EdgeInsets.all(16),
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(bottom: 32),
                      child: Image.asset(
                        'images/logo.png',
                        width: 200,
                        height: 150,
                      ),
                    ),
                    TextFildCuston(
                      controller: _controllerEmail,
                      hint: 'Email',
                      autofocus: true,
                      type: TextInputType.emailAddress,
                    ),
                    TextFildCuston(
                      controller: _controllerSenha,
                      hint: 'Senha',
                      obscure: true,
                      type: TextInputType.visiblePassword,
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text('Logar'),
                          Switch(
                              value: _cadastra,
                              onChanged: (bool value) {
                                setState(() {
                                  _cadastra = value;
                                  _textoBotao = 'Entrar';
                                  if (_cadastra) {
                                    _textoBotao = 'Cadastra';
                                  }
                                });
                              }),
                          Text('Cadastra')
                        ],
                      ),
                    ),
                    BotaoCuston(
                      texto: _textoBotao,
                      onPressed: () {
                        _validarCampos();
                      },
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 20),
                      child: Text(
                        _mensagemError,
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.red),
                      ),
                    )
                  ],
                ),
              ),
            )));
  }
}
