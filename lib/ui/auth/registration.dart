import 'package:chatting_app/ui/auth/login.dart';
import 'package:chatting_app/utilitis/toast_message.dart';
import 'package:chatting_app/widgets/rounded_btton.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';

class Registration extends StatefulWidget {
  const Registration({super.key});

  @override
  State<Registration> createState() => _RegistrationState();
}

class _RegistrationState extends State<Registration> {
  bool passwordVisible = false;
  var _PassController = TextEditingController();
  bool isLoading=false;
  var _name = TextEditingController();
  var _email = TextEditingController();
  var _phone = TextEditingController();

  String emailRegex = r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';

  final _registrationkey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text("Registration"),
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Form(
              key: _registrationkey,
              child: Column(
                children: [
                  // ----------------------------------Name button---------------------------
                  TextFormField(
                    controller: _name,
                    validator: (value){
                      if(value==""){
                        return "Input your Name";
                      }
                      return null;
                    },
                    keyboardType: TextInputType.name,

                    decoration: InputDecoration(
                      isDense: true,
                      contentPadding: EdgeInsets.all(10),
                      labelText: "Name",
                      hintText: "Your Name",
                      labelStyle:
                      TextStyle(height: 1,fontSize: 14, fontWeight: FontWeight.bold),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          borderSide: BorderSide(width: 1, color: Colors.orange)),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          borderSide: BorderSide(width: 1, color: Colors.grey)),
                      errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          borderSide: BorderSide(width: 1, color: Colors.redAccent)),
                      focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          borderSide: BorderSide(width: 1, color: Colors.redAccent)),
                    ),
                  ),
                  // ----------------------------------Email button---------------------------
                  SizedBox(height: 20,),
                  TextFormField(
                    controller: _email,
                    validator: (value){
                      if(!RegExp(emailRegex).hasMatch(value!)){
                        return "Input Valid Email!";
                      }
                      return null;
                    },
                    keyboardType: TextInputType.emailAddress,
                    enableSuggestions: true,
                    decoration: InputDecoration(
                      isDense: true,
                      contentPadding: EdgeInsets.all(10),
                      labelText: "Email",
                      hintText: "example@gmail.com",
                      labelStyle:
                      TextStyle(height: 1,fontSize: 14, fontWeight: FontWeight.bold),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          borderSide: BorderSide(width: 1, color: Colors.orange)),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          borderSide: BorderSide(width: 1, color: Colors.grey)),
                      errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          borderSide: BorderSide(width: 1, color: Colors.redAccent)),
                      focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          borderSide: BorderSide(width: 1, color: Colors.redAccent)),
                    ),
                  ),
                  // ----------------------------------Phone button---------------------------
                  SizedBox(height: 20,),
                  TextFormField(
                    controller: _phone,
                    validator: (value){
                      if(value.toString().length!=11){
                        return "Input Correct Number";
                      }
                      return null;
                    },
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(

                      isDense: true,
                      contentPadding: EdgeInsets.all(10),
                      labelText: "Phone",
                      hintText: "017xxxxxxx",
                      labelStyle:
                      TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          borderSide: BorderSide(width: 1, color: Colors.orange)),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          borderSide: BorderSide(width: 1, color: Colors.grey)),
                      errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          borderSide: BorderSide(width: 1, color: Colors.redAccent)),
                      focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          borderSide: BorderSide(width: 1, color: Colors.redAccent)),
                    ),
                  ),
                  // ----------------------------------password button---------------------------
                  SizedBox(height: 20,),
                  TextFormField(
                    validator: (value){
                      if(value == ""){
                        return " Please enter password";
                      }
                      return null;
                    },
                    controller: _PassController,
                    obscureText: passwordVisible,
                    style: TextStyle(height: 1,fontSize: 12),
                    decoration: InputDecoration(
                      isDense: true,
                      contentPadding: EdgeInsets.all(10),
                      errorStyle: TextStyle(color: Colors.red,fontSize: 12),
                      labelText: "Password",
                      // prefixIcon: Icon(Icons.lock,size: 20,),
                      labelStyle: TextStyle(height: 1,fontSize: 14, fontWeight: FontWeight.bold),

                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          borderSide: BorderSide(width: 1, color: Colors.orange)),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          borderSide: BorderSide(width: 1, color: Colors.grey)),
                      errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          borderSide: BorderSide(width: 1, color: Colors.redAccent)),
                      focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          borderSide: BorderSide(width: 1, color: Colors.redAccent)),
                      suffixIcon: IconButton(
                        icon: Icon(passwordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,size: 14,),
                        onPressed: () {
                          setState(
                                () {
                              passwordVisible = !passwordVisible;
                            },
                          );
                        },
                      ),
                      alignLabelWithHint: false,
                      // filled: true,
                    ),
                    keyboardType: TextInputType.visiblePassword,
                    textInputAction: TextInputAction.done,
                  ),
                  SizedBox(height: 20,),
                  // submit button
                  RoundedButton(title: "Sing up",
                      onTap:singUp,
                  loading: isLoading
                  ),
                  Container(
                    padding: EdgeInsets.only(top: 15,bottom: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Has Account? please",style: TextStyle(fontSize: 16),),
                        TextButton(
                            onPressed: () => Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>Login()), (route) => false),
                            style: TextButton.styleFrom(
                              foregroundColor: Colors.deepPurple, ),
                            child: Text(
                              "login",
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold,height: 2,decoration: TextDecoration.underline),
                              textAlign: TextAlign.center,
                            )),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
  addUserData(String uid){
    var _firebase =  FirebaseFirestore.instance;
    _firebase.collection('userinfo').doc(uid).set({
      'id':uid,
      'name': _name.text,
      'email':_email.text,
      'phone':_phone.text,

    });
  }
  singUp(){
    FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }
    isLoading = true;
    setState(() {
    });
    FirebaseAuth auth = FirebaseAuth.instance;
    auth.createUserWithEmailAndPassword(email: _email.text, password: _PassController.text).then((value) {
      isLoading=false;
      print(value.user!.uid);
      addUserData(value.user!.uid);
      toastMessage('Sing up success');
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder:(context)=>Login() ), (route) => false);
      setState(() {

      });

    }).catchError((error){
      isLoading = false;
      toastMessage(error.toString());

      setState(() {

      });
    }

    );
  }
  // buttonWidget(){
  //   setState(() {
  //   });
  //   if(isProcessing){
  //     return Padding(
  //       padding: const EdgeInsets.only(top: 15,bottom: 15),
  //       child: const Center(child: CircularProgressIndicator()),
  //     );
  //   }else{
  //     return  Container(
  //       padding: EdgeInsets.only(top: 15,bottom: 15),
  //       child: RoundedButton(title: title, onTap: onTap),
  //           child: SizedBox(
  //             width: MediaQuery.sizeOf(context).width*0.7,
  //             height: 50,
  //             child: Text(
  //               "Sing Up",
  //               style: TextStyle(
  //                   fontSize: 18, fontWeight: FontWeight.bold,height: 2.7),
  //               textAlign: TextAlign.center,
  //             ),
  //           )),
  //     );
  //   }
  // }
}
