import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class LinkBuilder {

  const LinkBuilder();

  /// Replace links from urls contained in text string.
  /// Remove links in text from mediaUrls list.
  RichText buildText(String text, List urls, List mediaUrls, List userMentions, TextStyle textStyle, TextStyle linkStyle) {

    for (String url in mediaUrls) {
      text = text.replaceAll(url, "");
    }

    List<TextSpan> children = [];
    children.add(new TextSpan(text: text, style: textStyle));

    for (Map url in urls) {
      String find = url['url'];
      String linkUrl = url['expanded_url'];
      String linkText = url['display_url'];

      List<TextSpan> newChildren = [];

      for (TextSpan span in children) {
        int index = span.text.indexOf(find);
        if (index >= 0) {
          String before = span.text.substring(0, index);
          String after = span.text.substring(index + find.length, span.text.length);

          if (before.length > 0) {
            newChildren.add(new TextSpan(text: before, style: textStyle));
          }

          newChildren.add(new LinkTextSpan(
              style: linkStyle,
              url: linkUrl,
              text: linkText
          ));

          if (after.length > 0) {
            newChildren.add(new TextSpan(text: after, style: textStyle));
          }

        } else {
          newChildren.add(span);
        }
      }

      children = newChildren;
    }

    return new RichText(text: new TextSpan(children: children));
  }

}

class LinkTextSpan extends TextSpan {

  // Beware!
  //
  // This class is only safe because the TapGestureRecognizer is not
  // given a deadline and therefore never allocates any resources.
  //
  // In any other situation -- setting a deadline, using any of the less trivial
  // recognizers, etc -- you would have to manage the gesture recognizer's
  // lifetime and call dispose() when the TextSpan was no longer being rendered.
  //
  // Since TextSpan itself is @immutable, this means that you would have to
  // manage the recognizer from outside the TextSpan, e.g. in the State of a
  // stateful widget that then hands the recognizer to the TextSpan.

  LinkTextSpan({ TextStyle style, String url, String text }) : super(
      style: style,
      text: text ?? url,
      recognizer: new TapGestureRecognizer()..onTap = () {
        launch(url);
      }
  );
}