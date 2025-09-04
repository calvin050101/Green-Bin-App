import 'package:flutter/cupertino.dart';

Widget listVerticalItems<T>(
  List<T> items,
  Widget Function(BuildContext, T) itemBuilder,
  String emptyText,
) {
  if (items.isEmpty) {
    return Center(
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
    itemBuilder: (context, index) => itemBuilder(context, items[index]),
  );
}

Widget listHorizontalItems<T>(
  List<T> items,
  Widget Function(BuildContext, T) itemBuilder,
  String emptyText,
) {
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
