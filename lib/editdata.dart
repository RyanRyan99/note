import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:note/sign_in.dart';

class EditTask extends StatefulWidget {
  EditTask({this.title,this.datetime,this.note,this.index});
  final String title;
  final String note;
  final DateTime datetime;
  final index;

  @override
  _EditTaskState createState() => _EditTaskState();
}

class _EditTaskState extends State<EditTask>{

  TextEditingController controllerTitle;
  TextEditingController controllernote;

  DateTime _dateTime;
  String _dateText = '';

  String newTask;
  String note;


  void _editTask(){
    Firestore.instance.runTransaction((Transaction transaction)async{
      DocumentSnapshot snapshot = await transaction.get(widget.index);
      await transaction.update(snapshot.reference, {
        "title" : newTask,
        "note" : note,
        "datetime" : _dateTime
      });
    });
    Navigator.pop(context);
  }

  Future<Null> _selectDateTime(BuildContext context) async{
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


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _dateTime = widget.datetime;
    _dateText = "${_dateTime.day}/${_dateTime.month}/${_dateTime.year}";
    newTask = widget.title;
    note = widget.note;

    controllerTitle = new TextEditingController(text: widget.title);
    controllernote = new TextEditingController(text: widget.note);
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Column(
        children: <Widget>[
          Container(
            height: 170.0,
            width: double.infinity,
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("assets/back4.jpg"),fit: BoxFit.cover
                ),
                color: Colors.blueAccent
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text("Edit My Notes",style: new TextStyle(
                    color: Colors.white,
                    fontSize: 30.0,
                    letterSpacing: 2.0,
                    fontFamily: "Caveat",
                    decoration: TextDecoration.underline,
                    decorationStyle: TextDecorationStyle.double
                ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              controller: controllerTitle,
              onChanged: (String str){
                setState(() {
                  newTask=str;
                });
              },
              decoration: new InputDecoration(
                  icon: Icon(Icons.dashboard,color: Colors.deepOrangeAccent),
                  hintText: "New Note",
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
                  child: new Icon(Icons.date_range,color: Colors.deepOrangeAccent),
                ),
                new Expanded(child: Text("Tanggal", style: new TextStyle(fontSize: 19.0,color: Colors.black54),)),
                new FlatButton(
                    onPressed: ()=>_selectDateTime(context),
                    child: Text(_dateText, style: new TextStyle(fontSize: 19.0,color: Colors.black54),)),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              controller: controllernote,
              onChanged: (String str){
                setState(() {
                  note=str;
                });
              },
              decoration: new InputDecoration(
                  icon: Icon(Icons.note,color: Colors.deepOrangeAccent,),
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
                  icon: Icon(Icons.check,size: 40.0,color: Colors.deepOrangeAccent,),
                  onPressed: (){
                    _editTask();
                  },
                ),
                IconButton(
                  icon: Icon(Icons.close,size: 40.0,color: Colors.deepOrangeAccent,),
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
