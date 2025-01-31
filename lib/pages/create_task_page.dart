import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CreateTaskPage extends StatefulWidget {
  final List<String> categories;
  final Function(String, Map<String, dynamic>) onCreateTask;
  final Function(String) onCreateCategory;

  const CreateTaskPage({
    super.key,
    required this.categories,
    required this.onCreateTask,
    required this.onCreateCategory,
  });

  @override
  _CreateTaskPageState createState() => _CreateTaskPageState();
}

class _CreateTaskPageState extends State<CreateTaskPage> {
  late TextEditingController _taskNameController;
  late TextEditingController _newCategoryController;
  DateTime? _startDateTime;
  DateTime? _endDateTime;
  String? _selectedCategory;
  bool _favorite = false;
  bool _status = false;

  @override
  void initState() {
    super.initState();
    _taskNameController = TextEditingController();
    _newCategoryController = TextEditingController();
  }

  @override
  void dispose() {
    _taskNameController.dispose();
    _newCategoryController.dispose();
    super.dispose();
  }

  String _calculateDuration(DateTime endDateTime) {
    final now = DateTime.now();
    final duration = endDateTime.difference(now);
    return "${duration.inHours}h ${duration.inMinutes.remainder(60)}m";
  }

  Future<void> _selectDateTime(BuildContext context, bool isStart) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null) {
      final TimeOfDay? pickedTime = await showTimePicker(
        // ignore: use_build_context_synchronously
        context: context,
        initialTime: TimeOfDay.now(),
      );
      if (pickedTime != null) {
        setState(() {
          final selectedDateTime = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            pickedTime.hour,
            pickedTime.minute,
          );
          if (isStart) {
            _startDateTime = selectedDateTime;
          } else {
            _endDateTime = selectedDateTime;
          }
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Create Task",
          style: TextStyle(
            fontSize: width * 0.06,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.blue[600],
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(width * 0.05),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _taskNameController,
              decoration: InputDecoration(
                labelText: "Task Name",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: height * 0.02),
            Row(
              children: [
                Text(
                  "Start DateTime: ",
                  style: TextStyle(
                    fontSize: width * 0.05,
                    color: Colors.grey[700],
                  ),
                ),
                ElevatedButton(
                  onPressed: () => _selectDateTime(context, true),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue[600],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    _startDateTime == null
                        ? "Select DateTime"
                        : DateFormat("MMM d, yyyy h:mma")
                            .format(_startDateTime!),
                    style: TextStyle(
                      fontSize: width * 0.04,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: height * 0.02),
            Row(
              children: [
                Text(
                  "End DateTime: ",
                  style: TextStyle(
                    fontSize: width * 0.05,
                    color: Colors.grey[700],
                  ),
                ),
                ElevatedButton(
                  onPressed: () => _selectDateTime(context, false),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue[600],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    _endDateTime == null
                        ? "Select DateTime"
                        : DateFormat("MMM d, yyyy h:mma").format(_endDateTime!),
                    style: TextStyle(
                      fontSize: width * 0.04,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: height * 0.02),
            DropdownButtonFormField<String>(
              value: _selectedCategory,
              hint: Text("Select Category"),
              onChanged: (value) {
                setState(() {
                  _selectedCategory = value;
                });
              },
              items: widget.categories
                  .where((category) => category != "All Tasks")
                  .map((category) {
                return DropdownMenuItem(
                  value: category,
                  child: Text(category),
                );
              }).toList(),
              decoration: InputDecoration(
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: height * 0.02),
            TextField(
              controller: _newCategoryController,
              decoration: InputDecoration(
                labelText: "New Category (Optional)",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: height * 0.02),
            Row(
              children: [
                Text(
                  "Favorite: ",
                  style: TextStyle(
                    fontSize: width * 0.05,
                    color: Colors.grey[700],
                  ),
                ),
                IconButton(
                  icon: Icon(
                    _favorite ? Icons.star : Icons.star_border,
                    color: Colors.yellow[600],
                    size: width * 0.06,
                  ),
                  onPressed: () {
                    setState(() {
                      _favorite = !_favorite;
                    });
                  },
                ),
              ],
            ),
            SizedBox(height: height * 0.02),
            Row(
              children: [
                Text(
                  "Status: ",
                  style: TextStyle(
                    fontSize: width * 0.05,
                    color: Colors.grey[700],
                  ),
                ),
                Checkbox(
                  shape: CircleBorder(),
                  value: _status,
                  onChanged: (value) {
                    setState(() {
                      _status = value!;
                    });
                  },
                  activeColor: Colors.blue[600],
                ),
              ],
            ),
            SizedBox(height: height * 0.02),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  if (_newCategoryController.text.isNotEmpty) {
                    widget.onCreateCategory(_newCategoryController.text);
                    _selectedCategory = _newCategoryController.text;
                  }
                  widget.onCreateTask(_taskNameController.text, {
                    'start': _startDateTime != null
                        ? DateFormat("MMM d, yyyy h:mma")
                            .format(_startDateTime!)
                        : null,
                    'end': _endDateTime != null
                        ? DateFormat("MMM d, yyyy h:mma").format(_endDateTime!)
                        : null,
                    'duration': _endDateTime != null
                        ? _calculateDuration(_endDateTime!)
                        : null,
                    'favorite': _favorite,
                    'status': _status,
                    'category': _selectedCategory,
                  });
                  Navigator.of(context).pop();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue[600],
                ),
                child: Text(
                  "Create Task",
                  style: TextStyle(
                    fontSize: width * 0.05,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
