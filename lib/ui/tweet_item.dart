import 'dart:async';

import 'package:twitter_app/ui/icon_with_text.dart';
import 'package:twitter_app/ui/link_builder.dart';
import 'package:twitter_app/ui/my_list_tile.dart';
import 'package:flutter/material.dart';
import 'package:twitter_app/ui/picture_detail_dialog.dart';

class TweetItem extends MyListTile {

  static final TextStyle retweetTextStyle = const TextStyle(fontSize: 14.0, color: Colors.grey);
  static final LinkBuilder linkBuilder = const LinkBuilder();

  final String authorName;
  final String authorId;
  final String iconSrc;
  final String text;
  final int commentsCount;
  final int retweetsCount;
  final int likesCount;
  final String dateStr;
  final List urls;
  final String retweetedBy;
  final List<String> mediaUrls;
  final List<String> mediaUrlsInText;
  final List userMentions;

  const TweetItem (this.authorId, this.authorName, this.iconSrc, this.text,
      this.commentsCount, this.retweetsCount, this.likesCount, this.dateStr,
      this.urls, this.retweetedBy, this.mediaUrls, this.mediaUrlsInText,
      this.userMentions);

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    final TextStyle linkStyle = themeData.textTheme.subhead.copyWith(color: themeData.accentColor);
    final TextStyle textStyle = themeData.textTheme.subhead;

    Widget avatar = new CircleAvatar(backgroundImage: new NetworkImage(iconSrc));

    List<Widget> columnChildren = [];
    if (retweetedBy != null && retweetedBy.length > 0) {
      columnChildren.add(new Padding(padding: const EdgeInsets.only(bottom: 5.0), child: new Text(retweetedBy + ' Retweeted', style: retweetTextStyle)));
      avatar = new Padding(padding: const EdgeInsets.only(top: 28.0), child: avatar);
    }

    Row authorRow = new Row(children: <Widget>[
      new Text(authorName, style: new TextStyle(fontWeight: FontWeight.bold)),
      new Text(' • ' + dateStr, style: new TextStyle(color: Colors.grey)),
    ]);
    columnChildren.add(authorRow);

    RichText richText = linkBuilder.buildText(text, urls, mediaUrlsInText, userMentions, textStyle, linkStyle);

    List<Widget> titleChildren = [];
    titleChildren.add(new Column(crossAxisAlignment: CrossAxisAlignment.start,
                                 children: columnChildren));

    titleChildren.add(richText);

    if (mediaUrls.length > 0) {
      print('Media count: ' + mediaUrls.length.toString());

      double height = 150.0;
      if (mediaUrls.length == 1) {
        height = 200.0;
      }

      List<Widget> images = [];
      for (String url in mediaUrls) {
        Image image = new Image.network(url);
        images.add(new GestureDetector(
            onTap: () => _showPictureDetail(context, image),
            child: new Card(
                child: image)));
      }

      titleChildren.add(new Container(
          height: height,
          child: new Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: new ListView(
              scrollDirection: Axis.horizontal,
              children: images))));
    }


    Widget title = new Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: titleChildren
    );

    MyListTile tile = new MyListTile(
      dense: false,
      leading: avatar,
      title: title,
      subtitle:
          new Container(
              padding: const EdgeInsets.only(top: 8.0),
              child:
            new Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                new IconWithText(Icons.chat_bubble_outline, commentsCount.toString()),
                new IconWithText(Icons.settings_backup_restore, retweetsCount.toString()),
                new IconWithText(Icons.favorite, likesCount.toString())
              ]
            )
          )
    );

    return new Column(children: <Widget>[tile, new Divider()]);
  }


  Future<Null> _showPictureDetail(BuildContext context, Image image) async {
    switch (await showDialog<Null>(
      context: context,
      child: new PictureDetailDialog(
        child: image,
      ),
    )) {

    }
  }

}