import 'package:flutter/cupertino.dart';

Widget listVerticalItems<T>({
  required List<T> items,
  required Widget Function(BuildContext, T) itemBuilder,
  required String emptyText,
}) {
  if (items.isEmpty) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 30.0),
        child: Text(emptyText),
      ),
    );
  }

  return ListView.builder(
    shrinkWrap: true,
    physics: const NeverScrollableScrollPhysics(),
    itemCount: items.length,
    itemBuilder: (context, index) => itemBuilder(context, items[index]),
  );
}

Widget listHorizontalItems<T>({
  required List<T> items,
  required Widget Function(BuildContext, T) itemBuilder,
  required String emptyText,
}) {
  if (items.isEmpty) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 50.0),
        child: Text(emptyText),
      ),
    );
  }

  return ListView.builder(
    scrollDirection: Axis.horizontal,
    itemCount: items.length,
    itemBuilder: (context, index) => itemBuilder(context, items[index]),
  );
}
