import 'package:don_nut/src/models/user.dart';

import 'package:flutter/material.dart';

var url = 'http://esteban-progra4.mywebcommunity.org/api/';
var token = '';

late List<Widget> pages = List.filled(
    4, const CircularProgressIndicator()); //Paginas del bottomNavigationBar
late Widget currentPage; //Pagina del bottomNavigationBar donde se encuentra
late User user;
