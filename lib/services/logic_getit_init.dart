import 'package:app/logic/media_logic.dart';
import 'package:app/views/article_view/article_view_logic.dart';
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

void setupGetIt() {
  getIt.registerLazySingleton<ArticleViewLogic>(() => ArticleViewLogic());
  getIt.registerLazySingleton<MediaLogic>(() => MediaLogic());
}
