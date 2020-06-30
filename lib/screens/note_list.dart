import 'package:flutter/material.dart';
import 'package:notepadapp/shared/loading.dart';
import 'package:notepadapp/screens/note_detail.dart';
import 'dart:async';
//import 'package:intl/intl.dart';
import 'package:notepadapp/utils/database_helper.dart';
import 'package:notepadapp/models/note.dart';
import 'package:sqflite/sqflite.dart';
class NoteList extends StatefulWidget{
    @override
  State<StatefulWidget> createState(){
    return NoteListState();
  }
}
class NoteListState extends State<NoteList> {
   DatabaseHelper databaseHelper=DatabaseHelper();
   List<Note> noteList;
   int count=0;
    @override 
  Widget build(BuildContext context) {
    if(noteList==null){
      noteList=List<Note>();
      updateListView();
    }
    return Scaffold(
      appBar:AppBar(
        title:Text('Notes'),
        ), 
        body: getNoteListView(), 
        floatingActionButton: FloatingActionButton(
          onPressed:(){
            debugPrint('FAB clicked');
            navigateToDetail(Note('',2,''),'Add note');
          },
          tooltip: 'Add Note',
          child: Icon(Icons.add),
        ),
      );
  }
  ListView getNoteListView(){
  TextStyle titleStyle=Theme.of(context).textTheme.subhead;
  
  return ListView.builder(
    itemCount: count,
    itemBuilder:(BuildContext context, int position){
      return Card(
        color: Colors.blue,
        elevation: 2.0,
        child: ListTile(
          leading:CircleAvatar(
            backgroundColor: getPriorityColor(this.noteList[position].priority),
             child: getPriorityIcon(this.noteList[position].priority),
              ),
              title: Text(this.noteList[position].title, style: titleStyle,),
              subtitle: Text(this.noteList[position].date),
              trailing:GestureDetector(
                    child:Icon(Icons.delete,color: Colors.grey,),
                    onTap:(){
                      _delete(context,noteList[position]);
                    },
              ),
              onTap: (){
                Loading();
                debugPrint('ListTile clicked');
                navigateToDetail(this.noteList[position],'Edit Note');
              },
            ),
      );
    } 
  );
  }
  
  Color getPriorityColor(int priority){
    switch(priority){
      case 1: 
          return Colors.red;
          break;
      case 1: 
          return Colors.yellow;
          break;
        default:
              return Colors.yellow;
    }
  }
  Icon getPriorityIcon (int priority){
    switch(priority){
      case 1: 
          return Icon(Icons.play_arrow);
          break;
      case 1: 
          return Icon(Icons.keyboard_arrow_right);
          break;
        default:
              return Icon(Icons.keyboard_arrow_right);
    }
  }
  void _delete(BuildContext context, Note note) async{
    int result=await databaseHelper.deleteNote(note.id);
    if(result!=0){
      _showSnackBar(context, 'Your note has been deleted successfully');
      Loading();
      updateListView();
    }
  }
  void _showSnackBar(BuildContext context, String message){
    final snackBar=SnackBar(content: Text(message),);
    Scaffold.of(context).showSnackBar(snackBar);
  }
  void navigateToDetail(Note note , String title) async{
        bool result = await Navigator.push(context, MaterialPageRoute(builder:(context){
      return NoteDetail(note,title);
    }));
    if (result==true){
      Loading();
      updateListView();
    }
  }
  void  updateListView(){
    final Future<Database> dbFuture= databaseHelper.initializeDatabase();
    dbFuture.then((database){
      Future<List<Note>> noteListFuture=databaseHelper.getNoteList();
      noteListFuture.then((noteList){
        setState((){
          this.noteList=noteList;
          this.count=noteList.length;
        });
      });
    });
  }
}