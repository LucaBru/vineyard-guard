import 'package:flutter/material.dart';

class EmptyListWidget extends StatelessWidget {
  final String _itemName;
  const EmptyListWidget(this._itemName, {super.key});

  @override
  Widget build(BuildContext context) => Center(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        const ImageIcon(
          AssetImage("assets/empty_list_icon.png"),
          size: 80,
        ),
        Text('Add $_itemName',
            style: const TextStyle(fontWeight: FontWeight.bold)),
      ]));
}
