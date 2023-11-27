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
  final List<Comment>? replies; // replies를 선택적(optional)으로 수정

  Comment({
    required this.commentId,
    required this.commentContent,
    required this.authorName,
    this.parentId,
    this.replies, // 선택적(optional)으로 변경
  });

  factory Comment.fromJson(Map<String, dynamic> json) {
    List<Comment>? replyList = (json['replies'] as List<dynamic>?)
        ?.map((reply) => Comment.fromJson(reply))
        .toList();

    return Comment(
      commentId: json['comment_id'],
      commentContent: json['comment_content'],
      authorName: json['author_name'],
      parentId: json['parent_id'],
      replies: replyList,
    );
  }
}
