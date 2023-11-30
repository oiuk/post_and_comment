import 'package:flutter/material.dart';
import 'package:post_and_comment/screen/Post_Detail_Screen.dart';

class PostScreen extends StatefulWidget {
  const PostScreen({super.key});

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
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
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.create, color: Colors.white),
              onPressed: () {},
            )
          ],
        ),
        body: ListView.builder(
          itemCount: JsonData.length,
          itemBuilder: (context, index) {
            final postData = JsonData[index];
            return Card(
              margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              elevation: 3,
              child: ListTile(
                contentPadding: EdgeInsets.all(16),
                title: Text(
                  postData['post_title'],
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                subtitle: Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    postData['post_content'],
                    style: TextStyle(
                      fontSize: 14,
                    ),
                  ),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          PostDetailScreen(postData: postData),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
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
}
