import 'package:shared_preferences/shared_preferences.dart';
import 'package:tmb_merchant/application.dart';
import 'package:flutter/material.dart';
import 'package:tmb_merchant/bloc_helpers/prefs_singleton.dart';

void main() async {
  PrefsSingleton.prefs = await SharedPreferences.getInstance();
  runApp(Application());
}
