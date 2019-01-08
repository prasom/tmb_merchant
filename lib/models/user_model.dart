import 'package:pref_dessert/pref_dessert.dart';

class User {
  String _compcode;
  String _name;
  String _logo;

  User.map(dynamic obj) {
    this._compcode = obj["compcode"];
    this._name = obj["name"];
    this._logo = obj["logo"];
  }

  String get compcode => _compcode;
  String get name => _name;
  String get logo => _logo;

  User.fromJson(Map<String, dynamic> json)
      : _compcode = json['compcode'],
        _name = json['name'],
        _logo = json['logo'];

  Map<String, dynamic> toJson() => {
        'compcode': _compcode,
        'name': _name,
        'logo': _logo,
      };
}


