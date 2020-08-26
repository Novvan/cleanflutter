import 'package:flutter/material.dart';

class LoadingWidget extends StatelessWidget {
  final Size size;

  const LoadingWidget({
    @required this.size,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: size.height * 0.3,
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
