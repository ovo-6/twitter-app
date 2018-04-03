import 'dart:async';

import 'package:twitter_app/twitter/twitter_datetime.dart';
import 'package:twitter_app/ui/tweet_item.dart';
import 'package:flutter/material.dart';
import 'package:twitter_app/twitter/twitter_client.dart';

class TweetList extends StatefulWidget {

  TweetList({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => new _TweetListState();

}

class _TweetListState extends State<StatefulWidget> {

  static final Duration oneMinute = const Duration(minutes: 1);
  static final Duration loadRepliesInterval = const Duration(seconds: 1);

  static final TwitterClient twitterClient = new TwitterClient();
  final TwitterDateTime _twitterDateTime = new TwitterDateTime();
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = new GlobalKey<RefreshIndicatorState>();
  final ScrollController _controller = new ScrollController();

  List _tweets = [];
  List _tweetIdsRepliesNotLoaded = [];
  bool _hasError = false;

  Timer timer;
  Timer timer2;

  @override
  void initState() {
    super.initState();

    _controller.addListener(_getListener);

    _loadTweets(true);
  }

  bool showLoadingDialog() {
    if (_tweets.length == 0) {
      return true;
    }

    return false;
  }

  Widget getProgressDialog() {
    return new Center(child: new CircularProgressIndicator());
  }

  Widget getErrorText() {
    return new Center(child: new Text('Error loading tweets'));
  }

  void _getListener() {
    if (_controller.position.pixels == _controller.position.maxScrollExtent) {
      print('edge');
      _loadTweets(false);
    }
  }

  ListView getListView() => new ListView.builder(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.all(0.0),
      itemCount: _tweets.length,
      controller: _controller,
      itemBuilder: (BuildContext context, int index) {

        if (this._tweets.length <= index) {
          return null;
        }

        Map item = _tweets[index];

        List replies = item['replies'];

        String retweetedBy = '';
        if (item['retweeted_status'] != null) {
          retweetedBy = item['user']['name'];
          item = item['retweeted_status'];
        }

        DateTime created = _twitterDateTime.parse(item['created_at']);

        List<String> mediaUrls = [];
        List<String> mediaUrlsInText = [];
        if (item['extended_entities'] != null && item['extended_entities']['media'] != null) {
          for (Map media in item['extended_entities']['media']) {
            mediaUrls.add(media['media_url']);
            mediaUrlsInText.add(media['url']);
          }
        }

        List userMentions;
        if (item['entities']['user_mentions'] != null) {
          userMentions = item['entities']['user_mentions'];
        }

        return new TweetItem(
            item['user']['screen_name'],
            item['user']['name'],
            item['user']['profile_image_url'],
            item['full_text'],
            replies?.length,
            item['retweet_count'],
            item['favorite_count'],
            _twitterDateTime.formatAsDifference(created, new DateTime.now()),
            item['entities']['urls'],
            retweetedBy,
            mediaUrls, mediaUrlsInText,
            userMentions,
            item['user']['verified']
        );

      });

  @override
  Widget build(BuildContext context) {

    if (_hasError) {
      return getErrorText(); //TODO change to snackbar
    }

    if (showLoadingDialog()) {
      return getProgressDialog();
    }

    timer = new Timer.periodic(oneMinute, (timer) => _redrawItems());
    timer2 = new Timer.periodic(loadRepliesInterval, (timer2) => _loadRepliesForOneTweet());

    return
        new RefreshIndicator(
          key: _refreshIndicatorKey,
          onRefresh: () => _loadTweets(true),
          child: new Scrollbar(child: getListView()));

  }

  _loadTweets(bool replace) async {

    _hasError = false;

    int lastId;
    if (!replace && _tweets.length > 0) {
      lastId = _tweets[_tweets.length-1]['id'];
    }

    try {
      List newTweets = await twitterClient.getTweets(20, lastId);

      for (Map tweet in newTweets) {
        _tweetIdsRepliesNotLoaded.add(tweet['id']);
      }

      setState(() {
        if (replace) {
          _tweets = newTweets;
        } else {

          // remove item already loaded
          if (newTweets.length > 0) {
            if (newTweets[0]['id'] == lastId) {
              _tweets.removeLast();
            }
          }

          _tweets.addAll(newTweets);
        }
      });

    } catch (e) { //FIXME SocketError not catched
      print(e);
      setState(() {
        _hasError = true;
      });
    }

  }
  _redrawItems() {
    print('redrawing items');
    setState(() {
      // refresh view
    });
  }

  _loadRepliesForOneTweet() async {
    Map item = null;
    for (Map tweet in _tweets) {
      if (tweet['replies'] == null) {
        item = tweet;
        break;
      }
    }

    if (item != null && _tweetIdsRepliesNotLoaded.contains(item['id'])) {
      _tweetIdsRepliesNotLoaded.remove(item['id']);
      print('Getting replies for ' + item['id'].toString());
      List<Map> replies = await twitterClient.getReplies(item);
      setState(() {
        item['replies'] = replies;
      });
    }
  }
}