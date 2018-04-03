import 'dart:async';

import 'package:twitter_app/ui/icon_with_text.dart';
import 'package:twitter_app/ui/link_builder.dart';
import 'package:twitter_app/ui/my_list_tile.dart';
import 'package:flutter/material.dart';
import 'package:twitter_app/ui/picture_detail_dialog.dart';

class TweetItem extends MyListTile {

  static const double mainTextSize = 14.0;
  static const double paddingBelowAuthorText = 4.0;
  static const double paddingAboveAuthorText = 10.0;
  static final TextStyle retweetTextStyle = const TextStyle(fontSize: 12.0, color: Colors.grey);
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
  final bool verified;

  const TweetItem (this.authorId, this.authorName, this.iconSrc, this.text,
      this.commentsCount, this.retweetsCount, this.likesCount, this.dateStr,
      this.urls, this.retweetedBy, this.mediaUrls, this.mediaUrlsInText,
      this.userMentions, this.verified);

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    final TextStyle linkStyle = themeData.textTheme.subhead.copyWith(fontSize: mainTextSize, color: themeData.accentColor);
    final TextStyle textStyle = themeData.textTheme.subhead.copyWith(fontSize: mainTextSize);

    List<Widget> columnChildren = [];

    Widget avatar = new GestureDetector(
      child: new CircleAvatar(backgroundImage: new NetworkImage(iconSrc)),
        onTap: () => _showPersonDetail(context)
    );

    if (retweetedBy != null && retweetedBy.length > 0) {
      columnChildren.add(new Padding(
          padding: const EdgeInsets.only(top: paddingAboveAuthorText),
          child: new Text(retweetedBy + ' retweeted', style: retweetTextStyle)));
      avatar = new Padding(padding: const EdgeInsets.only(top: paddingAboveAuthorText + 28.0), child: avatar);
    } else {
      avatar = new Padding(padding: const EdgeInsets.only(top: paddingAboveAuthorText), child: avatar);
    }


    Row authorRow = new Row(children: <Widget>[
      new Text(authorName, style: new TextStyle(fontWeight: FontWeight.bold)),
      new Text('✓', style: new TextStyle(color: Colors.green)),
      new Text(' @' + authorId, style: new TextStyle(color: Colors.grey)),
      new Text(' • ' + dateStr, style: new TextStyle(color: Colors.grey)),
    ]);
    if (!verified) {
      authorRow.children.removeAt(1);
    }
    columnChildren.add(new Container(child: authorRow, padding: const EdgeInsets.only(
        bottom: paddingBelowAuthorText,
        top: paddingAboveAuthorText)));

    RichText richText = linkBuilder.buildText(text, urls, mediaUrlsInText, userMentions, textStyle, linkStyle);

    List<Widget> titleChildren = [];
    titleChildren.add(new Column(crossAxisAlignment: CrossAxisAlignment.start,
                                 children: columnChildren));

    titleChildren.add(richText);

    if (mediaUrls.length > 0) {
      //print('Media count: ' + mediaUrls.length.toString());

      double height = 150.0;
      if (mediaUrls.length == 1) {
        height = 300.0;
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
      dense: true,
      leading: avatar,
      title: title,
      subtitle:
          new Container(
              padding: const EdgeInsets.only(top: 4.0, bottom: 8.0),
              child:
            new Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                new IconWithText(Icons.chat_bubble_outline, commentsCount?.toString() ?? ''),
                new IconWithText(Icons.settings_backup_restore, retweetsCount?.toString() ?? ''),
                new IconWithText(Icons.favorite, likesCount?.toString() ?? '')
              ]
            )
          )
    );

    return new Column(children: <Widget>[tile, new Divider(height: 1.0)]);
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

  Future<Null> _showPersonDetail(BuildContext context) async {
    switch (await showDialog<Null>(
      context: context,
      child: new Card(child: new Text('Profile of ' + authorId))
    )) {

    }
  }

}