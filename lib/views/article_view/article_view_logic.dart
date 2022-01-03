import 'package:app/logic/media_logic.dart';
import 'package:app/logic/section_logic.dart';
import 'package:app/models/post_model.dart';
import 'package:app/models/sections/image_model.dart';
import 'package:app/models/sections/pullquote_model.dart';
import 'package:app/models/sections/section_model.dart';
import 'package:app/services/logic_getit_init.dart';
import 'package:flutter/material.dart';

class ArticleViewLogic {
  final ValueNotifier<bool> viewInitializedNotifier =
      ValueNotifier<bool>(false);

  List<SectionModel> sections = [];

  Future<void> initView(PostModel post) async {
    SectionLogic sectionLogic = getIt<SectionLogic>();
    MediaLogic mediaLogic = getIt<MediaLogic>();
    sections = sectionLogic.parseSections(post.rawContent);
    List<int> imgIds = [];
    if (post.featuredMedia != 0) imgIds.add(post.featuredMedia);
    for (SectionModel section in sections) {
      switch (section.runtimeType) {
        case ImageModel:
          ImageModel image = section as ImageModel;
          if (image.id != 0) {
            imgIds.add(image.id);
          }
          break;
        case PullquoteModel:
          PullquoteModel pullquoteModel = section as PullquoteModel;
          if (pullquoteModel.imageId != null && pullquoteModel.imageId != 0) {
            imgIds.add(pullquoteModel.imageId!);
          }
          break;
        default:
      }
    }
    await mediaLogic.getMedia(imgIds);
    viewInitializedNotifier.value = true;
  }

  void reset() {
    viewInitializedNotifier.value = false;
    sections = [];
  }
}
