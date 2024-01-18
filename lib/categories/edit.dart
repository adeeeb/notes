import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:notes/components/custombuttomauth.dart';
import 'package:notes/components/customtextfaildadd.dart';


class EditCategor extends StatefulWidget {
  const EditCategor({Key? key, required this.docid,required this.oldname}) : super(key: key);
  final String oldname;
  final String docid;
  @override
  State<EditCategor> createState() => _EditCategorState();
}

class _EditCategorState extends State<EditCategor> {
  GlobalKey<FormState> formState = GlobalKey<FormState>();
  TextEditingController name = TextEditingController();

  CollectionReference categories = FirebaseFirestore.instance
      .collection('categories');

  Future<void> editCategories() async {
    if(formState.currentState!.validate()) {
      try{
        await categories.doc(widget.docid).update({
          "name" :name.text,
        });
        Navigator.pushNamedAndRemoveUntil(context, 'Homepage', (route) => false);
      }
      catch(e){
        print(e);
      }
    }
  }
@override
  void initState() {
    name.text=widget.oldname;
    super.initState();
  }


  @override
  void dispose() {
    super.dispose();
    name.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(title: Text('Add Category'),),
      body: Form(
          key:formState ,
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.symmetric(vertical: 20,horizontal: 15),
                child: CustomTextFormAdd(hinttext: 'Enter Name', mycontrollar: name, validator: (val){
                  if(val ==''){
                    return "Can't To Be Empty";
                  }
                }),
              ),
              CustomButtomAuth(title: 'Save',onPressed: (){
                editCategories();
              },
              ),
            ],
          )
      ),
    );
  }
}
