import 'package:flutter/material.dart';
import 'models.dart';

// 초기 상수와 변수 설정
const int START_INDEX = -1; // 초기 인덱스
const double defaultFontSize = 18.0; // 기본 폰트 크기
const double boldFontSize = 20.0; // 볼드체 폰트 크기
const double titleFontSize = 25.0; // 타이틀 폰트 크기

// 게시물 상세 화면 위젯
class PostDetailScreen extends StatefulWidget {
  final Map<String, dynamic> postData; // 게시물 데이터

  const PostDetailScreen({Key? key, required this.postData}) : super(key: key);

  @override
  _PostDetailScreenState createState() => _PostDetailScreenState();
}

// 게시물 상세 화면 상태 클래스
class _PostDetailScreenState extends State<PostDetailScreen> {
  // 사용할 컨트롤러와 상태 변수
  TextEditingController _nameController = TextEditingController();
  TextEditingController _contentController = TextEditingController();
  List<Comment> comments = []; // 클래스 내에서 댓글 목록을 저장하기 위한 변수
  int selectedCommentIndex = START_INDEX; // 선택된 댓글 인덱스
  String postingUserName = ""; // 댓글 작성자 이름

  // 위젯 생성 초기에 댓글 로딩
  // StatefulWidget의 상태가 초기화될 때 호출되는 메서드
  // _loadComments() : 댓글 데이터를 불러와서 상태를 업데이트하는 역할
  @override
  void initState() {
    super.initState();
    _loadComments();
  }

  // 댓글 로드 함수
  void _loadComments() {
    setState(() {
      List<Map<String, dynamic>> commentData = widget.postData['comment_list'];
      comments = commentsFromJson(commentData); // JSON 데이터를 Comment 모델로 변환
    });
  }

  // 댓글 탭 처리 함수
  // 댓글을 선택하거나 선택을 해제하는 작업
  void _handleCommentTap(Comment comment) {
    setState(() {
      // 선택된 댓글 토글 처리
      selectedCommentIndex = (selectedCommentIndex == comments.indexOf(comment))
          ? START_INDEX
          : comments.indexOf(comment);
      postingUserName =
          (selectedCommentIndex == START_INDEX) ? "" : comment.authorName;
    });
  }

  // 선택된 댓글 리셋 함수
  void _resetSelectedComment() {
    setState(() {
      selectedCommentIndex = START_INDEX;
      postingUserName = "";
    });
  }

  // 입력 필드 클리어 함수
  void _clearFields() {
    _nameController.clear();
    _contentController.clear();
    _resetSelectedComment();
  }

  // 댓글 작성 함수
  void _postComment() {
    final name = _nameController.text;
    final commentText = _contentController.text;

    // 이름 또는 댓글이 비어있으면 함수 종료
    if (name.isEmpty || commentText.isEmpty) {
      return;
    }

    setState(() {
      // 선택된 댓글에 대댓글 작성 또는 새로운 댓글 추가
      if (selectedCommentIndex != START_INDEX) {
        _replyToComment(name, commentText);
      } else {
        _addNewComment(name, commentText);
      }

      _clearFields(); // 필드 클리어
    });
  }

  // 새로운 댓글 추가 함수
  // 작성한 이름과 댓글 내용을 사용, 새로운 댓글을 생성하고 목록에 추가
  void _addNewComment(String name, String commentText) {
    final commentId = comments.length > 0 ? comments.last.commentId + 1 : 1;

    // 새로운 댓글 생성 및 추가
    final newComment = Comment(
      commentId: commentId,
      commentContent: commentText,
      authorName: name,
      replies: [],
    );
    comments.add(newComment);
  }

  // 댓글에 대댓글 작성 함수
  // comments[selectedCommentIndex] : 선택된 댓글
  // commentId 댓글 개수 확인하여 ID 설정
  void _replyToComment(String name, String commentText) {
    final selectedComment = comments[selectedCommentIndex];
    final commentId = comments.length > 0 ? comments.last.commentId + 1 : 1;

    // 대댓글 생성 및 추가
    final comment = Comment(
      commentId: commentId,
      commentContent: commentText,
      authorName: name,
      replies: [],
    );
    selectedComment.replies?.add(comment);
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
              style: TextStyle(color: Colors.white),
            )),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: [
                  Icon(Icons.account_box, color: Colors.grey),
                  Text(' ${widget.postData['author_name']}',
                      style: TextStyle(
                          fontSize: boldFontSize, fontWeight: FontWeight.bold)),
                ],
              ),
              SizedBox(height: 5),
              Text('${widget.postData['post_title']}',
                  style: TextStyle(
                      fontSize: titleFontSize, fontWeight: FontWeight.bold)),
              SizedBox(height: 5),
              Text('${widget.postData['post_content']}',
                  style: TextStyle(fontSize: defaultFontSize)),
              SizedBox(height: 10),
              Divider(thickness: 2, color: Colors.grey),
              Expanded(
                child: ListView.builder(
                  itemCount: comments.length,
                  itemBuilder: (context, index) {
                    return CommentWidget(
                        comment: comments[index],
                        handleCommentTap: _handleCommentTap);
                  },
                ),
              ),
              if (postingUserName.isNotEmpty)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('$postingUserName 님에게 답글 입력 중입니다...',
                        style: TextStyle(
                            fontStyle: FontStyle.italic,
                            color: Colors.grey,
                            fontSize: defaultFontSize)),
                    GestureDetector(
                      onTap: _resetSelectedComment,
                      child: Row(
                        children: [
                          Text('취소 ',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: defaultFontSize)),
                          Icon(Icons.close, size: defaultFontSize),
                        ],
                      ),
                    ),
                  ],
                ),
              Divider(thickness: 2, color: Colors.grey),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                        controller: _nameController,
                        decoration: InputDecoration(
                            labelText: ' 이름',
                            floatingLabelBehavior:
                                FloatingLabelBehavior.never)),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                      flex: 3,
                      child: TextField(
                          controller: _contentController,
                          decoration: InputDecoration(
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.never,
                              labelText: (selectedCommentIndex != START_INDEX)
                                  ? ' 대댓글을 입력하세요.'
                                  : ' 댓글을 입력하세요.'))),
                  SizedBox(width: 10),
                  IconButton(icon: Icon(Icons.send), onPressed: _postComment),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

