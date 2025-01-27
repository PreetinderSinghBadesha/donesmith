import 'package:flutter/material.dart';

AppBar appBar(double width) {
  return AppBar(
    title: Row(
      children: [
        Icon(
          Icons.hardware,
          color: Colors.blue[600],
          size: width * 0.08,
        ),
        const SizedBox(width: 8),
        Text(
          'DoneSmith',
          style: TextStyle(
            fontSize: width * 0.06,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    ),
    actions: [
      Padding(
        padding: const EdgeInsets.only(right: 16),
        child: Icon(
          Icons.menu,
          color: Colors.grey,
          size: width * 0.09,
        ),
      ),
    ],
  );
}
