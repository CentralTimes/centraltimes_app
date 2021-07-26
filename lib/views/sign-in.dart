import 'package:android_intent_plus/android_intent.dart';
import 'package:app/services/auth_service.dart';
import 'package:app/constants.dart';
import 'package:app/views/home.dart';
import 'package:app/widgets/custom-dialogs.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

class SignInView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Ink(
        color: Theme.of(context).primaryColor,
        width: double.infinity,
        height: double.infinity,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 50),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("CT",
                  style: Theme.of(context)
                      .textTheme
                      .headline1!
                      .copyWith(color: Theme.of(context).canvasColor)),
              Text("in the middle of it.",
                  textAlign: TextAlign.center,
                  style: Theme.of(context)
                      .textTheme
                      .headline5!
                      .copyWith(color: Theme.of(context).canvasColor)),
              Padding(
                padding: EdgeInsets.all(10),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: 300),
                  child: ListTile(
                      onTap: () async {
                        try {
                          await showLoadingDialog(context, "Signing in...", () async => await AuthService.signIn());
                          Navigator.push(context, MaterialPageRoute(builder: (_) => HomeView()));
                        } on String catch (e) {
                          if (e != "") showErrorDialog(context, e);
                        }
                      },
                      title: Text("Sign In", textAlign: TextAlign.center, style: Theme.of(context).textTheme.headline5),
                      subtitle: Text("With a District 203 Google Account", textAlign: TextAlign.center),
                      tileColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                        side: BorderSide(color: Theme.of(context).canvasColor),
                      )),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: 300),
                  child: ListTile(
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => HomeView())),
                      title: Text("Continue as Guest", textAlign: TextAlign.center, style: Theme.of(context).textTheme.headline5!.copyWith(color: Theme.of(context).canvasColor)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                        side: BorderSide(color: Theme.of(context).canvasColor),
                      )),
                ),
              ),
              Wrap(
                alignment: WrapAlignment.center,
                children: [
                  IconButton(onPressed: () => launch(facebookURL), icon: ImageIcon(AssetImage("assets/images/facebook.png")), iconSize: 40, color: Theme.of(context).canvasColor),
                  IconButton(onPressed: () => launch(twitterURL), icon: ImageIcon(AssetImage("assets/images/twitter.png")), iconSize: 40, color: Theme.of(context).canvasColor),
                  IconButton(onPressed: () {
                    AndroidIntent(action: "http://instagram.com/_u/centraltimes", data: "com.instagram.android").launch().onError<PlatformException>((error, stackTrace) => launch(instagramURL));
                  }, icon: ImageIcon(AssetImage("assets/images/instagram.png")), iconSize: 40, color: Theme.of(context).canvasColor),
                  IconButton(onPressed: () => launch(youtubeURL), icon: ImageIcon(AssetImage("assets/images/youtube.png")), iconSize: 40, color: Theme.of(context).canvasColor),
                  IconButton(onPressed: () => launch(webURL), icon: Icon(Icons.language_outlined), iconSize: 48, padding: EdgeInsets.all(4), color: Theme.of(context).canvasColor),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
