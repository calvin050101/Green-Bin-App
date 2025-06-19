import 'package:flutter/cupertino.dart';

Widget listItems<T>(
  List<T> items,
  Widget? Function(BuildContext, int) itemBuilder,
  String emptyText,
) {
  if (items.isEmpty) {
    Center(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 50.0),
        child: Text(emptyText),
      ),
    );
  }

  return ListView.builder(
    shrinkWrap: true,
    physics: const NeverScrollableScrollPhysics(),
    itemCount: items.length,
    itemBuilder: itemBuilder,
  );
}
