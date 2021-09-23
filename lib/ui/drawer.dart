import 'dart:io' show Platform;

import 'package:android_intent_plus/android_intent.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          if (Platform.isAndroid)
            ListTile(
                subtitle: Wrap(
                  alignment: WrapAlignment.center,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    IconButton(
                        onPressed: () => AndroidIntent(
                                action:
                                    "fb://facewebmodal/f?href=https://www.facebook.com/pages/The-Central-Times/244007425638003",
                                data: "com.facebook.katana")
                            .launch()
                            .onError<PlatformException>((error, stackTrace) =>
                                launch(
                                    "https://www.facebook.com/pages/The-Central-Times/244007425638003")),
                        icon: Icon(FontAwesomeIcons.facebook),
                        color: Theme.of(context).primaryColor),
                    IconButton(
                        onPressed: () => AndroidIntent(
                                action:
                                    "twitter://user?screen_name=centraltimes",
                                data: "com.twitter.android")
                            .launch()
                            .onError<PlatformException>((error, stackTrace) =>
                                launch("https://twitter.com/centraltimes")),
                        icon: Icon(FontAwesomeIcons.twitter),
                        color: Theme.of(context).primaryColor),
                    IconButton(
                        onPressed: () => AndroidIntent(
                                action: "http://instagram.com/_u/centraltimes",
                                data: "com.instagram.android")
                            .launch()
                            .onError<PlatformException>((error, stackTrace) =>
                                launch("https://instagram.com/centraltimes")),
                        icon: Icon(FontAwesomeIcons.instagram),
                        color: Theme.of(context).primaryColor),
                    IconButton(
                        onPressed: () => AndroidIntent(
                                action:
                                    "https://www.youtube.com/channel/UCZD15y_YblVe0cI0kMKKZQA",
                                data: "com.google.android.youtube")
                            .launch()
                            .onError<PlatformException>((error, stackTrace) =>
                                launch(
                                    "https://www.youtube.com/channel/UCZD15y_YblVe0cI0kMKKZQA")),
                        icon: Icon(FontAwesomeIcons.youtube),
                        color: Theme.of(context).primaryColor),
                    IconButton(
                        onPressed: () =>
                            launch("https://www.centraltimes.org/"),
                        icon: Icon(Icons.language_outlined),
                        color: Theme.of(context).primaryColor),
                  ],
                ))
          else ...[
            ListTile(
                title: Wrap(
              alignment: WrapAlignment.center,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                IconButton(
                    onPressed: () => launch(
                        "https://www.facebook.com/pages/The-Central-Times/244007425638003"),
                    icon: Icon(FontAwesomeIcons.facebook),
                    color: Theme.of(context).primaryColor),
                IconButton(
                    onPressed: () => launch("https://twitter.com/centraltimes"),
                    icon: Icon(FontAwesomeIcons.twitter),
                    color: Theme.of(context).primaryColor),
                IconButton(
                    onPressed: () =>
                        launch("http://instagram.com/_u/centraltimes"),
                    icon: Icon(FontAwesomeIcons.instagram),
                    color: Theme.of(context).primaryColor),
                IconButton(
                    onPressed: () => launch(
                        "https://www.youtube.com/channel/UCZD15y_YblVe0cI0kMKKZQA"),
                    icon: Icon(FontAwesomeIcons.youtube),
                    color: Theme.of(context).primaryColor),
                IconButton(
                    onPressed: () => launch("https://www.centraltimes.org/"),
                    icon: Icon(Icons.language_outlined),
                    color: Theme.of(context).primaryColor),
              ],
            ))
          ],
          ListTile(
              leading: const Icon(Icons.email),
              title: const Text("Contact Us"),
              onTap: () async {
                launch('mailto:nchspaper.ct@gmail.com');
              }),
        ],
      ),
    );
  }
}

class NotificationAccordion extends StatefulWidget {
  @override
  _NotificationAccordionState createState() => _NotificationAccordionState();
}

class _NotificationAccordionState extends State<NotificationAccordion> {
  bool expanded = false;

  @override
  Widget build(BuildContext context) {
    return ExpansionPanelList(
      elevation: 0,
      expansionCallback: (index, isExpanded) {
        setState(() {
          expanded = !expanded;
        });
      },
      children: [
        ExpansionPanel(
          backgroundColor: Theme.of(context).canvasColor,
          headerBuilder: (context, isExpanded) => ListTile(
              leading: Icon(Icons.notifications), title: Text("Notifications")),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ListTile(
                  title: Text("Latest News"),
                  subtitle: Text("Important articles and stories."),
                  trailing: Switch(value: false, onChanged: (_) {})),
              ListTile(
                  title: Text("Community"),
                  trailing: Switch(value: false, onChanged: (_) {})),
              ListTile(
                  title: Text("Profiles"),
                  trailing: Switch(value: false, onChanged: (_) {})),
              ListTile(
                  title: Text("Entertainment"),
                  trailing: Switch(value: false, onChanged: (_) {})),
              ListTile(
                  title: Text("Sports"),
                  trailing: Switch(value: false, onChanged: (_) {})),
              ListTile(
                  title: Text("Surveys"),
                  trailing: Switch(value: false, onChanged: (_) {})),
              Divider(),
            ],
          ),
          isExpanded: expanded,
        ),
      ],
    );
  }
}