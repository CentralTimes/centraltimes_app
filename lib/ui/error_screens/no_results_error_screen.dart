import 'package:app/ui/error_screens/error_screen.dart';

class NoResultsErrorScreen extends ErrorScreen {
  const NoResultsErrorScreen({key})
      : super(
            key: key,
            title: "No Results",
            message:
                "The posts query with the current filters enabled produced no results.");
}
