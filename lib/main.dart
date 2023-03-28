import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'user_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {

  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Classes',
      theme: ThemeData(
        primaryColor: Colors.green
      ),
      home:  UserScreen(),

    );

  }
}
