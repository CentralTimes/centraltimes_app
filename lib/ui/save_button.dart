import 'package:app/services/saved_posts_service.dart';
import 'package:flutter/material.dart';

class SaveButton extends StatefulWidget {
  final int id;
  final Color? iconColor;

  @override
  State<StatefulWidget> createState() => _SaveButtonState(id, iconColor);

  SaveButton(this.id, {this.iconColor});
}

class _SaveButtonState extends State<SaveButton> {
  final int id;
  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    return IconButton(
        onPressed: () {
          SavedPostsService.togglePost(this.id)
              .then((value) => setState(() => {}));
        },
        icon: Icon(
            SavedPostsService.isPostSaved(this.id)
                ? Icons.bookmark
                : Icons.bookmark_add_outlined,
            color: iconColor ?? Theme.of(context).primaryColor));
  }

  _SaveButtonState(this.id, this.iconColor);
}
