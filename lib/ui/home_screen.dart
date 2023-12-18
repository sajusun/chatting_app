import 'package:chatting_app/ui/messaging_screen.dart';
import 'package:chatting_app/ui/view-all-user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'auth/login.dart';
import 'package:chatting_app/firebase_services/user-info.dart' as userInfo;

class HomeScreen extends StatefulWidget {
  String id;
  HomeScreen({super.key, required this.id});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  FirebaseAuth auth = FirebaseAuth.instance;
  bool isHas = false;
  var _userid;
  var senderName;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text("Chat"),
        actions: [
          IconButton(
                onPressed: ()  =>Navigator.push(context, MaterialPageRoute(builder: (context)=>ViewUser())),
              icon: Icon(
                Icons.add,
                color: Colors.black,
              )),
          IconButton(
              onPressed: () {
                auth.signOut();
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => Login()),
                    (route) => false);
              },
              icon: Icon(
                Icons.logout,
                color: Colors.black,
              ))
        ],
      ),
      body:
          //   isHas? Center(child: CircularProgressIndicator(),):
          StreamBuilder(
              stream: userInfo.UserInfo().getUserInfo(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                return ListView(
                  children: snapshot.data!.docs.map((document) {
                    return Container(
                      margin: EdgeInsets.all(6),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          OutlinedButton(
                              onPressed: () {
                                print(""" currentUser :${auth.currentUser!.uid},
                              userID :${document['userID']}""");
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => MessagingScreen(
                                            messageList: userInfo.UserInfo
                                                .getUserMessageList(
                                                    widget.id, document.id),
                                            docID: document.id,
                                            userID: document['userID'],
                                          name: document['name'],
                                        )));
                              },
                              child: Text("${document['name']} "))
                        ],
                      ),
                    );
                  }).toList(),
                );
              }),
    );
  }
}
