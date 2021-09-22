import 'package:app/services/shared_prefs_service.dart';
import 'package:app/ui/post_list_view.dart';
import 'package:app/widgets/custom_dialogs.dart';
import 'package:app/widgets/drawer.dart';
import 'package:app/widgets/search.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeView extends StatefulWidget {
  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> with TickerProviderStateMixin {
  late List<List<Map<String, dynamic>>?> snippetsList;
  late List<ValueNotifier<bool>>
      notifiersList; // notifies rebuild of entire category
  late TabController tabController;
  late List<DateTime?> lastUpdatedList;
  Map<String, ValueNotifier<bool>> idsToNotifiers = Map();
  late List<Map<String, dynamic>> savedList;
  ValueNotifier<bool> updateSaved = ValueNotifier(true);
  int bottomIndex = 0;
  late List<String> savedIds;
  bool savedLoaded = false;
  List<Map<String, dynamic>>? categoryData;
  static const double cooldownSecs = 30;
  static const int saveLimit = 7;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      drawer: AppDrawer(),
        /*bottomNavigationBar: BottomNavigationBar(
            onTap: (value) => setState(() {
                  bottomIndex = value;
                }),
            currentIndex: bottomIndex,
            items: [
              BottomNavigationBarItem(
                  icon: Icon(Icons.article_outlined), label: "News"),
              //BottomNavigationBarItem(icon: Icon(Icons.poll_outlined), label: "Surveys"),
              BottomNavigationBarItem(
                  icon: Icon(Icons.bookmarks_outlined), label: "Saved"),
            ]),*/
        body: NestedScrollView(
      headerSliverBuilder: (context, innerBoxIsScrolled) {
        return [
          SliverAppBar(
            centerTitle: true,
            title: Text("Central Times"),
            actions: [
              IconButton(
                  onPressed: () {
                    showSearch(
                        context: context, delegate: SearchNewsDelegate());
                  },
                  icon: Icon(Icons.search))
            ],
            pinned: false,
            floating: true,
          )
        ];
      },
      body: PostListView(),
    ));
  }

  void refreshCategory(int index) {
    if (lastUpdatedList[index] == null ||
        DateTime.now().difference(lastUpdatedList[index]!).inSeconds >
            cooldownSecs) {
      lastUpdatedList[index] = DateTime.now();
    }
  }

  void initSaved(SharedPreferences? prefs) {
    if (prefs != null) {
      List<String> sIds;
      sIds = prefs.getStringList("saved") ?? List.empty();
    }
  }

  void saveArticle(String id, bool newValue, BuildContext context) {
    if (newValue == true && savedIds.length >= saveLimit) {
      showErrorDialog(context,
          "Limit of $saveLimit saved articles reached. Press the bookmark icon under one of your saved articles to remove it and free up space for other articles.");
    } else {
      idsToNotifiers[id]?.value = newValue;
    }
  }

  void setupSavedNotifier(ValueNotifier<bool> notifier, String id,
      Map<String, dynamic> data, BuildContext context) {
    notifier.addListener(() {
      switch (notifier.value) {
        case true:
          if (!savedIds.contains(id)) {
            savedIds.insert(0, id);
            savedList.insert(0, data);
            updateSaved.value = !updateSaved.value;
            ValueNotifier<SharedPreferences?> prefsNotifier =
                SharedPrefsService.prefsNotifier;
            prefsNotifier.value?.setStringList("saved", savedIds);
          }
          break;
        case false:
          int sIndex = savedIds.indexOf(id);
          if (sIndex != -1) {
            savedList.removeAt(sIndex);
            savedIds.removeAt(sIndex);

            updateSaved.value = !updateSaved.value;
            ValueNotifier<SharedPreferences?> prefsNotifier =
                SharedPrefsService.prefsNotifier;
            prefsNotifier.value?.setStringList("saved", savedIds);
          }
          break;
        default:
      }
    });
  }
}
