import 'dart:ffi';

import 'package:flutter/material.dart';

class AdditionalItemInfo extends StatelessWidget {
  final IconData icon;
  final String lable;
  final String num;

  const AdditionalItemInfo({
    super.key,
    required this.icon,
    required this.lable,
    required this.num,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8.0),
      width: 130,
      child: Column(
        children: [
          Icon(
            icon,
            size: 32,
          ),
          SizedBox(height: 10),
          Text(
            lable,
            style: TextStyle(
              fontSize: 20,
            ),
          ),
          SizedBox(height: 10),
          Text(
            num,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 24,
            ),
          ),
        ],
      ),
    );
  }
}
