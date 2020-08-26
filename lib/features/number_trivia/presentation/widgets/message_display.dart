import 'package:flutter/material.dart';

class MessageDisplay extends StatelessWidget {
  final String message;
  final Size size;

  const MessageDisplay({
    @required this.message,
    @required this.size,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: size.height * 0.3,
      child: Center(
        child: SingleChildScrollView(
          child: Text(
            message,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
