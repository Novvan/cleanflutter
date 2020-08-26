import 'package:flutter/material.dart';

import '../../domain/entities/number_trivia.dart';

class TriviaDisplay extends StatelessWidget {
  final NumberTrivia numberTrivia;
  final Size size;

  const TriviaDisplay({
    @required this.numberTrivia,
    @required this.size,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: size.height * 0.3,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            numberTrivia.number.toString(),
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 50,
              fontWeight: FontWeight.bold,
            ),
          ),
          SingleChildScrollView(
            child: Text(
              numberTrivia.text,
              textAlign: TextAlign.center,
            ),
          )
        ],
      ),
    );
  }
}
