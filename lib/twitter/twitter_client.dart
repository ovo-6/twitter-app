import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart';
import 'package:twitter/twitter.dart';


class TwitterClient {

  static const String consumerKey = '';
  static const String consumerSecret = '';
  static const String accessToken = '114196268-';
  static const String accessSecret = '';


  Future<List> getTweets(int count, int lastId) async {

    print('Getting tweets');

    String maxIdPart = "";
    if (lastId != null) {
      maxIdPart = "&max_id=" + lastId.toString();
    }

    final Twitter twitter = new Twitter(consumerKey, consumerSecret, accessToken, accessSecret);
    Response response = await twitter.request("GET", "statuses/home_timeline.json?exclude_replies=false&tweet_mode=extended&count=" + count.toString() + maxIdPart);
    return JSON.decode(response.body);
  }

  Future<Map> getUser(String idStr) async {

    print('Getting user ' + idStr);

    final Twitter twitter = new Twitter(consumerKey, consumerSecret, accessToken, accessSecret);
    Response response = await twitter.request("GET", "users/show.json?user_id=" + idStr);
    return JSON.decode(response.body);
  }

}

//E/flutter ( 3304): [ERROR:topaz/lib/tonic/logging/dart_error.cc(16)] Unhandled exception:
//E/flutter ( 3304): NoSuchMethodError: The method 'openUrl' was called on null.
//E/flutter ( 3304): Receiver: null
//E/flutter ( 3304): Tried calling: openUrl("GET", Instance of '_SimpleUri')
//E/flutter ( 3304): #0      Object.noSuchMethod (dart:core-patch/dart:core/object_patch.dart:46)
//E/flutter ( 3304): #1      IOClient.send (package:http/src/io_client.dart:30:36)
//E/flutter ( 3304): <asynchronous suspension>
//E/flutter ( 3304): #2      Client.send (package:oauth/client.dart:105:22)
//E/flutter ( 3304): #3      Client.request (package:twitter/src/client.dart:34:22)
//E/flutter ( 3304): #4      Twitter.request (package:twitter/twitter.dart:65:19)
//E/flutter ( 3304): #5      TwitterClient.getTweets (package:twitter_app/twitter/twitter_client.dart:26:39)
//E/flutter ( 3304): <asynchronous suspension>
//E/flutter ( 3304): #6      _TweetListState._loadTweets (package:twitter_app/ui/tweet_list.dart:140:44)