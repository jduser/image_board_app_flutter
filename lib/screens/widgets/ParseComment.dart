import 'package:url_launcher/url_launcher.dart';
import 'package:html/parser.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';

class ParseComment extends StatelessWidget {
  final String comment;

  ParseComment({Key key, this.comment}) : super(key: key);

  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    String newComment = comment.replaceAll('<br>', '\n');

    var document = parse(newComment);
    newComment = document.body.text;

    RegExp exp =
        new RegExp(r"http.*?\s|$", multiLine: true, caseSensitive: false);

    List partsList = new List<TextSpan>();
    if (exp.hasMatch(newComment)) {
      Iterable<RegExpMatch> matches = exp.allMatches(newComment);
      int i = 0;
      for (RegExpMatch match in matches) {
        String preUrl = newComment.substring(i, match.start);
        TextSpan preLink = TextSpan(text: preUrl);

        String url = newComment.substring(match.start, match.end);
        TextSpan link = TextSpan(
            text: url,
            style: TextStyle(color: Colors.blueAccent),
            recognizer: new TapGestureRecognizer()
              ..onTap = () => _launchURL(url));
        i = match.end;
        partsList.add(preLink);
        partsList.add(link);
      }
    } else {
      partsList.add(TextSpan(text: newComment));
    }

    Widget displayComment = RichText(
      text: TextSpan(
          style: DefaultTextStyle.of(context).style, children: partsList),
    );

    return displayComment;
  }
}
