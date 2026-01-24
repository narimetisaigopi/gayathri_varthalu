import 'package:flutter/material.dart';

class CustomLoadingIndicator extends StatelessWidget {
  final String message;
  final Color? color;

  const CustomLoadingIndicator({
    super.key,
    required this.message,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final primaryColor = color ?? Theme.of(context).colorScheme.primary;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
          ),
          const SizedBox(height: 16),
          Text(
            message,
            style: TextStyle(
              color: primaryColor,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
