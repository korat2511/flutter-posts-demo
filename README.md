Posts App

A Flutter app that shows posts from JSONPlaceholder. You can filter by title, bookmark posts, and see who wrote each one.

How to run

Make sure you have Flutter installed on your machine. Run flutter doctor to check.

Then open the project folder and run:

  flutter pub get
  flutter run

That will install dependencies and launch the app. If you have multiple devices connected, use flutter run -d and the device id (for example, flutter run -d chrome for web or the name of your iOS simulator).

Architecture

The app fetches posts and users from JSONPlaceholder. Both requests run at the same time so the screen loads faster. Each post has a userId, and we match that to the right user from the users list to show the author name. We keep a map of user id to user so looking up the author for any post is instant.

State is handled with Provider. The posts provider holds the posts, the users map, the filter text, and which posts are bookmarked. Bookmarks are saved with SharedPreferences so they stay even after you close the app.

The UI is split into screens (posts list and bookmarks) and a reusable post card widget. The API layer lives in its own service, so swapping the data source or adding tests is straightforward.
