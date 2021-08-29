import 'package:app/models/app_user.dart';
import 'package:app/services/auth_service.dart';
import 'package:app/widgets/custom-dialogs.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    AppUser? user = Provider.of<AppUser?>(context);
    return Drawer(
      child: ListView(
        children: [
          if (user == null)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: ListTile(
                  onTap: () async {
                    try {
                      await showLoadingDialog(context, "Signing in...",
                          () async => await AuthService.signIn());
                    } on String catch (e) {
                      if (e != "") showErrorDialog(context, e);
                    }
                  },
                  leading: Icon(Icons.login),
                  title: Text("Sign In"),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 5),
                    child: Text("With a District 203 Google Account"),
                  )),
            )
          else ...[
            ListTile(
                title: Text(user.authAccount.displayName!),
                subtitle: Text("Welcome Back")),
            ListTile(
                onTap: () async {
                  await AuthService.signOut();
                },
                leading: Icon(Icons.logout),
                title: Text("Sign Out")),
          ],
          ListTile(
              title: Wrap(
            alignment: WrapAlignment.center,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              IconButton(
                  onPressed: () => launch("https://www.facebook.com/pages/The-Central-Times/244007425638003"),
                  icon: Icon(FontAwesomeIcons.facebook),
                  color: Theme.of(context).primaryColor),
              IconButton(
                  onPressed: () => launch("https://twitter.com/centraltimes"),
                  icon: Icon(FontAwesomeIcons.twitter),
                  color: Theme.of(context).primaryColor),
              IconButton(
                  onPressed: () => launch("http://instagram.com/_u/centraltimes"),
                  icon: Icon(FontAwesomeIcons.instagram),
                  color: Theme.of(context).primaryColor),
              IconButton(
                  onPressed: () => launch("https://www.youtube.com/channel/UCZD15y_YblVe0cI0kMKKZQA"),
                  icon: Icon(FontAwesomeIcons.youtube),
                  color: Theme.of(context).primaryColor),
              IconButton(
                  onPressed: () => launch("https://www.centraltimes.org/"),
                  icon: Icon(Icons.language_outlined),
                  color: Theme.of(context).primaryColor),
            ],
          )),
          NotificationAccordion(),
          ListTile(leading: Icon(Icons.info), title: Text("About")),
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
