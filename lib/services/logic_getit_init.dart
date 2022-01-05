import 'package:app/logic/media_logic.dart';
import 'package:app/logic/posts_logic.dart';
import 'package:app/logic/section_logic.dart';
import 'package:app/views/article_view/article_view_logic.dart';
import 'package:app/views/home_view/home_view_logic.dart';
import 'package:get_it/get_it.dart';

final GetIt getIt = GetIt.instance;

/// NOTE: Must initialize wordpress services before calling this method.
void setupGetIt() {
  getIt.registerLazySingleton<ArticleViewLogic>(() => ArticleViewLogic());
  getIt.registerLazySingleton<MediaLogic>(() => MediaLogic());
  getIt.registerLazySingleton<SectionLogic>(() => SectionLogic());
  getIt.registerLazySingleton<HomeViewLogic>(() => HomeViewLogic());
  getIt.registerLazySingleton<PostsLogic>(() => PostsLogic());
}
