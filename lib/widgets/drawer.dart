import 'package:app/constants.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          ListTile(title: Text("Daniel Wu"), subtitle: Text("Welcome Back")),
          ListTile(title: Text("Log Out")),
          ListTile(
              title: ButtonBar(
            alignment: MainAxisAlignment.center,
            children: [
              IconButton(
                  onPressed: () => launch(facebookURL),
                  icon: ImageIcon(AssetImage("assets/images/facebook.png")),
                  iconSize: 30,
                  padding: EdgeInsets.all(4),
                  color: Theme.of(context).primaryColor),
              IconButton(
                  onPressed: () => launch(twitterURL),
                  icon: ImageIcon(AssetImage("assets/images/twitter.png")),
                  iconSize: 30,
                  padding: EdgeInsets.all(4),
                  color: Theme.of(context).primaryColor),
              IconButton(
                  onPressed: () => launch(instagramURL),
                  icon: ImageIcon(AssetImage("assets/images/instagram.png")),
                  iconSize: 30,
                  padding: EdgeInsets.all(4),
                  color: Theme.of(context).primaryColor),
              IconButton(
                  onPressed: () => launch(youtubeURL),
                  icon: ImageIcon(AssetImage("assets/images/youtube.png")),
                  iconSize: 30,
                  padding: EdgeInsets.all(4),
                  color: Theme.of(context).primaryColor),
              IconButton(
                  onPressed: () => launch(webURL),
                  icon: Icon(Icons.language_outlined),
                  iconSize: 36,
                  padding: EdgeInsets.all(2),
                  color: Theme.of(context).primaryColor),
            ],
          )),
          NotificationAccordion(),
          ListTile(
              leading: Icon(Icons.dark_mode),
              title: Text("Dark Theme"),
              trailing: Switch(value: false, onChanged: (_) {})),
          ListTile(leading: Icon(Icons.info), title: Text("About")),
          ListTile(
              leading: Icon(Icons.bug_report), title: Text("Report a Bug")),
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
