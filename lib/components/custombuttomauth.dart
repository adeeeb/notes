import 'package:flutter/material.dart';

class CustomButtomAuth extends StatelessWidget {
  const CustomButtomAuth({Key? key, required this.title, this.onPressed}) : super(key: key);
final String title ;
final void Function()? onPressed;
  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      height: 40,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      color: Colors.orange,
      onPressed: onPressed ,
      child: Text(title,
        style: TextStyle(
          color: Colors.white,
        ),
      ),
    );
  }
}
class CustomButtomUpload extends StatelessWidget {
  const CustomButtomUpload({Key? key, required this.title, this.onPressed, required this.isSelected}) : super(key: key);
  final String title ;
  final void Function()? onPressed;
  final bool isSelected;
  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      height: 35,
      minWidth: 200,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      color:isSelected ? Colors.grey : Colors.orange,
      onPressed: onPressed ,
      child: Text(title,
        style: TextStyle(
          color: Colors.white,
        ),
      ),
    );
  }
}

