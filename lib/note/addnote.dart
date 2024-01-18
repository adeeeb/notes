import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:path/path.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:notes/components/custombuttomauth.dart';
import 'package:notes/components/customtextfaildadd.dart';
import 'package:notes/note/viewnotes.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../homepage.dart';


class AddNote extends StatefulWidget {
  const AddNote({Key? key, required this.docid}) : super(key: key);
final String docid;
  @override
  State<AddNote> createState() => _AddNoteState();
}

class _AddNoteState extends State<AddNote> {
  GlobalKey<FormState> formState = GlobalKey<FormState>();
  TextEditingController note = TextEditingController();

  Future<void> addNote(context) async {
    CollectionReference collectionNote = FirebaseFirestore.instance.collection('categories').doc(widget.docid).collection('note');
    if(formState.currentState!.validate()) {

      try{
        DocumentReference response = await collectionNote
            .add({"note": note.text,"url" : url ?? "none"});
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>NoteView(catogarieid: widget.docid,))) ;
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

  File? file;
  String? url;

  getImage() async{
    final ImagePicker picker = ImagePicker();
// Pick an image.
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
// Capture a photo.
    final XFile? photo = await picker.pickImage(source: ImageSource.camera);
    if(photo !=null){
      file=File(photo.path);
      var imagename = basename(photo.path);
      var refStoreg = FirebaseStorage.instance.ref("images").child(imagename);
      await refStoreg.putFile(file!);
      url = await refStoreg.getDownloadURL();

    }
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
              CustomButtomUpload(title: 'Upload Image', isSelected:url == null?false :true ,onPressed: ()async{
              await  getImage();
              },),
              CustomButtomAuth(title: 'Add',onPressed: (){
                addNote(context);
                sendMwssage('Notes App', 'The Note Added');
              },
              ),

            ],
          ),

      ),
    );
  }
}
