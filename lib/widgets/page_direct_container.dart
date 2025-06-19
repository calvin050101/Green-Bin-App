import 'package:flutter/material.dart';

import 'cust_container.dart';

class PageDirectContainer extends StatelessWidget {
  final String text;
  final void Function()? onTap;

  const PageDirectContainer({
    super.key,
    required this.text,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: CustContainer(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                text,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  fontFamily: 'OpenSans',
                ),
              ),
            ),

            Icon(Icons.arrow_forward_ios_rounded),
          ],
        ),
      ),
    );
  }
}
