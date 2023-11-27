import 'package:flutter/material.dart';
import 'models.dart';

class PostDetailScreen extends StatefulWidget {
  final Map<String, dynamic> postData;

  const PostDetailScreen({Key? key, required this.postData}) : super(key: key);

  @override
  _PostDetailScreenState createState() => _PostDetailScreenState();
}

class _PostDetailScreenState extends State<PostDetailScreen> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _contentController = TextEditingController();
  List<Comment> comments = []; // 여기에 댓글들이 저장됩니다.
  static const int START_INDEX = -1;
  int selectedCommentIndex = START_INDEX;
  String postingUserName = "";

  @override
  void initState() {
    super.initState();
    _loadComments(); // 화면이 초기화될 때 댓글을 불러옵니다.
  }

  void _loadComments() {
    setState(() {
      comments = commentsFromJson(jsonData); // JSON 데이터에서 댓글을 불러옵니다.
    });
  }

  void _resetSelectedComment() {
    setState(() {
      selectedCommentIndex = START_INDEX;
      postingUserName = "";
    });
  }

  void _clearFields() {
    // 코멘트 작성과 관련된 필드 초기화 함수
    _nameController.clear(); // 이름 입력 필드를 초기화합니다.
    _contentController.clear(); // 코멘트 입력 필드를 초기화합니다.
    setState(() {
      selectedCommentIndex = START_INDEX; // 선택된 코멘트 인덱스를 초기화합니다.
      postingUserName = ""; // 현재 작성 중인 사용자 이름을 초기화합니다.
    });
  }

  void _postComment() {
    final name = _nameController.text;
    final commentText = _contentController.text;

    if (name.isEmpty || commentText.isEmpty) {
      return; // 이름이나 코멘트 내용이 비어있으면 종료합니다.
    }

    setState(() {
      if (selectedCommentIndex != START_INDEX) {
        _replyToComment(name, commentText); // 선택된 코멘트에 대댓글을 추가하는 함수 호출
      } else {
        _addNewComment(name, commentText); // 새로운 코멘트를 추가하는 함수 호출
      }

      _clearFields(); // 필드 초기화
    });
  }

  void _replyToComment(String name, String commentText) {
    // 선택된 코멘트에 대댓글을 추가
    final selectedComment = comments[selectedCommentIndex]; // 현재 선택된 코멘트를 가져옵니다.
    final reply = Comment(
      authorName: name,
      commentContent: commentText,
    ); // 사용자가 입력한 이름과 코멘트 내용으로 대댓글 객체를 생성합니다.
    if (selectedComment.replies == null) {
      selectedComment.Comment = []; // 대댓글이 없으면 빈 List를 생성합니다.
    }
    selectedComment.replies!.add(reply); // 이전에 선택한 코멘트에 새로 작성된 대댓글을 추가합니다.
  }

  void _addNewComment(String name, String commentText) {
    // 리스트에 새로운 코멘트를 추가
    final newComment = Comment(
      authorName: name,
      commentContent: commentText,
      replies: [], // 댓글 추가 시, replies를 빈 List로 초기화합니다.
    );
    comments.add(newComment); // 위에서 생성한 코멘트를 코멘트 목록에 추가합니다.
  }


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.blue,
          title: Text(
            '자유게시판',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      '제목 : ${widget.postData['post_title']}',
                      style:
                          TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 5),
                    Text(
                      ' 작성자 : ${widget.postData['author_name']}',
                      style: TextStyle(fontSize: 15),
                    ),
                    SizedBox(height: 10),
                    Text(
                      '${widget.postData['post_content']}',
                      style: TextStyle(fontSize: 14),
                    ),
                    SizedBox(height: 10),
                    Divider(
                      thickness: 2,
                      color: Colors.grey,
                    ),
                    ListView.builder(
                      shrinkWrap: true,
                      itemCount: widget.postData['comment_list'].length,
                      itemBuilder: (context, index) {
                        final commentData =
                            widget.postData['comment_list'][index];
                        return Card(
                          margin: EdgeInsets.symmetric(vertical: 4),
                          child: ListTile(
                            title: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                    '${commentData['author_name']} : ${commentData['comment_content']}'),
                              ],
                            ),
                            subtitle: ListView.builder(
                              shrinkWrap: true,
                              itemCount: commentData['replies'].length,
                              itemBuilder: (context, replyIndex) {
                                final replyData =
                                    commentData['replies'][replyIndex];
                                return Padding(
                                  padding: const EdgeInsets.only(left: 16),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                          ' ✓ ${replyData['author_name']} : ${replyData['comment_content']}'),
                                      SizedBox(height: 5),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: TextField(
                            controller: _nameController,
                            decoration: InputDecoration(
                              contentPadding:
                                  EdgeInsets.symmetric(horizontal: 10),
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.never,
                              hintText: '이름 입력',
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: TextField(
                            controller: _contentController,
                            decoration: InputDecoration(
                              contentPadding:
                                  EdgeInsets.symmetric(horizontal: 10),
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.never,
                              hintText: '댓글 입력',
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.send),
                        onPressed: _postComment,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
