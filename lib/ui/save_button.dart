import 'package:app/services/saved_posts_service.dart';
import 'package:flutter/material.dart';

class SaveButton extends StatefulWidget {
  final int id;
  final Color? iconColor;

  @override
  State<StatefulWidget> createState() => _SaveButtonState();

  const SaveButton(this.id, {Key? key, this.iconColor}) : super(key: key);
}

class _SaveButtonState extends State<SaveButton> {
  @override
  Widget build(BuildContext context) {
    return IconButton(
        onPressed: () {
          SavedPostsService.togglePost(widget.id)
              .then((value) => setState(() => {}));
        },
        icon: Icon(
            SavedPostsService.isPostSaved(widget.id)
                ? Icons.bookmark
                : Icons.bookmark_add_outlined,
            color: widget.iconColor ?? Theme.of(context).primaryColor));
  }
}
