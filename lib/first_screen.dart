import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:note/editdata.dart';
import 'package:note/login_page.dart';
import 'package:note/sign_in.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'AddTask.dart';



class FirstScreen extends StatefulWidget {
  FirstScreen({this.user,this.googleSignIn});
  final FirebaseUser user;
  final GoogleSignIn googleSignIn;
  @override
  _FirstScreenState createState() => new _FirstScreenState();
}

class _FirstScreenState extends State<FirstScreen> {

  void _signOut(){
    AlertDialog alertDialog = new AlertDialog(
      content: Container(
        height: 250.0,
        child: new Column(
          children: <Widget>[
            ClipOval(
              child: new Image.network(imageUrl),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text("Apakah Anda Yakin ?",style: new TextStyle(fontSize: 16.0),),
            ),
            new Divider(),
            new Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                InkWell(
                  onTap: (){
//                    widget.googleSignIn.signOut();
//                    Navigator.of(context).push(
//                        new MaterialPageRoute(builder: (BuildContext context) => new LoginPage())
//                    );
                    signOutGoogle();
                    Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(
                        builder: (context) {return LoginPage();}), ModalRoute.withName('/'));
                  },
                  child: Column(
                  children: <Widget>[
                    Icon(Icons.check),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                    ),
                    Text("Yes")
                  ],
                ),
                ),
                InkWell(
                  onTap: (){
                    Navigator.pop(context);
                  },
                  child: Column(
                    children: <Widget>[
                      Icon(Icons.close),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                      ),
                      Text("Batal")
                    ],
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
    showDialog(context: context,child: alertDialog);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: new FloatingActionButton(
        onPressed: (){
          Navigator.of(context).push(new MaterialPageRoute(
              builder: (BuildContext context) => new AddTask(email:email))
          );
        },
          child: Icon(Icons.assignment),
        backgroundColor: Colors.teal,
      ),
      body: new Stack(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 160.0),
            child: StreamBuilder(
              stream: Firestore.instance
                  .collection("Note")
                  .where("email",isEqualTo: email)
                  .snapshots(),
              builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
               if(!snapshot.hasData)
                 return new Container(child: Center(
                   child: CircularProgressIndicator(),
                 ),);
               return new TaskList(document: snapshot.data.documents,);
              },
            ),
          ),
          
          Container(
          height: 170.0,
          width: double.infinity,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: new AssetImage("assets/back2.jpg"),fit: BoxFit.cover),
            boxShadow: [
              new BoxShadow(
                color: Colors.black,
                blurRadius: 10,
              )
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: <Widget>[
                    Container(
                      width: 50.0, height: 50.0,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          image: new NetworkImage(imageUrl),fit: BoxFit.cover
                        )
                      ),
                    ),
                    new Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 16.0),
                        child: new Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            new Text("Selamat Datang", style: new TextStyle(fontSize: 18.0, color: Colors.white, fontFamily: "Nunito"),),
                            new Text(name, style: new TextStyle(fontSize: 18.0, color: Colors.white, fontFamily: "Nunito"),),
                          ],
                        ),
                      ),
                    ),
                    new IconButton(
                        icon: Icon(Icons.exit_to_app,color: Colors.white, size: 40.0,),
                        onPressed:(){
                          _signOut();
                        }
                    )
                  ],
                ),
              ),
              new Text("My Task", style: new TextStyle(
                fontSize: 30.0,
                color: Colors.white,
                letterSpacing: 2.0,
                fontFamily: "Caveat",
                decoration: TextDecoration.underline,
                decorationStyle: TextDecorationStyle.double
              ),)
            ],
          ),
        ),
      ],
      ),
    );
  }
}

class TaskList extends StatelessWidget {
  TaskList({this.document});
  final List<DocumentSnapshot> document;
  @override
  Widget build(BuildContext context) {
    return new ListView.builder(
      itemCount: document.length,
      itemBuilder: (BuildContext context, int i){
        String title = document[i].data['title'].toString();
        String note = document[i].data['note'].toString();
        DateTime time = document[i].data['datetime'].toDate();
        String datetime = "${time.day}/${time.month}/${time.year}";


        return Dismissible(
          key: new Key(document[i].documentID),
          onDismissed: (direction){
            Firestore.instance.runTransaction((transaction)async{
               DocumentSnapshot snapshot = await transaction.get(document[i].reference);
               await transaction.delete(snapshot.reference);
            });
            Scaffold.of(context).showSnackBar(
              new  SnackBar(content: new Text("Data Berhasil Dihapus"))
            );
          },
          child: Card(
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.only(left: 16.0, top: 8.0, right: 16.0,bottom: 8.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  new Expanded(
                    child: Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(bottom: 8.0),
                              child: Text(title, style: new TextStyle(
                                  fontSize: 24.0,
                                  letterSpacing: 1.0,
                                  fontFamily: "Nunito"
                              ),),
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.only(right: 16.0),
                                  child: Icon(Icons.note, color: Colors.teal,),
                                ),
                                Text(note.toString(),style: new TextStyle(fontSize: 14.0, fontFamily: "Nunito"),),
                              ],
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.only(right: 16.0),
                                  child: Icon(Icons.date_range, color: Colors.teal,),
                                ),
                                new Expanded(child: Text(datetime, style: new TextStyle(fontSize: 14.0,fontFamily: "Nunito"),)),
                              ],
                            ),
                          ],
                        ),
                    ),
                  ),
                  new IconButton(icon: Icon(Icons.mode_edit,color: Colors.teal,),
                      onPressed: (){
                        Navigator.of(context).push(new MaterialPageRoute(
                            builder: (BuildContext context) => new EditTask(
                              title: title,
                              note: note,
                              datetime: document[i].data['datetime'].toDate(),
                              index: document[i].reference,
                            ))
                        );
                      }
                  )
                ],
              ),
            ),
          ),
        );
        },

    );
  }
}


