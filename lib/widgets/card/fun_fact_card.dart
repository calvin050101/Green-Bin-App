import 'package:flutter/material.dart';

class FunFactCard extends StatelessWidget {
  final IconData icon;
  final String text;

  const FunFactCard({super.key, required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250,
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(icon, color: Theme.of(context).colorScheme.primary, size: 30),
          const SizedBox(width: 15),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                color: Color(0xFF333333),
                fontFamily: 'OpenSans',
                fontWeight: FontWeight.w600
              ),
            ),
          ),
        ],
      ),
    );
  }
}