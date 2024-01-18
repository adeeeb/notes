import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:notes/components/custombuttomauth.dart';
import 'package:notes/components/logofile.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import '../components/textformfaild.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();
  final TextEditingController username = TextEditingController();
  GlobalKey <FormState> formState = GlobalKey <FormState> ();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: formState,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(height: 30),
                    LogoUth(),
                    Container(height: 20),
                    Text('SignUp',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 22,
                      ),
                    ),
                    Container(height: 10),
                    Text('SignUp To Continue Using The App',
                      style: TextStyle(
                        color:Colors.grey,
                      ),
                    ),
                    Container(height: 20),
                    Text("Username",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18,),),
                    Container(height: 10),
                    CustomTextForm(hinttext: 'Enter Username',mycontrollar:username , validator: (val ) {
                      if(val == ""){
                        return "Can't to be empty";
                      }
                    }),
                    Container(height: 10),
                    Text("Email",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18,),),
                    Container(height: 10),
                    CustomTextForm(hinttext: 'Enter Email',mycontrollar:email , validator: (val ) {
                      if(val == ""){
                        return "Can't to be empty";
                      }
                    }),
                    Container(height: 10),
                    Text("Password",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18,),),
                    Container(height: 10),
                    CustomTextForm(hinttext: 'Enter Password',mycontrollar:password , validator: (val ) {
                      if(val == ""){
                        return "Can't to be empty";
                      }
                    }),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: CustomButtomAuth(title: 'Signup',onPressed:  () async {
                if(formState.currentState!.validate())
                {
                  try {
                    final credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
                      email: email.text,
                      password: password.text,
                    );
                    FirebaseAuth.instance.currentUser!.sendEmailVerification();
                    Navigator.pushReplacementNamed(context, 'Login');
                    QuickAlert.show(
                      context: context,
                      type: QuickAlertType.confirm,
                      title: 'Verify Now!',
                      text: 'We Sent Link To Your Email . ',
                    );
                  } on FirebaseAuthException catch (e) {
                    if (e.code == 'weak-password') {
                      print('The password provided is too weak.');
                      QuickAlert.show(
                        context: context,
                        type: QuickAlertType.warning,
                        text: 'The password provided is too weak.',
                      );
                    } else if (e.code == 'email-already-in-use') {
                      print('The account already exists for that email.');
                      QuickAlert.show(
                        context: context,
                        type: QuickAlertType.warning,
                        text: 'The account already exists for that email.',
                      );
                    }
                  } catch (e) {
                    print(e);
                  }
                }
                else {
                  print('Not Vaild');
                }
              }),
            ),
            Container(height: 20,),
            InkWell(
              onTap: (){
                Navigator.of(context).pushNamed("Login");
              },
              child: Center(
                child: Text.rich(
                  TextSpan(
                      children:
                      [
                        TextSpan(text: "You Have An Account ? "),
                        TextSpan(text: "LogIn " , style: TextStyle(color:Colors.orange,fontWeight: FontWeight.bold)),
                      ]
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
