import 'package:flutter/material.dart';


class IconWithText extends StatelessWidget {

  final IconData icon;
  final String text;

  const IconWithText(this.icon, this.text);

  @override
  Widget build(BuildContext context) {
    return new Row(children: <Widget>[
      new Icon(icon, color: Colors.grey, size: 12.0),
      new Container(
          padding: const EdgeInsets.only(left: 4.0),
          child: new Text(text))
    ]);
  }

}
