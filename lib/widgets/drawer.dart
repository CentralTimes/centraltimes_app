import 'dart:io' show Platform;

import 'package:android_intent_plus/android_intent.dart';
import 'package:app/logic/media_logic.dart';
import 'package:app/logic/posts_logic.dart';
import 'package:app/models/post_model.dart';
import 'package:app/services/logic_getit_init.dart';
import 'package:app/services/saved_posts_service.dart';
import 'package:app/views/home_view/home_view_logic.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:logging/logging.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

class AppDrawer extends StatelessWidget {
  static final Logger log = Logger("CTDebugTools (in Drawer)");
  const AppDrawer({Key? key}) : super(key: key);

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
                    onPressed: () => const AndroidIntent(
                            action:
                                "fb://facewebmodal/f?href=https://www.facebook.com/pages/The-Central-Times/244007425638003",
                            data: "com.facebook.katana")
                        .launch()
                        .onError<PlatformException>((error, stackTrace) =>
                            launchUrlString(
                                "https://www.facebook.com/pages/The-Central-Times/244007425638003")),
                    icon: const Icon(FontAwesomeIcons.facebook),
                    color: Theme.of(context).colorScheme.primary),
                IconButton(
                    onPressed: () => const AndroidIntent(
                            action: "twitter://user?screen_name=centraltimes",
                            data: "com.twitter.android")
                        .launch()
                        .onError<PlatformException>((error, stackTrace) =>
                            launchUrlString(
                                "https://twitter.com/centraltimes")),
                    icon: const Icon(FontAwesomeIcons.twitter),
                    color: Theme.of(context).colorScheme.primary),
                IconButton(
                    onPressed: () => const AndroidIntent(
                            action: "http://instagram.com/_u/centraltimes",
                            data: "com.instagram.android")
                        .launch()
                        .onError<PlatformException>((error, stackTrace) =>
                            launchUrlString(
                                "https://instagram.com/centraltimes")),
                    icon: const Icon(FontAwesomeIcons.instagram),
                    color: Theme.of(context).colorScheme.primary),
                IconButton(
                    onPressed: () => const AndroidIntent(
                            action:
                                "https://www.youtube.com/channel/UCZD15y_YblVe0cI0kMKKZQA",
                            data: "com.google.android.youtube")
                        .launch()
                        .onError<PlatformException>((error, stackTrace) =>
                            launchUrlString(
                                "https://www.youtube.com/channel/UCZD15y_YblVe0cI0kMKKZQA")),
                    icon: const Icon(FontAwesomeIcons.youtube),
                    color: Theme.of(context).colorScheme.primary),
                IconButton(
                    onPressed: () =>
                        launchUrlString("https://www.centraltimes.org/"),
                    icon: const Icon(Icons.language_outlined),
                    color: Theme.of(context).colorScheme.primary),
              ],
            ))
          else ...[
            ListTile(
                title: Wrap(
              alignment: WrapAlignment.center,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                IconButton(
                    onPressed: () => launchUrlString(
                        "https://www.facebook.com/pages/The-Central-Times/244007425638003"),
                    icon: const Icon(FontAwesomeIcons.facebook),
                    color: Theme.of(context).colorScheme.primary),
                IconButton(
                    onPressed: () =>
                        launchUrlString("https://twitter.com/centraltimes"),
                    icon: const Icon(FontAwesomeIcons.twitter),
                    color: Theme.of(context).colorScheme.primary),
                IconButton(
                    onPressed: () =>
                        launchUrlString("http://instagram.com/_u/centraltimes"),
                    icon: const Icon(FontAwesomeIcons.instagram),
                    color: Theme.of(context).colorScheme.primary),
                IconButton(
                    onPressed: () => launchUrlString(
                        "https://www.youtube.com/channel/UCZD15y_YblVe0cI0kMKKZQA"),
                    icon: const Icon(FontAwesomeIcons.youtube),
                    color: Theme.of(context).colorScheme.primary),
                IconButton(
                    onPressed: () =>
                        launchUrlString("https://www.centraltimes.org/"),
                    icon: const Icon(Icons.language_outlined),
                    color: Theme.of(context).colorScheme.primary),
              ],
            ))
          ],
          ListTile(
              leading: const Icon(Icons.email),
              title: const Text("Contact Us"),
              onTap: () async {
                launchUrlString('mailto:nchspaper.ct@gmail.com');
              }),
          ..._devTools(context),
        ],
      ),
    );
  }

  List<Widget> _devTools(BuildContext context) {
    if (kDebugMode) {
      return [
        const ListTile(title: Text("Dev Tools")),
        ListTile(
            leading: const Icon(Icons.save),
            title: const Text("Save/Unsave Article by ID"),
            onTap: () async {
              String id = "";
              bool? saved = await showDialog<bool>(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      content: TextField(
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp(r'[0-9]'))
                        ],
                        decoration: const InputDecoration(
                          labelText: "Enter article ID",
                          hintText: "Enter article ID",
                        ),
                        onChanged: (value) {
                          id = value;
                        },
                      ),
                      actions: [
                        TextButton(
                            onPressed: () {
                              Navigator.pop<bool>(context, true);
                            },
                            child: const Text("Enter"))
                      ],
                    );
                  });
              if (saved == true) {
                int? articleId = int.tryParse(id);
                if (articleId != null && articleId > 0) {
                  PostsLogic postsLogic = getIt<PostsLogic>();
                  MediaLogic mediaLogic = getIt<MediaLogic>();
                  PostModel post = await postsLogic.getPost(postId: articleId);
                  await mediaLogic.getMediaSingle(post.featuredMedia);
                  HomeViewLogic logic = getIt<HomeViewLogic>();
                  await SavedPostsService.togglePost(articleId,
                      onAdd: (int index) {
                    if (logic.savedListKey.currentState != null) {
                      logic.savedListKey.currentState!.insertItem(index);
                    }
                  }, onRemove: (int index) {
                    if (logic.savedListKey.currentState != null) {
                      logic.savedListKey.currentState!.removeItem(index,
                          (context, animation) {
                        return SizeTransition(sizeFactor: animation);
                      });
                    }
                  });
                }
              }
            }),
        ListTile(
            leading: const Icon(Icons.bug_report),
            title: const Text("Print Something"),
            onTap: () async {
              log.info("Something");
            }),
      ];
    }
    return [];
  }
}

class NotificationAccordion extends StatefulWidget {
  const NotificationAccordion({Key? key}) : super(key: key);

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
          headerBuilder: (context, isExpanded) => const ListTile(
              leading: Icon(Icons.notifications), title: Text("Notifications")),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ListTile(
                  title: const Text("Latest News"),
                  subtitle: const Text("Important articles and stories."),
                  trailing: Switch(value: false, onChanged: (_) {})),
              ListTile(
                  title: const Text("Community"),
                  trailing: Switch(value: false, onChanged: (_) {})),
              ListTile(
                  title: const Text("Profiles"),
                  trailing: Switch(value: false, onChanged: (_) {})),
              ListTile(
                  title: const Text("Entertainment"),
                  trailing: Switch(value: false, onChanged: (_) {})),
              ListTile(
                  title: const Text("Sports"),
                  trailing: Switch(value: false, onChanged: (_) {})),
              ListTile(
                  title: const Text("Surveys"),
                  trailing: Switch(value: false, onChanged: (_) {})),
              const Divider(),
            ],
          ),
          isExpanded: expanded,
        ),
      ],
    );
  }
}
