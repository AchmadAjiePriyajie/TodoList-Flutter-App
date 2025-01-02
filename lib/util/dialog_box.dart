import 'package:flutter/material.dart';
import 'package:todo_app/util/my_button.dart';

//ignore: must_be_immutable
class DialogBox extends StatelessWidget {
  final controller;
  VoidCallback onSave;
  VoidCallback onCancel;

  DialogBox({
    super.key,
    required this.controller,
    required this.onSave,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return AlertDialog(
      backgroundColor: Colors.amber,
      content: SizedBox(
        height: 800 / 6.15,
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TextField(
                maxLength: 15,
                controller: controller,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  fillColor: Colors.white,
                  filled: true,
                  hintText: 'Add new task',
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  MyButton(text: 'save', onPressed: onSave),
                  const SizedBox(
                    width: 5,
                  ),
                  MyButton(text: 'cancel', onPressed: onCancel),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
