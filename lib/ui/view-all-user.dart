import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../firebase_services/user-info.dart';

class ViewUser extends StatefulWidget {
  const ViewUser({super.key});

  @override
  State<ViewUser> createState() => _ViewUserState();
}

class _ViewUserState extends State<ViewUser> {
  var fireStore = FirebaseFirestore.instance.collection('userinfo').snapshots();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("view user"),
      ),
      body: StreamBuilder(
          stream: fireStore,
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            return ListView(
              children: snapshot.data!.docs.map((document) {
                return Container(
                  margin: EdgeInsets.all(6),
                  child:document.id == currentUser()?null: OutlinedButton(
                      onPressed: () {
                       FirebaseFirestore.instance.collection('userinfo').doc(currentUser()).collection('messages').add({
                          'name': document['name'],
                          'userID': document['id'],
                          'time': FieldValue.serverTimestamp()
                        });
                        // UserInfo().getUserInfo();
                         //   {
                          // 'name': document['name'],
                          // 'userID': document['id'],
                          // 'time': FieldValue.serverTimestamp()
                        //}
                        // );
                      },
                      child: Text("${document['name']} ")),
                );
              }).toList(),
            );
          }),
    );
  }
}
