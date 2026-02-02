import 'package:flutter/foundation.dart';

import '../models/post.dart';
import '../models/user.dart';
import '../services/api_service.dart';
import '../services/bookmark_service.dart';


enum PostsState {
  initial,
  loading,
  success,
  error,
}


class PostsProvider extends ChangeNotifier {
  PostsProvider({
    ApiService? apiService,
    BookmarkService? bookmarkService,
  })  : _apiService = apiService ?? ApiService(),
        _bookmarkService = bookmarkService ?? BookmarkService();

  final ApiService _apiService;
  final BookmarkService _bookmarkService;

  PostsState _state = PostsState.initial;
  PostsState get state => _state;

  List<Post> _posts = [];
  Map<int, User> _userById = {};
  Set<int> _bookmarkedIds = {};
  String _filterQuery = '';
  String _errorMessage = '';

  List<Post> get posts => _posts;
  Map<int, User> get userById => _userById;
  Set<int> get bookmarkedIds => _bookmarkedIds;
  String get filterQuery => _filterQuery;
  String get errorMessage => _errorMessage;

  List<Post> get filteredPosts {
    if (_filterQuery.isEmpty) return _posts;
    final q = _filterQuery.toLowerCase();
    return _posts.where((p) => p.title.toLowerCase().contains(q)).toList();
  }

  List<Post> get bookmarkedPosts {
    return _posts.where((p) => _bookmarkedIds.contains(p.id)).toList();
  }

  String authorNameFor(Post post) {
    final user = _userById[post.userId];
    return user?.name ?? 'Unknown';
  }

  bool isBookmarked(int postId) => _bookmarkedIds.contains(postId);


  Future<void> loadPosts() async {
    _state = PostsState.loading;
    _errorMessage = '';
    notifyListeners();

    final result = await _apiService.fetchPostsWithAuthors();

    if (result is ApiResultSuccess) {
      _posts = result.posts;
      _userById = result.userById;
      await _loadBookmarks();
      _state = PostsState.success;
    } else if (result is ApiResultFailure) {
      _errorMessage = result.message;
      _state = PostsState.error;
    }
    notifyListeners();
  }

  Future<void> _loadBookmarks() async {
    _bookmarkedIds = await _bookmarkService.getBookmarkedIds();
  }

  void setFilterQuery(String query) {
    _filterQuery = query;
    notifyListeners();
  }

  Future<void> toggleBookmark(int postId) async {
    final added = await _bookmarkService.toggleBookmark(postId);
    if (added) {
      _bookmarkedIds.add(postId);
    } else {
      _bookmarkedIds.remove(postId);
    }
    notifyListeners();
  }

  Future<void> retry() => loadPosts();
}
