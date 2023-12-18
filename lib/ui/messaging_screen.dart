
import 'package:auto_scroll/auto_scroll.dart';
import 'package:chatting_app/firebase_services/user-info.dart';
import 'package:chatting_app/utilitis/display_size.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
class MessagingScreen extends StatefulWidget {
  var messageList;
  var userID,docID,name;
   MessagingScreen({super.key, required this.messageList , required this.userID, required  this.docID,required this.name });
  @override
  State<MessagingScreen> createState() => _MessagingScreenState();
}
class _MessagingScreenState extends State<MessagingScreen> {
  // final collectionPath = 'message';
  bool itsMe = false;
  final _message = TextEditingController();
@override
  void initState() {

  // TODO: implement initState
    super.initState();
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _message.dispose();
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue,
          title: Text(widget.name, style: const TextStyle(color: Colors.white),),

        ),
        body: StreamBuilder(
            stream:
            widget.messageList.orderBy('time', descending: false).snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (!snapshot.hasData) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              return AutoScroller(
                lengthIdentifier: snapshot.data!.docs.length,
                builder: (BuildContext context, ScrollController scrollController) {
                  return ListView(
                    controller: scrollController,
                  children: snapshot.data!.docs.map((document) =>
                
                      Container(
                        alignment:
                        currentUser() == document['userID'] ? Alignment.centerRight : Alignment.centerLeft,
                        margin: const EdgeInsets.all(6),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                  color: currentUser() == document['userID'] ? Colors.blueAccent:Colors.grey ,
                                  borderRadius: BorderRadius.circular(15)),
                              // width: displayWidth(context)*0.60,
                              child: Text(
                                document['message'],
                                textAlign: TextAlign.start,
                                style: TextStyle(color: Colors.white, fontSize: 14),
                              ),
                            ),
                          ],
                        ),
                      )
                  ).toList(),
                );}
              );
            }),
        bottomSheet: Container(
          color: Colors.white,
          height: 60,
          width: displayWidth(context),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                margin: EdgeInsets.only(
                    right:5
    ),
                width: displayWidth(context) *0.77,
                child: TextFormField(
                  controller: _message,
                  validator: (value) {
                    if (value == "") {
                      return "Input your Message";
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    isDense: true,
                    contentPadding: EdgeInsets.all(10),
                    hintText: "Type your message here",
                    hintStyle: TextStyle(
                        height: 1, fontSize: 12, fontWeight: FontWeight.bold),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        borderSide: BorderSide(width: 1, color: Colors.orange)),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        borderSide: BorderSide(width: 1, color: Colors.grey)),
                    errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        borderSide:
                        BorderSide(width: 1, color: Colors.redAccent)),
                    focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        borderSide:
                        BorderSide(width: 1, color: Colors.redAccent)),
                  ),
                ),
              ),
              Container(
                // margin: EdgeInsets.only(right: 10),
                // width: displayWidth(context)*0.10,
                child: IconButton(
                    onPressed: () async{
                      // UserInfo.getCurrentUserName();
                      print(await UserInfo.getCurrentUserName());
                      // _message.text = await UserInfo.getCurrentUserName();
                      // setState(() {
                      //
                      // });


                      if (_message.text.isNotEmpty) {
                        print(_message.text);
                        UserInfo.setSendMessage(widget.userID,widget.docID).add({
                          'userID':  currentUser(),
                          'message': _message.text,
                          'time': FieldValue.serverTimestamp()
                        });
                    await    FirebaseFirestore.instance.collection('userinfo').doc(widget.userID).collection('messages').doc(widget.docID).set({
                          'name':await UserInfo.getCurrentUserName(),
                          'userID': currentUser(),
                          'time': FieldValue.serverTimestamp()
                        }).then((value) {
                          print(" success");
                        }).catchError((onError){
                          print(onError);
                        });
                        widget.messageList.add({
                          'userID': currentUser(),
                          'message': _message.text,
                          'time': FieldValue.serverTimestamp()
                        }).then((value) {
                          print(" success add");
                        }).catchError((onError){
                          print(' add ${onError}');
                        });
                        _message.clear();
                      }
                    },
                    icon:  Icon(Icons.send,size:25,)),
              )
            ],
          ),
        ) // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
