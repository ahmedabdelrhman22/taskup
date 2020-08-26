
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import 'Comment.dart';
import 'Post.dart';
class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}
class _HomeState extends State<Home> {
  @override
  File sampleImage;
  final formkey = new GlobalKey<FormState>(
  );
  final formkey2 = new GlobalKey<FormState>(
  );
  List<Post>postList = [];
  List<Comment>CommentList = [];
  List<String>Keys = [];
  TextEditingController _myvalue = TextEditingController(
  );
  String post;
  String Key;
  String like='false';
  TextEditingController _comment = TextEditingController(
  );
  String url;
  List<String> uids=[];
  void initState () {
    DatabaseReference postref = FirebaseDatabase.instance.reference(
    ).child(
        "Posts"
        );
    postref.once(
    ).then(
            (DataSnapshot snap) {
          // ignore: non_constant_identifier_names
          var KEYS = snap.value.keys;
          for(var i in KEYS)
          {
            Keys.add(i);
          }
          var DATA = snap.value;
//          postList.clear(
//          );
          for (var individualKey in KEYS) {
            Post posts = Post
              (
              DATA[individualKey]['image'],
              DATA[individualKey]['description'],
              DATA[individualKey]['date'],
              DATA[individualKey]['time'],
              DATA[individualKey]['id'],
              );
            setState(
                    () {
                  postList.add(
                      posts
                      );
                }
                    );
          }
        }
            );
    setState(
            () {
          print(
              'length: $postList.length'
              );
        }
            );
    DatabaseReference commentref = FirebaseDatabase.instance.reference(
    ).child(
        "Comments"
        );
    commentref.once(
    ).then(
            (DataSnapshot snap) {
          // ignore: non_constant_identifier_names
          var CommentKEYS = snap.value.keys;
          var CommentDATA = snap.value;
//          postList.clear(
//          );
          for (var individualKey in CommentKEYS) {
            Comment Comments = Comment
              (
              CommentDATA[individualKey]['comment'],
              CommentDATA[individualKey]['comment_date'],
              CommentDATA[individualKey]['comment_time'],
              CommentDATA[individualKey]['id'],
              );
            setState(
                    () {
                  CommentList.add(
                      Comments
                      );
                }
                    );
          }
        }
            );
    setState(
            () {
          print(
              'length: $CommentList.length'
              );
        }
            );

    super.initState(
    );
  }
  Future getImage () async
  {
    var tempImage = await ImagePicker.pickImage(
        source: ImageSource.gallery
        );
    setState(
            () {
          sampleImage = tempImage;
        }
            );
    super.initState(
    );
  }
  bool validateAndSave () {
    final form = formkey.currentState;
    if (form.validate(
    )) {
      form.save(
      );
      return true;
    }
  }
  Widget build (BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue[900],
          title: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              RaisedButton(
                elevation: 10.0,
                child: Text(
                  'Post', style: TextStyle(
                    color: Colors.white, fontSize: 25.0
                    ),
                  ),
                color: Colors.blue[900],
                onPressed: uploadStatusImage,
                ),
            ],
            ),
          ),
        body: ListView(
          physics: BouncingScrollPhysics(
          ),
          children: <Widget>[
            Form(
              child: Form(
                key: formkey,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(
                            14.0, 8.0, 14.0, 8.0
                            ),
                        child: Material(
                          borderRadius: BorderRadius.circular(
                              10.0
                              ),
                          color: Colors.grey.withOpacity(
                              0.1
                              ),
                          elevation: 0.0,
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: 12.0
                                ),
                            child: TextFormField(
                              controller: _myvalue,
                              maxLines: 3,
                              decoration: InputDecoration(
                                hintText: "What's in your mind ?",
                                border: InputBorder.none,
                                //                                          controller: _myvalue,
                                ),
                              validator: (value) {
                                if (value.isEmpty && sampleImage == null) {
                                  return "The post can not be empty";
                                }
                                else if (value.isEmpty && sampleImage != null) {
                                  return null;
                                }
                                else
                                if (!value.isEmpty && sampleImage == null) {
                                  return null;
                                }
                              },
                              ),
                            ),
                          ),
                        ),
                      ),
                    IconButton(
                      icon: Icon(
                        Icons.add_a_photo,
                        size: 35,
                        color: Colors.black,
                        ),
                      onPressed: getImage,
                      ),
                  ],
                  ),
                ),
              ),
            Column(
              children: <Widget>[
                sampleImage == null ? Container(
                    height: 80,
                    child: Text(
                      "Select Image", textAlign: TextAlign.center,
                      )
                    ) : enableupload(
                ),
              ],
              ),
            postList.length == 0  ? Container(
              height: 200,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Text(
                        "No available posts"
                        )
                  ]
                  ),
              ) :
            Column(
              children: <Widget>[
                Container(
                  height: 550,
                  child: ListView.builder(
                    physics: BouncingScrollPhysics(
                    ),
                    itemBuilder: (_, index) {
                      return PostUI(
                          postList[index].image, postList[index].description,
                          postList[index].date, postList[index].time,
                          CommentAndLike(index
                                         ),CommentList.length > 3?'':Commentposition(index)


                          );
                    },
                    itemCount: postList.length,
                    ),
                  ),
              ],
              ),
          ],
          ),
        ),
      );
  }
  Widget enableupload () {
    return Column(
      children: <Widget>[
        Stack(
          children: <Widget>[
            Image.file(
              sampleImage,
              ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment:
              MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(
                        20
                        ),
                    ),
                  child: IconButton(
                    icon: Icon(
                      Icons.close,
                      color: Colors.red,
                      size: 20,
                      ),
                    onPressed: () {
                      goToHome(
                      );
                    },
                    ),
                  ),
              ],
              ),
          ],
          ),
      ],
      );
  }
  void uploadStatusImage () async {
    if (validateAndSave(
    )) {
      if (sampleImage != null) {
        final StorageReference postImageRef = FirebaseStorage.instance.ref(
        ).child(
            'Post Image'
            );
        var timekey = DateTime.now(
        );
        final StorageUploadTask uploadTask = postImageRef.child(
            timekey.toString(
            ) + ".jpg"
            ).putFile(
            sampleImage
            );
        var imageurl = await(await uploadTask.onComplete).ref.getDownloadURL(
        );
        url = imageurl.toString(
        );
      }
      url == null ? url = 'null' : url;
      saveToDatabase(
          url
          );
      goToHome(
      );
    }
  }
  Future saveToDatabase (url) async {
    var dbTimeKey = new DateTime.now(
    );
    var formDate = new DateFormat(
        'MMM d,yyy'
        );
    var formTime = new DateFormat(
        'EEE,hh:mm aaa'
        );
    String date = formDate.format(
        dbTimeKey
        );
    String time = formTime.format(
        dbTimeKey
        );
    DatabaseReference ref = FirebaseDatabase.instance.reference(
    );
    post = _myvalue.text;
    post == null ? post = 'null' : post;
    var data =
    {
      "image": url,
      "description": post,
      "date": date,
      "time": time,
      'id':postList.length
    };
    ref.child("Posts").push().set(
        data
        );
  }
  void saveCommentToDatabase (int index) async{
    var dbTimeKey = new DateTime.now(
    );
    var formDate = new DateFormat(
        'MMM d,yyy'
        );
    var formTime = new DateFormat(
        'EEE,hh:mm aaa'
        );
    String comment_date = formDate.format(
        dbTimeKey
        );
    String comment_time = formTime.format(
        dbTimeKey
        );
    _comment.text == null ? _comment.text = 'null' : _comment.text;
    DatabaseReference commentref = FirebaseDatabase.instance.reference();
    var data =
    {
      "key":Key,
      "comment": _comment.text,
      "comment_date": comment_date,
      "comment_time": comment_time,
      'id':index
    };
    commentref.child("Comments").push().set(
        data
        );
  }
  void goToHome () {
    Navigator.push(
        context, MaterialPageRoute(
        builder: (context) {
          return Home(
          );
        }
        )
        );
  }
  Widget PostUI (String image, String description, String date, String time,
      Widget x ,Widget Commentdetails ) {
    return  Expanded(
      child: Card(
        elevation: 10.0,
        margin: EdgeInsets.all(
            15.0
            ),
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    date, style: Theme
                      .of(
                      context
                      )
                      .textTheme
                      .subtitle1,
                    textAlign: TextAlign.center,
                    ),
                  Text(
                    time, style: Theme
                      .of(
                      context
                      )
                      .textTheme
                      .subtitle2,
                    textAlign: TextAlign.center,
                    ),
                ],
                ),
              Text(
                description, style: Theme
                  .of(
                  context
                  )
                  .textTheme
                  .subhead,
                textAlign: TextAlign.center,
                ),
              SizedBox(
                height: 10.0,
                ),
              Image.network(
                image, fit: BoxFit.cover,
                ),
              Commentdetails,
              x,
            ],
            ),
          ),
        ),
      );
  }
  Widget Commentposition(int index)
  {
    return     CommentList.length == 0  ? Container(
      height: 200,
      child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Text(
                "No available Comments"
                )
          ]
          ),
      ) :
    Column(
      children: <Widget>[
        Text(
            "Comments"
            ),
        Container(
          height: 250,
          child: ListView.builder(
            physics: BouncingScrollPhysics(
            ),
            itemBuilder: (_, index) {
              return index==CommentList[index].id? CommentUI(
                CommentList[index].comment,
                CommentList[index].comment_date,
                CommentList[index].comment_time,
                ):Container();
            },
            itemCount: CommentList.length,
            ),
          ),
      ],
      );
  }
  Widget CommentUI(String Comment, String Comment_date, String Camment_time)
  {
    return Expanded(
      child: Card(
        elevation: 10.0,
        margin: EdgeInsets.all(
            15.0
            ),
        child: Container(
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    Comment_date, style: Theme
                      .of(
                      context
                      )
                      .textTheme
                      .subtitle1,
                    textAlign: TextAlign.center,
                    ),
                  Text(
                    Camment_time, style: Theme
                      .of(
                      context
                      )
                      .textTheme
                      .subtitle2,
                    textAlign: TextAlign.center,
                    ),
                ],
                ),
              Text(
                Comment, style: Theme
                  .of(
                  context
                  )
                  .textTheme
                  .subhead,
                textAlign: TextAlign.start,
                ),
            ],
            ),
          ),
        ),
      );
  }
  Widget CommentAndLike (int index) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(
                    20
                    ),
                ),
              child: IconButton(
                icon: Icon(
                  Icons.favorite,
                  color: Colors.red,
                  size: 40,
                  ),
                onPressed: () {
                  goToHome(
                  );
                },
                ),
              ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                    14.0, 8.0, 14.0, 8.0
                    ),
                child: Material(
                  borderRadius: BorderRadius.circular(
                      10.0
                      ),
                  color: Colors.grey.withOpacity(
                      0.1
                      ),
                  elevation: 0.0,
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 12.0
                        ),
                    child: TextFormField(
                      controller: _comment,
//                    maxLines: 2,
                      decoration: InputDecoration(
                        hintText: "Comment ?",
                        border: InputBorder.none,
                        ),
                      validator: (value) {
                        if (value.isEmpty) {
                          return "The post can not be empty";
                        }
                        else {
                          return null;
                        }
                      },
                      ),
                    ),
                  ),
                ),
              ),
          ],
          ),
        RaisedButton(
          elevation: 10.0,
          child: Text(
            'Comment', style: TextStyle(
              color: Colors.white, fontSize: 25.0
              ),
            ),
          color: Colors.blue[900],
          onPressed:()=> Creating_comment(index),
          ),
      ],
      );
  }
  void Creating_comment (int index) async {
    if (_comment != null) {
      saveCommentToDatabase(index);
      goToHome();
    }
    else{
      goToHome();      }
  }
}


