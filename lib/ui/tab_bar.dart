import 'package:twitter_app/ui/tweet_list.dart';
import 'package:flutter/material.dart';

class TabbedAppBar extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    TabBar tabBar = new TabBar(
      isScrollable: true,
      tabs: choices.map((Choice choice) {
        return new Tab(
          //text: choice.title,
          icon: new Icon(choice.icon)
        );
      }).toList(),
    );

    return new MaterialApp(
      home: new DefaultTabController(
        length: choices.length,
        child: new Scaffold(
          appBar: new PreferredSize(
            preferredSize: tabBar.preferredSize,
              child: new Container(
                color: Theme.of(context).primaryColor,
                child: new Padding(padding: const EdgeInsets.only(top: 25.0), child: tabBar)
              )
          ),
          body: new TabBarView(
            children: [
              new Padding(padding: const EdgeInsets.only(top: 0.0), child: new TweetList()),
              new Text('search'),
              new Text('notifications'),
              new Text('messages')
            ]
          ),
        ),
      ),
    );
  }
}

class Choice {
  const Choice({ this.title, this.icon });
  final String title;
  final IconData icon;
}

const List<Choice> choices = const <Choice>[
  const Choice(title: 'Home', icon: Icons.home),
  const Choice(title: 'Search', icon: Icons.search),
  const Choice(title: 'Notifications', icon: Icons.notifications_none),
  const Choice(title: 'Messages', icon: Icons.mail_outline),
];

class ChoiceCard extends StatelessWidget {
  const ChoiceCard({ Key key, this.choice }) : super(key: key);

  final Choice choice;

  @override
  Widget build(BuildContext context) {
    final TextStyle textStyle = Theme.of(context).textTheme.display1;
    return new Card(
      color: Colors.white,
      child: new Center(
        child: new Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            new Icon(choice.icon, size: 128.0, color: textStyle.color),
            new Text(choice.title, style: textStyle),
          ],
        ),
      ),
    );
  }
}
