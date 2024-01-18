import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:notes/components/custombuttomauth.dart';
import 'package:notes/components/customtextfaildadd.dart';


class AddCategor extends StatefulWidget {
  const AddCategor({Key? key}) : super(key: key);

  @override
  State<AddCategor> createState() => _AddCategorState();
}

class _AddCategorState extends State<AddCategor> {
  GlobalKey<FormState> formState = GlobalKey<FormState>();
  TextEditingController name = TextEditingController();

  CollectionReference categories = FirebaseFirestore.instance.collection('categories');

  Future<void> addCategories() async {
    if(formState.currentState!.validate()) {
      try{
        DocumentReference response = await categories
            .add({"name": name.text,"id" : FirebaseAuth.instance.currentUser!.uid});
        Navigator.pushNamedAndRemoveUntil(context, 'Homepage', (route) => false);
      }
      catch(e){
        print(e);
      }
    }
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
              CustomButtomAuth(title: 'Add',onPressed: (){
                addCategories();
              },
              ),
            ],
          )
      ),
    );
  }
}
