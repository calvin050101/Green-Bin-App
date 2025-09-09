import 'package:flutter/material.dart';

class LoadingError extends StatelessWidget {
  final String error;
  const LoadingError({super.key, required this.error});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(
          error,
          textAlign: TextAlign.center,
          style: const TextStyle(color: Colors.red, fontSize: 16),
        ),
      ),
    );
  }
}
