import 'package:flutter/material.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          ListTile(title: Text("Daniel Wu"), subtitle: Text("Welcome Back")),
          ListTile(title: Text("Log Out")),
          Divider(),
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
