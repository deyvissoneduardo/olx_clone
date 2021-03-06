import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/material.dart';
import 'package:olx_clone/models/Anuncio.dart';
import 'package:olx_clone/shared/ThemeData.dart';
import 'package:olx_clone/shared/widgets/Divisor.dart';
import 'package:url_launcher/url_launcher.dart';

class DetalhesAnuncio extends StatefulWidget {
  /** espeda dados passados por parametros **/
  Anuncio anuncio;

  DetalhesAnuncio(this.anuncio);

  @override
  _DetalhesAnuncioState createState() => _DetalhesAnuncioState();
}

class _DetalhesAnuncioState extends State<DetalhesAnuncio> {
  Anuncio _anuncio;

  /** consulta lista de imagens **/
  List<Widget> _getListaImagens() {
    List<String> listaUrlImagens = _anuncio.fotos;
    return listaUrlImagens.map((url) {
      return Container(
        height: 250,
        decoration: BoxDecoration(
            image: DecorationImage(
                image: NetworkImage(url), fit: BoxFit.fitWidth)),
      );
    }).toList();
  }

  _ligarTelefone(String telefone) async {
    if (await canLaunch('tel:${telefone}')) {
      await launch('tel:${telefone}');
    } else {
      return Container();
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _anuncio = widget.anuncio;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Anúncio'),
      ),
      body: Stack(
        children: <Widget>[
          /** imagens do anuncio **/
          ListView(
            children: <Widget>[
              SizedBox(
                height: 250,
                child: Carousel(
                  images: _getListaImagens(),
                  dotSize: 8,
                  dotBgColor: Colors.transparent,
                  dotColor: Colors.white,
                  autoplay: false,
                  dotIncreasedColor: temaPadrao.primaryColor,
                ),
              ),
              /** conteudo do anuncio **/
              Container(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    /** preco **/
                    Text(
                      'R\$ ${_anuncio.preco}',
                      style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: temaPadrao.primaryColor),
                    ),
                    /** titulo **/
                    Text(
                      '${_anuncio.titulo}',
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    /** espacamento **/
                    Divisor(),
                    /** nome descricao **/
                    Text(
                      'Descrição',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    /** texto da descricao **/
                    Text(
                      '${_anuncio.descricao}',
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                    Divisor(),
                    Text(
                      'Contato',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    /** texto do contato **/
                    Padding(
                      padding: EdgeInsets.only(bottom: 66),
                      child: Text(
                        '${_anuncio.telefone}',
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          /** btn ligar **/
          Positioned(
            left: 16,
            right: 16,
            bottom: 16,
            child: GestureDetector(
              child: Container(
                child: Text(
                  'Ligar',
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
                padding: EdgeInsets.all(16),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    color: temaPadrao.primaryColor,
                    borderRadius: BorderRadius.circular(30)),
              ),
              onTap: () {
                _ligarTelefone(_anuncio.telefone);
              },
            ),
          )
        ],
      ),
    );
  }
}
