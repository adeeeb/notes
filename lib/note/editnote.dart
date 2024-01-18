import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:notes/components/custombuttomauth.dart';
import 'package:notes/components/customtextfaildadd.dart';
import 'package:notes/note/viewnotes.dart';


class EditNote extends StatefulWidget {
  const EditNote({Key? key, required this.oldnote, required this.notedocid, required this.categoriedocid}) : super(key: key);
  final String notedocid;
  final String categoriedocid;
  final String oldnote;
  @override
  State<EditNote> createState() => _EditNoteState();
}

class _EditNoteState extends State<EditNote> {
  GlobalKey<FormState> formState = GlobalKey<FormState>();
  TextEditingController note = TextEditingController();

  Future<void> EditNote() async {
    CollectionReference collectionNote = FirebaseFirestore.instance
        .collection('categories')
        .doc(widget.categoriedocid)
        .collection('note');
    if(formState.currentState!.validate()) {
      try{
         await collectionNote
            .doc(widget.notedocid).update({"note": note.text,});
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>NoteView(catogarieid: widget.categoriedocid))) ;
      }
      catch(e){
        print(e);
      }
    }
  }
  @override
  void dispose() {
    super.dispose();
    note.dispose();
  }
@override
  void initState() {
    note.text=widget.oldnote;
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(title: Text('Add Note'),),
      body: Form(
          key:formState ,
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.symmetric(vertical: 20,horizontal: 15),
                child: CustomTextFormAdd(hinttext: 'Enter The Note', mycontrollar: note, validator: (val){
                  if(val ==''){
                    return "Can't To Be Empty";
                  }
                }),
              ),
              CustomButtomAuth(title: 'Edit',onPressed: (){
                EditNote();
              },
              ),
            ],
          )
      ),
    );
  }
}
