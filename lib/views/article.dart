import 'package:flutter/material.dart';

class ArticleView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Central Times"),
        actions: [
          IconButton(onPressed: () {}, icon: Icon(Icons.bookmark_add_outlined)),
          IconButton(onPressed: () {}, icon: Icon(Icons.share)),
        ],
      ),
      body: ListView(
        children: [
          ListTile(title: Text("Editorial")),
          ListTile(
            title: Text("Example of an Article Headline Displayed", style: Theme.of(context).textTheme.headline5),
            subtitle: Text("Agam volutpat elaboraret mei eu, habemus gloriatur scripserit ad qui. Quo cu intellegat contentiones, ex amet nihil vituperata vix."),
          ),
          ListTile(title: Text("By Lorem Ipsum", style: TextStyle(fontStyle: FontStyle.italic)), subtitle: Text("Updated June 7, 2021 - 12:59 PM CDT")),
          Placeholder(fallbackHeight: 200),
          ListTile(subtitle: Text("Ei partem nominavi mea, mucius volumus eu his. Eu tota offendit mei, duis liberavisse pro cu, vim ea blandit")),
          ListTile(title: Text("Praesent vulputate odio quis bibendum commodo. Morbi semper sem nec augue posuere, id tempor lorem laoreet. Suspendisse ut dignissim lacus, eget porta neque. Nullam id urna sem. ")),
          ListTile(title: Text("Etiam ultricies massa est, efficitur efficitur nisi suscipit sit amet. Vestibulum sit amet quam leo. Fusce eget augue leo. Nunc mollis lacus at nulla cursus hendrerit. Proin porta metus eu blandit consectetur.")),
          ListTile(title: Text("Some Subtitle",  style: Theme.of(context).textTheme.headline6)),
          ListTile(title: Text("Ei partem nominavi mea, mucius volumus",  style: TextStyle(fontWeight: FontWeight.bold))),
          ListTile(subtitle: Text("Ei mei quando labore consectetuer, mel inani lucilius et. Meis civibus explicari an mei, menandri vulputate pri id.")),
          Placeholder(fallbackHeight: 100),
          ListTile(subtitle: Text("Mei equidem quaestio mnesarchum in, summo mucius duo ne, ut fabellas dissentiet nam. Vel dicat aperiri a.")),
          Placeholder(fallbackHeight: 300),
          ListTile(title: Text("Alia mnesarchum sit ex, et everti tritani probatus quo. Quis movet te pri, deleniti erroribus cu per. Epicuri iracundia ius ea. Ut has munere option senserit, at has audiam denique accommodare. Per zril indoctum in, explicari mediocritatem et quo.")),
        ],
      ),
    );
  }
}
