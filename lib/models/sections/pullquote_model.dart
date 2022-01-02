import 'package:app/models/media_model.dart';
import 'package:app/models/sections/section_model.dart';

class PullquoteModel extends SectionModel {
  final String quote;
  final String? speaker;
  final int? imageId;

  const PullquoteModel({required this.quote, this.speaker, this.imageId});

  @override
  String toString() {
    return 'PullquoteModel{id: $imageId, quote: $quote, speaker: $speaker}';
  }
}