List<Map<String, dynamic>> JsonData = [
  {
    "post_id": 1,
    "post_title": "오늘 구관밥 머나옴?",
    "post_content": "ㅈㄱㄴ",
    "author_name": "김민수",
    "comment_list": [
      {
        "comment_id": 1,
        "comment_content": "고순조",
        "author_name": "이영희",
        "parent_id": null,
        "replies": [
          {
            "comment_id": 2,
            "comment_content": "진짜임?",
            "author_name": "김민수",
            "parent_id": 1
          },
          {
            "comment_id": 3,
            "comment_content": "저거아님",
            "author_name": "구자철",
            "parent_id": 1
          }
        ]
      },
      {
        "comment_id": 4,
        "comment_content": "ㅇㄷ",
        "author_name": "손흥민",
        "parent_id": null,
        "replies": [
          {
            "comment_id": 5,
            "comment_content": "2222222",
            "author_name": "이창해",
            "parent_id": 4
          }
        ]
      }
    ]
  },
  {
    "post_id": 2,
    "post_title": "시험",
    "post_content": "언제끝나냐,,,",
    "author_name": "구자철",
    "comment_list": [
      {
        "comment_id": 6,
        "comment_content": "난 끝남~",
        "author_name": "손흥민",
        "parent_id": null,
        "replies": [
          {
            "comment_id": 7,
            "comment_content": "2222222",
            "author_name": "이창해",
            "parent_id": 6
          },
          {
            "comment_id": 8,
            "comment_content": "왜 이렇게 일찍 끝나??",
            "author_name": "구자철",
            "parent_id": 6
          }
        ]
      }
    ]
  }
];

// JSON 데이터를 Comment 객체 리스트로 변환하는 함수
List<Comment> commentsFromJson(List<Map<String, dynamic>> jsonData) {
  List<Comment> comments = []; // JSON 데이터로부터 댓글 목록을 생성하는 함수
  Map<int, Comment> parentComments = {}; // 부모 댓글과 대댓글을 관리하는 맵

  for (var item in jsonData) {
    Comment comment = Comment.fromJson(item); // JSON 데이터를 Comment 객체로 변환
    final parentId = item['parent_id']; // 부모 댓글 ID 확인

    if (parentId != null) {
      Comment? parent = parentComments[parentId]; // 부모 댓글 찾기
      if (parent != null) {
        parent.replies?.add(comment); // 부모 댓글에 대댓글 추가
      } else {
        Comment newParent = Comment(
          commentId: parentId,
          commentContent: '',
          authorName: '',
          replies: [comment],
        );
        parentComments[parentId] = newParent; // 새로운 부모 댓글 생성
      }
    } else {
      comments.add(comment); // 최상위 댓글이면 댓글 리스트에 추가
    }
  }
  return comments; // 변환된 댓글 리스트 반환
}

// 댓글을 표시하는 위젯
class CommentWidget extends StatelessWidget {
  final Comment comment; // 댓글 데이터
  final void Function(Comment) handleCommentTap; // 댓글 탭 이벤트 핸들러

  CommentWidget({
    required this.comment,
    required this.handleCommentTap,
  });

  @override
  Widget build(BuildContext context) {
    // 댓글
    // InkWell : 회색 이벤트
    return InkWell(
      onTap: () {
        handleCommentTap(comment); // 댓글 탭 시 이벤트 핸들러 호출
      },
      child: Container(
        color: Colors.transparent,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 8.0, top: 8, bottom: 4),
              child: Row(
                children: [
                  Icon(Icons.account_box, color: Colors.grey), // 아이콘 표시
                  Text(' ${comment.authorName}', // 댓글 작성자 표시
                      style: TextStyle(fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 12, bottom: 5),
              child: Text('${comment.commentContent}'), // 댓글 내용 표시
            ),
            if (comment.replies.isNotEmpty) // 대댓글이 있을 경우
              ...comment.replies
                  .map((reply) => _buildReplyWidget(reply)) // 대댓글 위젯 생성
                  .toList(),
          ],
        ),
      ),
    );
  }

  // 대댓글
  Widget _buildReplyWidget(Comment reply) {
    return Container(
      color: Colors.transparent,
      child: Row(
        children: [
          Icon(
            Icons.subdirectory_arrow_right_rounded,
            color: Colors.grey,
          ),
          Expanded(
            child: Card(
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.account_box, color: Colors.grey),
                        SizedBox(width: 5),
                        Text('${reply.authorName}',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Text('${reply.commentContent}'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
