import 'package:flutter/material.dart';
import 'package:notepadapp/shared/loading.dart';
//import 'dart:async';
import 'package:notepadapp/models/note.dart';
import 'package:notepadapp/utils/database_helper.dart';
import 'package:intl/intl.dart';
class NoteDetail extends StatefulWidget{
    final  String appBarTitle;
    final Note note;
    NoteDetail(this.note, this.appBarTitle);
     @override 
  State<StatefulWidget> createState() {
    return NoteDetailState(this.note, this.appBarTitle);
  }
}
class NoteDetailState extends State<NoteDetail>{
    static var _priorities=['High', 'Low'];
    DatabaseHelper helper=DatabaseHelper();
    String appBarTitle;
    Note note;
    TextEditingController titleController=TextEditingController();
    TextEditingController  descriptionController=TextEditingController();
    NoteDetailState(this.note, this.appBarTitle);
    @override 
  Widget build(BuildContext context) {
    TextStyle textStyle=Theme.of(context).textTheme.title;
    titleController.text=note.title;
    descriptionController.text=note.description;
    return WillPopScope(
      onWillPop:(){
        moveToLastScreen();
      },
    
    child: Scaffold(
      appBar:AppBar(
        title: Text(appBarTitle),
        leading: IconButton(icon: Icon(Icons.arrow_back),
        onPressed: (){
          moveToLastScreen();
          Loading();
        }
        ),
      ),
      body: Padding(
        padding: EdgeInsets.only(top:15.0,left:10.0,right:10.0),
        child: ListView(
          children:<Widget>[
            ListTile(
              title:DropdownButton(
                items:_priorities.map((String dropDownStringItem){
                  return DropdownMenuItem<String>(
                    value:dropDownStringItem,
                    child:Text(dropDownStringItem),
                  );
                }
              ).toList(),
              style: textStyle,
              value:getPriorityAsString(note.priority),
              onChanged:(valueSelectedByUser){
                setState((){
                  debugPrint('User selected $valueSelectedByUser');
                  updatePriorityAsInt(valueSelectedByUser);
                });
              }
             ),
            ),
            Padding(
              padding:EdgeInsets.only(top:15.0,bottom:15.0),
              child: TextField(
                controller:titleController,
                style: textStyle,
                onChanged: (value){
                  debugPrint('Something changes in the textfield');
                  updateTitle();
                },
                decoration:InputDecoration(
                  labelText: 'Title',
                  labelStyle: textStyle,
                  border: OutlineInputBorder(
                    borderRadius:BorderRadius.circular(5.0)
                  )
                ),
              ), 
            ),
           Padding(
              padding:EdgeInsets.only(top:15.0,bottom:15.0),
              child: TextField(
                controller:descriptionController,
                style: textStyle,
                onChanged: (value){
                  debugPrint('Something changes in the Description');
                  updateDescription();
                },
                decoration:InputDecoration(
                  labelText: 'Description',
                  labelStyle: textStyle,
                  border: OutlineInputBorder(
                    borderRadius:BorderRadius.circular(5.0)
                  )
                ),
              ), 
            ),
          Padding(
          padding: EdgeInsets.only(top:15.0,bottom: 15.0),
          child: Row(
            children:<Widget>[ 
              Expanded(
                child:RaisedButton(
                    color: Theme.of(context).primaryColorDark,
                    textColor:Theme.of(context).primaryColorLight,
                    child: Text(
                      'Save',
                      textScaleFactor: 1.5,),
                    onPressed:(){
                      setState((){
                        debugPrint('Saved Button CLicked');
                        _save();
                      });
                    },
                ),
                ),
                Container(width: 5.0),
                Expanded(
                child:RaisedButton(
                    color: Theme.of(context).primaryColorDark,
                    textColor:Theme.of(context).primaryColorLight,
                    child: Text(
                      'Delete',
                      textScaleFactor: 1.5,),
                    onPressed:(){
                      setState((){
                        debugPrint('Delete Button CLicked');
                        _delete();
                      }
                      );
                    },
                ),
               ),
            ]
          ),
        ),
          ]
      )

    )));
    }
    void moveToLastScreen(){
      Navigator.pop(context);
    }
    void updatePriorityAsInt(String value){
      switch(value){
        case 'High':
            note.priority=1;
        break;
         case 'Low':
            note.priority=2;
        break;
      }
    }
    String getPriorityAsString (int value){
      String priority;
      switch(value){
        case 1:
              priority=_priorities[0];
              break;
        case 2:
              priority=_priorities[1];
              break;
      }
      return priority;
    }
    void updateTitle(){
      note.title=titleController.text;
    }
    void updateDescription(){
      note.description=descriptionController.text;
    }
    void _save() async{
      Loading();
      moveToLastScreen();
      note.date=DateFormat.yMMMd().format(DateTime.now());
      int result;
      if(note.id!=null){
        result= await helper.updateNote(note);
      }else{
        result= await helper.insertNote(note);
      }
      if(result!=0){
        _showAlertDialog('Status', 'Saved Successfully');
      }else{
          _showAlertDialog('Status', 'Not Saved Successfully');
      }
      
    } 
     void _delete() async {
      moveToLastScreen(); 
      if(note.id==null){
        _showAlertDialog('Status', 'No note was deleted');
        return;
      }
      int result=await helper.deleteNote(note.id);
      if(result!=0){
        _showAlertDialog('Status', 'Note Dleted Successfully');
      }else{
        _showAlertDialog('Status', 'Error while deleting note');
      }
     }
     void _showAlertDialog(String title, String message){
       AlertDialog alertDialog=AlertDialog(
         title:Text(title),
         content:Text(message),
       );
       showDialog(
            context:context,
            builder:(_)=>alertDialog,
       );
     }
  }
