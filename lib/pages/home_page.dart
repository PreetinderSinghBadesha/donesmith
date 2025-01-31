import 'package:donesmith/widgets/app_bar.dart';
import 'package:donesmith/widgets/category_chip.dart';
import 'package:donesmith/widgets/craft_stats.dart';
import 'package:flutter/material.dart';
import 'package:donesmith/pages/task_page.dart';
import 'package:donesmith/pages/create_task_page.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Map<String, Map<String, dynamic>> tasks = {};
  List<String> categories = ["All Tasks", "Work", "Personal", "Design"];
  String selectedCategory = "All Tasks";

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final prefs = await SharedPreferences.getInstance();
    final tasksString = prefs.getString('tasks');
    final categoriesString = prefs.getString('categories');
    if (tasksString != null) {
      setState(() {
        tasks =
            Map<String, Map<String, dynamic>>.from(json.decode(tasksString));
      });
    }
    if (categoriesString != null) {
      setState(() {
        categories = List<String>.from(json.decode(categoriesString));
      });
    }
  }

  Future<void> _saveTasks() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('tasks', json.encode(tasks));
  }

  Future<void> _saveCategories() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('categories', json.encode(categories));
  }

  int get completedTasksToday =>
      todayTasks.where((taskKey) => tasks[taskKey]!['status']).length;
  int get totalTasksToday => todayTasks.length;

  void _createTask(String taskName, Map<String, dynamic> taskDetails) {
    setState(() {
      tasks[taskName] = taskDetails;
      _saveTasks();
    });
  }

  void _createCategory(String category) {
    setState(() {
      categories.add(category);
      _saveCategories();
    });
  }

  List<String> get todayTasks {
    final today = DateTime.now();
    return tasks.keys.where((taskKey) {
      final taskStartDate =
          DateFormat("MMM d, yyyy h:mma").parse(tasks[taskKey]!['start']);
      return taskStartDate.year == today.year &&
          taskStartDate.month == today.month &&
          taskStartDate.day == today.day &&
          (selectedCategory == "All Tasks" ||
              tasks[taskKey]!['category'] == selectedCategory);
    }).toList();
  }

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
            craftStats(width, height, completedTasksToday, totalTasksToday),
            Padding(
              padding: EdgeInsets.only(left: width * 0.05),
              child: SizedBox(
                height: height * 0.1,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: categories.map((category) {
                    return CategoryChip(
                      label: category,
                      isSelected: selectedCategory == category,
                      onSelected: (bool selected) {
                        setState(() {
                          selectedCategory = category;
                        });
                      },
                    );
                  }).toList(),
                ),
              ),
            ),
            Expanded(
              child: todayTasks.isEmpty
                  ? Center(
                      child: Text(
                        "No tasks available.",
                        style: TextStyle(
                          fontSize: width * 0.05,
                          color: Colors.grey[600],
                        ),
                      ),
                    )
                  : ListView.builder(
                      shrinkWrap: true,
                      itemCount: todayTasks.length,
                      itemBuilder: (context, index) {
                        String taskKey = todayTasks[index];
                        return GestureDetector(
                          onTap: () async {
                            final updatedTask = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => TaskPage(
                                  taskKey: taskKey,
                                  taskDetails: tasks[taskKey]!,
                                ),
                              ),
                            );

                            if (updatedTask != null) {
                              setState(() {
                                tasks[taskKey] = updatedTask;
                                _saveTasks();
                              });
                            }
                          },
                          child: Container(
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
                                        _saveTasks();
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
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          tasks[taskKey]!['favorite'] =
                                              !tasks[taskKey]!['favorite'];
                                          _saveTasks();
                                        });
                                      },
                                      child: Icon(
                                        tasks[taskKey]!['favorite']
                                            ? Icons.star
                                            : Icons.star_border,
                                        color: Colors.yellow[600],
                                        size: width * 0.06,
                                      ),
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
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CreateTaskPage(
                categories: categories,
                onCreateTask: _createTask,
                onCreateCategory: _createCategory,
              ),
            ),
          );
        },
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
