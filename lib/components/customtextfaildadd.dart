import 'package:flutter/material.dart';


class CustomTextFormAdd extends StatelessWidget {
  final String hinttext;
  final TextEditingController mycontrollar;
  const CustomTextFormAdd ({Key? key, required this.hinttext, required this.mycontrollar,required this.validator}) : super(key: key);
  final String? Function(String?)?  validator;
  @override
  Widget build(BuildContext context) {
    return   TextFormField(
      validator:validator ,
      controller: mycontrollar,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(vertical: 2 , horizontal: 10),
        filled: true,
        fillColor: Colors.grey.shade200,
        hintText: hinttext,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(50),
          borderSide: BorderSide(color: Colors.grey.shade400),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(50),
          borderSide: BorderSide(color: Colors.grey.shade400),
        ),
      ),
    );
  }
}
