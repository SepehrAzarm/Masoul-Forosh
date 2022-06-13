import 'package:flutter/material.dart';

class DeleteDialog extends StatelessWidget {
  const DeleteDialog({
    Key? key,
    required this.text,
  }) : super(key: key);

  final String text;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Container(
        decoration: const BoxDecoration(
          // color: Colors.amberAccent,
          borderRadius: BorderRadius.all(
            Radius.circular(14),
          ),
        ),
        height: 90,
        width: 90,
        child: Image.asset('images/Icons/DeleteIcon.png'),
      ),
      content: Text(
        text,
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontFamily: 'Dana',
          fontWeight: FontWeight.bold,
          fontSize: 20,
          color: Color(0xFF535353),
        ),
      ),
      actions: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: const Color(0xFFFF0000),
                ),
                borderRadius: BorderRadius.circular(10.0),
              ),
              height: 45,
              width: 140,
              child: TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Center(
                  child: Text(
                    'خیر',
                    style: TextStyle(
                      fontFamily: 'Dana',
                      fontSize: 14,
                      color: Color(0xFFFF0000),
                    ),
                  ),
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFFFF0000),
                borderRadius: BorderRadius.circular(10.0),
              ),
              height: 45,
              width: 140,
              child: TextButton(
                onPressed: () {},
                child: const Center(
                  child: Text(
                    'حذف کن!',
                    style: TextStyle(
                      fontFamily: 'Dana',
                      fontSize: 14,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        )
      ],
    );
  }
}
