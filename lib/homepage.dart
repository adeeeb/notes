import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:notes/categories/edit.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'note/viewnotes.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_messaging/firebase_messaging.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isloading = true;
  List<QueryDocumentSnapshot> data = [];
  getData() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('categories')
        .where("id",isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .get();
    data.addAll(querySnapshot.docs);
    isloading=false;
    setState(() {});
  }
  @override
  void initState() {
    getData();
    getToken();
    myRequestPermation ();
    super.initState();

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if(message.notification!=null){
        print("=======================+++++++++++====================");
        print(message.notification!.title);
        print(message.notification!.body);
        print("=======================+++++++++++====================");
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${message.notification!.body}')));
      }
    });
  }

  myRequestPermation () async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
    } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
      print('User granted provisional permission');
    } else {
      print('User declined or has not accepted permission');
    }
  }


getToken()async{
    String? myToken = await FirebaseMessaging.instance.getToken();
    print("========================================");
      print(myToken);
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, 'Addcategor');
        },
        backgroundColor: Colors.orange,
        child: Icon(Icons.add),
      ),
      appBar: AppBar(
        title: Text("Categories"),
        actions: [
          IconButton(icon: Icon(Icons.exit_to_app), onPressed: () async {
            await FirebaseAuth.instance.signOut();
            Navigator.pushNamedAndRemoveUntil(
                context, 'Login', (route) => false);
          })
        ],
      ),
      body:isloading==true ? Center(child: CircularProgressIndicator(),) :  GridView.builder(
        itemCount: data.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, mainAxisExtent: 175),
        itemBuilder: (context, i) {
          return InkWell(
            onTap: (){
              Navigator.of(context).push(MaterialPageRoute(builder: (context)=>NoteView(catogarieid: data[i].id,)));
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
                        .collection('categories').doc(data[i].id).delete();
                    Navigator.pushNamedAndRemoveUntil(context, 'Homepage', (route) => false);
                 },
                cancelBtnText: 'Edit',
                 cancelBtnTextStyle:TextStyle(color: Colors.blue),
                 onCancelBtnTap: (){
                   print('Edit');
                   Navigator.of(context).push(MaterialPageRoute(builder: (context)
                   => EditCategor(docid: data[i].id, oldname: data[i]['name']))) ;
                 },
                confirmBtnColor: Colors.green,
              );

            },
            child: Card(
              child:Container(
                padding:EdgeInsets.all(10),
                child: Column(
                  children: [
                    Image.asset("image/folder.png",height: 100,),
                    Padding(
                      padding: const EdgeInsets.only(top:10.0),
                      child: Text("${data[i]['name']}",style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
  }

  sendMwssage(title , message) async {
  var headersList ={
    'Accept': '*/*',
    'Content-Type' : 'application/json',
    'Authorization' : 'key=AAAAuVgwGog:APA91bFxArhRTbIKSXCjZk_MkmOx_Dmkf8YBl7CSTaAy1kVW7f-gabCQvZA6LielWK-g8hwozyp3o7mwWn_KzTFlVuWN8NDGq-Dz_6UJ-J3Ej5NwWpGDwEz49gSygmLZMri7-MpVmMBA',
  };
  var url =Uri.parse('https://fcm.googleapis.com/fcm/send');
  var body = {
    "to":
    'dNM8VTVUTKybT1sGhlOxyq:APA91bHph25x__TCrZ3ANZuCHAoZp9LndC3SwZ-WbbZ4jwQbkq_1eRgu_9s89h9SaFqVZgu-3JFR6mNhk9wwftcQeLxSCNiURhIl3M1M4lgZftTMI6fsnVAz2hJObKpeBTnAhSNYKktJ',
    "notification" : {"title": title , "body": message}
  };
  var req = http.Request('POST',url);
req.headers.addAll(headersList);
req.body = json.encode(body);

var res = await req.send();
final resBody = await res.stream.bytesToString();
if(res.statusCode >=200 && res.statusCode <300){
  print(resBody);}
  else{
    print(res.reasonPhrase);
  }
  }

