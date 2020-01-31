import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:note/sign_in.dart';

class AddTask extends StatefulWidget {
  AddTask({this.email});
  final String email;
  @override
  _AddTaskState createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> {

  DateTime _dateTime =  new DateTime.now();
  String _dateText = '';

  String newTask = '';
  String note = '';

  Future<Null> selectDateTime(BuildContext context) async{
    final picked = await showDatePicker(
        context: context,
        initialDate: _dateTime,
        firstDate: DateTime(2012),
        lastDate: DateTime(2080)
    );

    if(picked != null){
      setState(() {
        _dateTime = picked;
        _dateText = "${picked.day}/${picked.month}/${picked.year}";
      });
    }
  }

  void _addData(){
    Firestore.instance.runTransaction((Transaction transsaction)async{
      CollectionReference reference = Firestore.instance.collection('Note');
      await reference.add({
        "email" : widget.email,
        "title" : newTask,
        "datetime" : _dateTime,
        "note" : note,
      });
    });
    Navigator.pop(context);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _dateText = "${_dateTime.day}/${_dateTime.month}/${_dateTime.year}";
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Column(
        children: <Widget>[
          Container(
            height: 180.0,
            width: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/back3.jpg"),fit: BoxFit.cover
              ),
              color: Colors.blueAccent
            ),
            child: Padding(
              padding: const EdgeInsets.only(top: 75.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                Text("My Notes",style: new TextStyle(
                  color: Colors.white,
                  fontSize: 30.0,
                  letterSpacing: 2.0,
                  fontFamily: "Nunito",
                  decoration: TextDecoration.underline,
                  decorationStyle: TextDecorationStyle.dotted
                ),
                ),
              ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              onChanged: (String str){
                setState(() {
                  newTask=str;
                });
              },
              decoration: new InputDecoration(
                icon: Icon(Icons.dashboard, color: Colors.orange),
                hintText: "Note Baru",
                border: InputBorder.none
              ),
              style: new TextStyle(fontSize: 19.0,color: Colors.black38),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(right: 16.0),
                  child: new Icon(Icons.date_range,color: Colors.orange,),
                ),
                new Expanded(child: Text("Tanggal", style: new TextStyle(fontSize: 19.0,color: Colors.black54),)),
                new FlatButton(
                    onPressed: ()=>selectDateTime(context),
                    child: Text(_dateText, style: new TextStyle(fontSize: 19.0,color: Colors.black54),)),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              onChanged: (String str){
                setState(() {
                  note=str;
                });
              },
              decoration: new InputDecoration(
                  icon: Icon(Icons.note,color: Colors.orange,),
                  hintText: "Note",
                  border: InputBorder.none
              ),
              style: new TextStyle(fontSize: 19.0,color: Colors.black38),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 100.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.check,size: 40.0,color: Colors.orange,),
                  onPressed: (){
                    _addData();
                  },
                ),
                IconButton(
                  icon: Icon(Icons.close,size: 40.0,color: Colors.orange,),
                  onPressed: (){
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
