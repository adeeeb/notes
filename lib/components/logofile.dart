import 'package:flutter/material.dart';

class LogoUth extends StatelessWidget {
  const LogoUth({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
          alignment: Alignment.center,
          width: 70,
          height: 70,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50),
            color:Colors.grey.shade300,
          ),
          child:Image.asset(
            "image/logo.png",
            width: 100,
            height: 100,
          )
      ),
    );
  }
}
