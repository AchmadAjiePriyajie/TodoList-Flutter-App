import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

//ignore: must_be_immutable
class TodoTile extends StatelessWidget {
  final String taskName;
  final bool taskCompleted;
  Function(bool?)? onChanged;
  Function(BuildContext)? deleteFunction;
  TodoTile({
    super.key,
    required this.onChanged,
    required this.taskCompleted,
    required this.taskName,
    required this.deleteFunction,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 30,
        top: 30,
        right: 30,
      ),
      child: Slidable(
        endActionPane: ActionPane(
          motion: const StretchMotion(),
          children: [
            SlidableAction(
              onPressed: deleteFunction,
              icon: Icons.delete,
              backgroundColor: Colors.red,
              borderRadius: BorderRadius.circular(20),
            ),
          ],
        ),
        child: Container(
          padding: const EdgeInsets.all(30),
          decoration: BoxDecoration(
            color: Colors.amber,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            children: [
              Checkbox(
                value: taskCompleted,
                onChanged: onChanged,
                activeColor: Colors.black,
              ),
              Text(
                taskName,
                style: TextStyle(
                  decoration: taskCompleted
                      ? TextDecoration.lineThrough
                      : TextDecoration.none,
                  fontSize: 17,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
