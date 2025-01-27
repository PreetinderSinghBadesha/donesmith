import 'package:donesmith/widgets/app_bar.dart';
import 'package:donesmith/widgets/category_chip.dart';
import 'package:donesmith/widgets/craft_stats.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final Map<String, Map<String, dynamic>> tasks = {
    "Task 0": {
      "start": "9:00 AM",
      "end": "10:00 AM",
      "status": false,
      "duration": "1h",
      "favorite": false
    },
    "Task 1": {
      "start": "10:00 AM",
      "end": "11:00 AM",
      "status": true,
      "duration": "1h",
      "favorite": true
    },
  };

  int get completedTasks => tasks.values.where((task) => task['status']).length;
  int get totalTasks => tasks.length;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: appBar(width),
      body: Container(
        width: width,
        height: height,
        color: Colors.grey[100],
        child: Column(
          children: [
            craftStats(width, height, completedTasks, totalTasks),
            Padding(
              padding: EdgeInsets.only(left: width * 0.05),
              child: SizedBox(
                height: height * 0.1,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    CategoryChip(
                      label: 'All Tasks',
                      isSelected: true,
                    ),
                    CategoryChip(
                      label: 'Work',
                      isSelected: false,
                    ),
                    CategoryChip(
                      label: 'Personal',
                      isSelected: false,
                    ),
                    CategoryChip(
                      label: 'Design',
                      isSelected: false,
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: tasks.length,
                itemBuilder: (context, index) {
                  String taskKey = tasks.keys.elementAt(index);
                  return Container(
                    margin: EdgeInsets.symmetric(
                      horizontal: width * 0.05,
                      vertical: height * 0.01,
                    ),
                    padding: EdgeInsets.symmetric(
                      horizontal: width * 0.05,
                      vertical: height * 0.02,
                    ),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 227, 224, 224),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Theme(
                          data: Theme.of(context).copyWith(
                            unselectedWidgetColor: Colors.blue[600],
                          ),
                          child: Checkbox(
                            shape: CircleBorder(),
                            value: tasks[taskKey]!['status'],
                            onChanged: (value) {
                              setState(() {
                                tasks[taskKey]!['status'] = value;
                              });
                            },
                            activeColor: Colors.blue[600],
                          ),
                        ),
                        SizedBox(width: width * 0.02),
                        Expanded(
                          child: Text(
                            taskKey,
                            style: TextStyle(
                              fontSize: width * 0.04,
                              fontWeight: FontWeight.bold,
                              decoration: tasks[taskKey]!['status']
                                  ? TextDecoration.lineThrough
                                  : TextDecoration.none,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Row(
                          children: [
                            Icon(
                              tasks[taskKey]!['favorite']
                                  ? Icons.star
                                  : Icons.star_border,
                              color: Colors.yellow[600],
                              size: width * 0.06,
                            ),
                            Icon(
                              Icons.timer,
                              color: Colors.grey[500],
                            ),
                            Text(
                              tasks[taskKey]!['duration'],
                              style: TextStyle(
                                fontSize: width * 0.04,
                                color: Colors.grey[500],
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: Colors.blue[600],
        child: Icon(
          Icons.add,
          color: Colors.white,
          size: width * 0.08,
        ),
      ),
    );
  }
}
