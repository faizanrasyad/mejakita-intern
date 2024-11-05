import 'package:advanced_image_flutter/pages/catatanBaru.dart';
import 'package:advanced_image_flutter/pages/home.dart';
import 'package:advanced_image_flutter/pages/login.dart';
import 'package:advanced_image_flutter/pages/register.dart';
import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';

void main() {
  runApp(GlobalLoaderOverlay(
      child: MaterialApp(
    title: "Advanced Image Upload",
    theme: ThemeData(
      primarySwatch: Colors.green,
    ),
    initialRoute: '/',
    routes: {
      '/': (context) => Home(),
      '/login': (context) => Login(),
      '/register': (context) => Register(),
      '/add': (context) => CatatanBaru(),
    },
  )));
}
