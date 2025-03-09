import 'package:flutter/material.dart';

class HourlyWeather extends StatelessWidget {
  final String time;
  final IconData icon;
  final String val;

  const HourlyWeather({
    super.key,
    required this.time,
    required this.icon,
    required this.val,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 12,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
      ),
      child: Container(
        width: 100,
        padding: EdgeInsets.all(8.0),
        child: Column(
          children: [
            Text(
              time,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Icon(
              icon,
              size: 32,
            ),
            SizedBox(height: 10),
            Text(
              val,
              style: TextStyle(
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
