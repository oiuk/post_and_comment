class Post {
  final int postId;
  final String postTitle;
  final String postContent;
  final String authorName;
  final List<Comment> commentList;

  Post({
    required this.postId,
    required this.postTitle,
    required this.postContent,
    required this.authorName,
    required this.commentList,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    List<Comment> comments = (json['comment_list'] as List)
        .map((comment) => Comment.fromJson(comment))
        .toList();

    return Post(
      postId: json['post_id'],
      postTitle: json['post_title'],
      postContent: json['post_content'],
      authorName: json['author_name'],
      commentList: comments,
    );
  }
}

class Comment {
  final int commentId;
  final String commentContent;
  final String authorName;
  final int? parentId;
  List<Comment> replies;

  Comment({
    required this.commentId,
    required this.commentContent,
    required this.authorName,
    this.parentId,
    required this.replies,
  });

  factory Comment.fromJson(Map<String, dynamic> json) {
    List<Comment> replyList = [];
    if (json['replies'] != null) {
      replyList = (json['replies'] as List).map((reply) => Comment.fromJson(reply)).toList();
    }

    return Comment(
      commentId: json['comment_id'] ?? 0,
      commentContent: json['comment_content'] ?? '',
      authorName: json['author_name'] ?? '',
      parentId: json['parent_id'],
      replies: replyList,
    );
  }
}


