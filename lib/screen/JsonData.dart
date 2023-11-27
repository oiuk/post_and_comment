import 'package:flutter/cupertino.dart';
import 'Post_Screen.dart';

class Post {
  int postId;
  String postTitle;
  String postContent;
  String authorName;
  List<Comment> commentList;

  Post({
    required this.postId,
    required this.postTitle,
    required this.postContent,
    required this.authorName,
    required this.commentList,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    List<Comment> comments = [];
    if (json['comment_list'] != null) {
      var commentList = json['comment_list'] as List;
      comments = commentList.map((comment) => Comment.fromJson(comment)).toList();
    }
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
  int commentId;
  final String commentContent;
  final String authorName;
  final int? parentId;
  final List<Comment> replies;

  Comment({
    required this.commentId,
    required this.commentContent,
    required this.authorName,
    this.parentId,
    required this.replies,
  });

  factory Comment.fromJson(Map<String, dynamic> json) {
    List<Comment> replies = [];
    if (json['replies'] != null) {
      var repliesList = json['replies'] as List;
      replies = repliesList.map((reply) => Comment.fromJson(reply)).toList();
    }
    return Comment(
      commentId: json['comment_id'],
      commentContent: json['comment_content'],
      authorName: json['author_name'],
      parentId: json['parent_id'],
      replies: replies,
    );
  }
}
