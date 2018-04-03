import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart';
import 'package:twitter/twitter.dart';
import 'package:twitter_app/twitter/api_keys.dart';


class TwitterClient {

  Future<List> getTweets(int count, int lastId) async {

    print('Getting tweets');

    String maxIdPart = "";
    if (lastId != null) {
      maxIdPart = "&max_id=" + lastId.toString();
    }

    Response response = await _getClient().request("GET", "statuses/home_timeline.json?exclude_replies=false&tweet_mode=extended&count=" + count.toString() + maxIdPart);
    List<Map> json = JSON.decode(response.body);
    return json;
  }

  Future<List> getReplies(Map tweet) async {

    if (tweet['retweeted_status'] != null) {
      tweet = tweet['retweeted_status'];
    }

    int tweetId = tweet['id'];
    String user = tweet['user']['screen_name'];
    String q = "to%3A" + user;
    Response response = await _getClient().request("GET", "search/tweets.json?q=" + q + "&result_type=recent&&since_id=" + tweetId.toString() + "&count=100");
    List<Map> replies = [];
    var results = JSON.decode(response.body);
    //print(results);
    for (Map result in results['statuses']) {
      if (result['in_reply_to_status_id'] == tweetId) {
        replies.add(result);
      }
    }
    print('@' + user + ' has ' + replies.length.toString() + ' replies');
    return replies;
  }

  Future<Map> getUser(String idStr) async {
    print('Getting user ' + idStr);

    final Response response = await _getClient().request("GET", "users/show.json?user_id=" + idStr);
    return JSON.decode(response.body);
  }

  Twitter _getClient() {
    return new Twitter(ApiKeys.consumerKey, ApiKeys.consumerSecret, ApiKeys.accessToken, ApiKeys.accessSecret);
  }

}