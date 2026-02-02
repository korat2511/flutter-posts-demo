import 'package:flutter/material.dart';

import '../models/post.dart';

class PostCard extends StatelessWidget {
  const PostCard({
    super.key,
    required this.post,
    required this.authorName,
    required this.isBookmarked,
    required this.onBookmarkTap,
  });

  final Post post;
  final String authorName;
  final bool isBookmarked;
  final VoidCallback onBookmarkTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final avatarColor = _avatarColor(post.userId);

    return Card(
      color: Colors.white,
      surfaceTintColor: Colors.transparent,
      elevation: 8,
      shadowColor: Colors.black.withValues(alpha: 0.25),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 12, 4, 8),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor: avatarColor,
                child: Text(
                  authorName.isNotEmpty ? authorName[0].toUpperCase() : '?',
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    authorName,
                    style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                      color: const Color(0xFF262626),
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                IconButton(
                  onPressed: onBookmarkTap,
                  icon: Icon(
                    isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                    color: const Color(0xFF262626),
                    size: 24,
                  ),
                  tooltip: isBookmarked ? 'Remove bookmark' : 'Bookmark',
                  style: IconButton.styleFrom(
                    minimumSize: const Size(44, 44),
                    padding: EdgeInsets.zero,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 4, 12, 4),
            child: RichText(
              text: TextSpan(
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: const Color(0xFF262626),
                ),
                children: [
                  TextSpan(
                    text: '$authorName ',
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  TextSpan(text: post.title),
                ],
              ),
            ),
          ),
          if (post.body.isNotEmpty)
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
              child: Text(
                post.body,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: const Color(0xFF8E8E8E),
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            )
          else
            const SizedBox(height: 12),
        ],
      ),
    );
  }

  Color _avatarColor(int userId) {
    const colors = [
      Color(0xFFE1306C),
      Color(0xFF405DE6),
      Color(0xFF5851DB),
      Color(0xFF833AB4),
      Color(0xFFFD1D1D),
      Color(0xFFF56040),
      Color(0xFFF77737),
      Color(0xFFFCAF45),
      Color(0xFFFFDC80),
    ];
    return colors[userId % colors.length];
  }
}
