import 'package:app/ui/preview_card/post_preview_card.dart';
import 'package:flutter/material.dart';

class SavedsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView.builder(
          itemBuilder: (context, i) {
            return Container(
              padding: EdgeInsets.symmetric(vertical: 6)
            );
          }
      ),
    );
  }

}