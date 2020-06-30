import 'package:flutter/material.dart';
//import './models/note.dart';
import './screens/note_list.dart';
//import './screens/note_detail.dart';
void main(){
  runApp(MyApp());
  }
class MyApp extends StatelessWidget{
    @override 
  Widget build(BuildContext context){
    return MaterialApp(
      title:'NotePadd: I Remember',
      debugShowCheckedModeBanner: false,
      theme:ThemeData(
        primarySwatch: Colors.lime,
        
       ),
       home:NoteList(),
    );
  }
}