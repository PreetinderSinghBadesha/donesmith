import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TaskPage extends StatefulWidget {
  final String taskKey;
  final Map<String, dynamic> taskDetails;

  const TaskPage({
    super.key,
    required this.taskKey,
    required this.taskDetails,
  });

  @override
  _TaskPageState createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> {
  late TextEditingController _startController;
  late TextEditingController _endController;
  late bool _favorite;
  late bool _status;
  DateTime? _startDateTime;
  DateTime? _endDateTime;

  @override
  void initState() {
    super.initState();
    _startController = TextEditingController(text: widget.taskDetails['start']);
    _endController = TextEditingController(text: widget.taskDetails['end']);
    _favorite = widget.taskDetails['favorite'];
    _status = widget.taskDetails['status'];
  }

  @override
  void dispose() {
    _startController.dispose();
    _endController.dispose();
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
          widget.taskKey,
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
            Text(
              "Task Details",
              style: TextStyle(
                fontSize: width * 0.06,
                fontWeight: FontWeight.bold,
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
            // SizedBox(height: height * 0.02),
            // Text(
            //   "Duration: ${_endDateTime != null ? _calculateDuration(_endDateTime!) : 'N/A'}",
            //   style: TextStyle(
            //     fontSize: width * 0.05,
            //     color: Colors.grey[700],
            //   ),
            // ),
            SizedBox(height: height * 0.01),
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
                  Navigator.of(context).pop({
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
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue[600],
                ),
                child: Text(
                  "Save",
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
