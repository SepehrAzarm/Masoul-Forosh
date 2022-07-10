import 'package:flutter/material.dart';
import 'package:masoukharid/Constants/colors.dart';

class ChatTextAndAvatar extends StatelessWidget {
  const ChatTextAndAvatar({
    Key? key,
    required this.isMe,
    required this.text,
    required this.profileImage,
  }) : super(key: key);

  final bool isMe;
  final String text;
  final ImageProvider profileImage;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: isMe ? MainAxisAlignment.start : MainAxisAlignment.end,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            padding: const EdgeInsets.all(10.0),
            decoration: BoxDecoration(
              color: isMe ? const Color(0xFFF5F5F5) : kOrangeColor,
              borderRadius: BorderRadius.circular(10),
            ),
            constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.6),
            child: Text(
              text,
              style: TextStyle(
                color: isMe ? const Color(0xFF707070) : Colors.white,
                fontFamily: "Dana",
                fontSize: 12,
              ),
            ),
          ),
        ),
        if (!isMe)
          CircleAvatar(
            radius: 24,
            backgroundColor: Colors.black,
            backgroundImage: profileImage,
          ),
      ],
    );
  }
}
