import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:olx_clone/shared/database/Firebase.dart';

class Anuncio {
  /** atributos **/
  String _id;
  String _estado;
  String _categoria;
  String _titulo;
  String _preco;
  String _telefone;
  String _descricao;
  List<String> _fotos;

  Anuncio() {
    /** inicia lista de images **/
    this.fotos = [];
    /** gera o id do anuncio **/
    Firestore banco = Firestore.instance;
    CollectionReference anuncios =
        banco.collection(Firebase.COLECAO_MEUS_ANUNCIOS);
    this.id = anuncios.document().documentID;
  }

  Map<String, dynamic> toMap(){
    Map<String, dynamic> dadosAnuncios = {
      'id' : this.id,
      'estado' : this.estado,
      'categoria' : this.categoria,
      'titulo' : this.titulo,
      'telefone' : this.telefone,
      'descricao' : this.descricao,
      'fotos' : this.fotos,
    };
    return dadosAnuncios;
  }

  List<String> get fotos => _fotos;

  set fotos(List<String> value) {
    _fotos = value;
  }

  String get descricao => _descricao;

  set descricao(String value) {
    _descricao = value;
  }

  String get preco => _preco;

  set preco(String value) {
    _preco = value;
  }

  String get titulo => _titulo;

  set titulo(String value) {
    _titulo = value;
  }

  String get categoria => _categoria;

  set categoria(String value) {
    _categoria = value;
  }

  String get telefone => _telefone;

  set telefone(String value) {
    _telefone = value;
  }

  String get estado => _estado;

  set estado(String value) {
    _estado = value;
  }

  String get id => _id;

  set id(String value) {
    _id = value;
  }
}
