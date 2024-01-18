import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:notes/components/custombuttomauth.dart';
import 'package:notes/components/logofile.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import '../components/textformfaild.dart';
import 'package:google_sign_in/google_sign_in.dart';
class LogIn extends StatefulWidget {
  const LogIn({Key? key}) : super(key: key);

  @override
  State<LogIn> createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();
  GlobalKey <FormState> formState = GlobalKey <FormState> ();

  Future signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

   await FirebaseAuth.instance.signInWithCredential(credential);
    Navigator.pushNamedAndRemoveUntil(context,'Homepage', (route) => false);
  }

  bool isloading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isloading == true  ? Center(child: CircularProgressIndicator(),)
          :Container(
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
                    Text('LogIn',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                    ),
                    ),
                    Container(height: 10),
                    Text('LogIn To Continue Using The App',
                      style: TextStyle(
                        color:Colors.grey,
                      ),
                    ),
                    Container(height: 20),
                    Text("Email",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18,),),
                    Container(height: 10),
                    CustomTextForm(hinttext: 'Enter Your Email',mycontrollar:email, validator: (val ) {
                      if(val == ""){
                        return "Can't to be empty";
                      }
                    },),
                    Container(height: 10),
                    Text("Password",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18,),),
                    Container(height: 10),
                    CustomTextForm(hinttext: 'Enter Your Password',mycontrollar:password , validator: (val ) {
                      if(val == ""){
                        return "Can't to be empty";

                      }
                    }),
                   InkWell (
                     onTap: () async {
                       if(email.text == ""){
                         QuickAlert.show(
                           context: context,
                           type: QuickAlertType.error,
                           text: 'Please Enter Your Email',
                         );
                         return ;
                       }
                         try {
                           await FirebaseAuth.instance.sendPasswordResetEmail(
                               email: email.text);
                           QuickAlert.show(
                             context: context,
                             type: QuickAlertType.success,
                             text: 'We Sent Link To your Email',
                           );
                         }
                         catch (e) {
                           QuickAlert.show(
                             context: context,
                             type: QuickAlertType.warning,
                             text: 'This Email is Not Registered',
                           );
                         }
                       },
                      child: Container(
                        margin: EdgeInsets.only(top:10,bottom: 10),
                        alignment: Alignment.topRight,
                        child: Text("Forgot Password ?",
                        style: TextStyle(
                        fontSize: 14,
                          color:Colors.grey,
                      ),
                   ),
                      ),
                    ),
                      ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: CustomButtomAuth(title: 'Login',onPressed: () async {

              if(formState.currentState!.validate()){
                  try {
                    isloading = true;
                    setState(() {});
                  final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
                  email: email.text,
                  password: password.text,
                  );
                    isloading = false;
                    setState(() {});
                  if(credential.user!.emailVerified){
                    Navigator.pushReplacementNamed(context, 'Homepage');
                    QuickAlert.show(
                      context: context,
                      type: QuickAlertType.success,
                      text: 'You have been logged in successfully',
                    );
                  }
                  else {
                    print("Verify Your Email");
                    QuickAlert.show(
                      context: context,
                      type: QuickAlertType.warning,
                      text: 'Verify Your Email',
                    );
                  }
                  } on FirebaseAuthException catch (e) {
                    isloading = false;
                    setState(() {});
                  if (e.code == 'user-not-found') {
                  print('No user found for that email.');
                  QuickAlert.show(
                  context: context,
                  type: QuickAlertType.warning,
                  text: 'No user found for that email.',
                  );
                  }
                  else if (e.code == 'wrong-password') {
                  print('Wrong password provided for that user.');
                  QuickAlert.show(
                  context: context,
                  type: QuickAlertType.error,
                  text: 'Wrong password provided for that user.',
                  );
                  }
                  }
                  }
                 else {
                   print('Not Vaild');
               }
              }),
            ),
            Container(height: 20,),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: MaterialButton(
                height: 40,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                color: Colors.blue,
                onPressed: (){
                  signInWithGoogle();
                } ,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color:Colors.white,
                        borderRadius: BorderRadius.circular(50),
                      ),
                        child: Image.asset('image/google.png',width: 30,)
                    ),
                    Container(width: 10,),
                    Text("Login With Google",
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(height: 20),
            InkWell(
              onTap: (){
                Navigator.of(context).pushReplacementNamed("Signup");
              },
              child: Center(
                child: Text.rich(
                  TextSpan(
                  children:
                      [
                        TextSpan(text: "Don't Have An Account ? "),
                        TextSpan(text: "Rigester " , style: TextStyle(color:Colors.orange,fontWeight: FontWeight.bold)),
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
