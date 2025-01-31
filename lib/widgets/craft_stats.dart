import 'package:flutter/material.dart';

Container craftStats(double width, double height, int completedTasks, int totalTasks) {
  return Container(
    width: width * 0.9,
    margin: EdgeInsets.symmetric(vertical: height * 0.02),
    padding: EdgeInsets.symmetric(
      horizontal: width * 0.05,
      vertical: height * 0.04,
    ),
    decoration: BoxDecoration(
      color: const Color.fromARGB(255, 227, 224, 224),
      borderRadius: BorderRadius.circular(16),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Today's Craftsmanship",
          style: TextStyle(
            fontSize: width * 0.06,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Text(
              "$completedTasks/$totalTasks",
              style: TextStyle(
                fontSize: width * 0.06,
                color: Colors.blue[600],
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: LinearProgressIndicator(
                  value: totalTasks > 0 ? completedTasks / totalTasks : 0,
                  backgroundColor: Colors.grey[200],
                  valueColor: AlwaysStoppedAnimation<Color>(
                    Colors.blue[600]!,
                  ),
                  minHeight: 8,
                ),
              ),
            ),
          ],
        )
      ],
    ),
  );
}
