// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

class CustomErrorWidget extends StatelessWidget {
  final String _error;
  const CustomErrorWidget(
    this._error, {
    super.key,
  });

  @override
  Widget build(BuildContext context) => Center(
        child: Text(
          _error,
          style: TextStyle(
              color: Theme.of(context).colorScheme.error,
              fontWeight: FontWeight.bold),
        ),
      );
}
