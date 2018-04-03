import 'package:twitter_app/ui/tab_bar.dart';
import 'package:flutter/material.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Twitter App',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new MyHomePage(title: 'Twitter App Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {
    return new TabbedAppBar();
  }
}

// TODO:
// prevest twitter id @ovo6 v textu na jmeno
// komentare
// zobrazit kdo dal like
// zadavani jmena/ hesla - nepujde, misto toho key a secret
// ukladani tweetu

