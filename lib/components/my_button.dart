import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  final void Function()? onTap;
  final String text;
  const MyButton({super.key, required this.onTap, required this.text});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.amber,
          borderRadius: BorderRadius.circular(17),
        ),
        child: Center(
            child: Text(
          text,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
        )),
      ),
    );
  }
}
