import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/post.dart';
import '../models/user.dart';

const _baseUrl = 'https://jsonplaceholder.typicode.com';

final _headers = {
  'User-Agent': 'PostsApp/1.0 (Flutter)',
  'Accept': 'application/json',
};

class ApiService {
  ApiService({http.Client? client}) : _client = client ?? http.Client();

  final http.Client _client;

  Future<ApiResult> fetchPostsWithAuthors() async {
    try {
      final results = await Future.wait([
        getUrl('$_baseUrl/posts'),
        getUrl('$_baseUrl/users'),
      ]);
      final postsRes = results[0];
      final usersRes = results[1];

      if (postsRes.statusCode != 200 || usersRes.statusCode != 200) {
        return ApiResult.failure(
          'Failed to load: ${postsRes.statusCode}, ${usersRes.statusCode}',
        );
      }

      final posts = parsePosts(postsRes.body);
      final users = parseUsers(usersRes.body);
      final userById = toUserMap(users);

      return ApiResult.success(posts: posts, userById: userById);
    } catch (e) {
      return ApiResult.failure('$e');
    }
  }

  Future<http.Response> getUrl(String url) {
    return _client.get(Uri.parse(url), headers: _headers);
  }

  List<Post> parsePosts(String body) {
    final list = jsonDecode(body) as List<dynamic>;
    return list.map((e) => Post.fromJson(e as Map<String, dynamic>)).toList();
  }

  List<User> parseUsers(String body) {
    final list = jsonDecode(body) as List<dynamic>;
    return list.map((e) => User.fromJson(e as Map<String, dynamic>)).toList();
  }

  Map<int, User> toUserMap(List<User> users) {
    return {for (final u in users) u.id: u};
  }
}

class ApiResult {
  const ApiResult._();

  factory ApiResult.success({
    required List<Post> posts,
    required Map<int, User> userById,
  }) = ApiResultSuccess;

  factory ApiResult.failure(String message) = ApiResultFailure;
}

class ApiResultSuccess extends ApiResult {
  ApiResultSuccess({required this.posts, required this.userById}) : super._();

  final List<Post> posts;
  final Map<int, User> userById;
}

class ApiResultFailure extends ApiResult {
  ApiResultFailure(this.message) : super._();

  final String message;
}
