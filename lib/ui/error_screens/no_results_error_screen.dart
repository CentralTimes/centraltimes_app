import 'package:app/ui/error_screens/error_screen.dart';

class NoResultsErrorScreen extends ErrorScreen {
  NoResultsErrorScreen()
      : super(
            title: "No Results",
            message:
                "The posts query with the current filters enabled produced no results.");
}
