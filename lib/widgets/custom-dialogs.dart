import 'package:flutter/material.dart';

Future<void> showErrorDialog(BuildContext context, String text) async {
  return showCustomDialog<void>(
      context: context,
      icon: Icons.warning_outlined,
      header: "Oh Noes!",
      content: Text(text),
      actions: [
        TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text("Got It")),
      ]);
}

Future<void> showLoadingDialog(BuildContext context, String text) async {
  return showDialog<void>(
      context: context,
      builder: (context) => SimpleDialog(children: [
            ListTile(leading: CircularProgressIndicator(), title: Text(text)),
          ]),
      barrierDismissible: false);
}

Future<bool> showPromptDialog(BuildContext context, String text) async {
  var value = await showCustomDialog<bool>(
      context: context,
      icon: Icons.info_outlined,
      header: text,
      actions: [
        TextButton(
            onPressed: () {
              Navigator.of(context).pop(true);
            },
            child: Text("Yes"),
            style: ButtonStyle(
                side: MaterialStateProperty.all(
                    BorderSide(color: Theme.of(context).primaryColor)))),
        TextButton(
            onPressed: () {
              Navigator.of(context).pop(false);
            },
            child: Text("No")),
      ]);
  return value ?? false;
}

Future<T?> showSubmitDialog<T>(
    BuildContext context, String text, Widget content, T Function() onSubmitted) {
  return showCustomDialog<T>(
      context: context,
      icon: Icons.info_outlined,
      header: text,
      content: content,
      actions: [
        TextButton(
            onPressed: () {
              Navigator.of(context).pop(onSubmitted());
            },
            child: Text("Enter"),
            style: ButtonStyle(
                side: MaterialStateProperty.all(
                    BorderSide(color: Theme.of(context).primaryColor)))),
        TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text("Cancel")),
      ]);
}

Future<T?> showCustomDialog<T>(
    {required BuildContext context,
    required IconData icon,
    required String header,
    Widget? content,
    List<Widget>? actions}) async {
  return showDialog<T>(
      context: context,
      builder: (context) => AlertDialog(
            title: Icon(icon, color: Theme.of(context).primaryColor),
            content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(header, style: Theme.of(context).textTheme.headline6),
                  Padding(padding: EdgeInsets.all(3)),
                  content ?? Container(),
                ]),
            actions: actions,
          ));
}
