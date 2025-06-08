import 'package:flutter/material.dart';

class ErrorMessageText extends StatelessWidget {
  final String? errorMessage;

  const ErrorMessageText({super.key, this.errorMessage});

  @override
  Widget build(BuildContext context) {
    return Text(
      errorMessage ?? '',
      style: TextStyle(
        color: Colors.red,
        fontSize: 12.0,
        fontFamily: 'Montserrat',
      ),
    );
  }
}
