import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:notes/note/addnote.dart';
import 'package:notes/note/editnote.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

class NoteView extends StatefulWidget {
  const NoteView({Key? key, required this.catogarieid}) : super(key: key);
  final String catogarieid;
  @override
  State<NoteView> createState() => _NoteViewState();
}

class _NoteViewState extends State<NoteView> {

  bool isloading = true;
  List<QueryDocumentSnapshot> data = [];
  getData() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('categories')
        .doc(widget.catogarieid)
        .collection("note")
        .get();
    data.addAll(querySnapshot.docs);
    isloading=false;
    setState(() {

    });
  }
  @override
  void initState() {
    getData();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>AddNote(docid: widget.catogarieid))) ;
        },
        backgroundColor: Colors.orange,
        child: Icon(Icons.add),
      ),
      appBar: AppBar(
        title: Text("Notes"),
        actions: [
          IconButton(icon: Icon(Icons.exit_to_app), onPressed: () async {
            await FirebaseAuth.instance.signOut();
            Navigator.pushNamedAndRemoveUntil(
                context, 'Login', (route) => false);
          })
        ],
      ),
      body:WillPopScope(child: isloading==true ? Center(child: CircularProgressIndicator(),) :  GridView.builder(
        itemCount: data.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, mainAxisExtent: 175),
        itemBuilder: (context, i) {
          return InkWell(
            onTap: (){
              Navigator.of(context).push(MaterialPageRoute(builder: (context)=> EditNote(notedocid: data[i].id, oldnote: data[i]['note'], categoriedocid: widget.catogarieid,)));
            },
            onLongPress: (){
              QuickAlert.show(
                context: context,
                type: QuickAlertType.confirm,
                title: "Select Please !",
                confirmBtnText: 'Delet',
                onConfirmBtnTap: ()async{
                  print('Deleted');
                  await FirebaseFirestore.instance
                      .collection('categories').doc(widget.catogarieid).collection('note').doc(data[i].id).delete();
                  Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>NoteView(catogarieid: widget.catogarieid,))) ;
                },
                confirmBtnColor: Colors.green,
              );

            },
            child: Card(
              child:Container(
                padding:EdgeInsets.all(20),
                child:
                     Column(
                        children: [
                          Text("${data[i]['note']}",style: TextStyle(
                            fontSize: 18,
                          ),
                          ),
                          SizedBox(height: 10,),
                          if(data[i]['url']!='none')
                              Image.network(data[i]['url'],width: 100,height: 95,fit: BoxFit.fill,)
                        ],
                      ),
                    ),
              ),


          );
        },
      ), onWillPop: (){
        Navigator.of(context).pushNamedAndRemoveUntil('Homepage', (route) => false);
        return Future.value(false);
    })
    );
  }
}

