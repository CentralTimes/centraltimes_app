import 'package:app/models/sections/section_model.dart';

class SectionLogic {
  List<SectionModel> parseSections(String rawContent) {
    List<SectionModel> sections = [];
    List<String> raws = rawContent.split("\r\n\r\n");
    for (String raw in raws) {
      if (raw.trim().isEmpty) continue;
      //List<Short>
    }
    return sections;
  }
}
