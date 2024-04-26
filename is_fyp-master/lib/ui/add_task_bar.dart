import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:is_fyp/controllers/task_controller.dart';
import 'package:is_fyp/ui/theme.dart';
import 'package:is_fyp/ui/widgets/button.dart';
import 'package:is_fyp/ui/widgets/input_field.dart';

import '../models/task.dart';
import '../user_location/mappage.dart';


class AddTaskPage extends StatefulWidget {
  final Task? task;
  const AddTaskPage({Key? key, this.task}) : super(key: key);

  @override
  State<AddTaskPage> createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  final TaskController _taskController = Get.put(TaskController());
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.task != null) {
      // If task is not null, populate the fields with task details
      _titleController.text = widget.task!.title ?? "";
      _noteController.text = widget.task!.note ?? "";
      // Populate other fields accordingly
    }
  }

  DateTime _selectedDate = DateTime.now();
  String _endTime = "9:30 PM";
  String _startTime = DateFormat("hh:mm a").format(DateTime.now()).toString();
  int _selectedRemind = 5;
  String _selectedNotification = "Message";
  List<String> notificationList = [
    "Message",
    "Alarm",
  ];
  List<int> remindList = [
    5,
    10,
    25,
    20,
  ];

  String _selectedRepeat = "none";
  List<String> repeatList = [
    "None",
    "Daily",
    "Weekly",
    "Monthly",
  ];
  int _selectedColor = 0;

  int _selectedRadius = 10;
  List<int> radiusList = [
    10,
    20,
    30,
    40,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.theme.backgroundColor,
      appBar: _appBar(context),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.only(left: 20, right: 20, top: 15, bottom: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Add Event", style: headingStyle,),
                  ElevatedButton(
                    onPressed: ()  {
                      //getCurrentLocation();
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => MapPage()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 7.0), // Adjust padding for larger size
                        textStyle: TextStyle(fontSize: 15.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14.0), // Adjust border radius to round the edges
                        ),
                        backgroundColor:Colors.purpleAccent,
                      foregroundColor: Colors.white
                    ),
                    child: Text('Set Event Location'),
                  ),
                ],),
              MyInputField(title: "Title", hint: "Enter your title", controller: _titleController,),
              MyInputField(title: "Event Description", hint: "Enter your note", controller: _noteController,),
              MyInputField(title: "Date",
                hint: DateFormat.yMd().format(_selectedDate),
                widget: IconButton(
                  onPressed: () {
                    print("object");
                    _getDateFromUser();
                  },
                  icon: Icon(
                    Icons.calendar_today_outlined,

                    color: Colors.grey,),

                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: MyInputField(
                      title: "Start Time",
                      hint: _startTime,
                      widget: IconButton(
                        onPressed: (){
                          _getTimeFromUser(isStartTime: true);
                        },
                        icon: Icon(
                          Icons.access_time_filled_rounded,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 12,),

                  Expanded(
                    child: MyInputField(
                      title: "End Time",
                      hint: _endTime,
                      widget: IconButton(
                        onPressed: (){
                          _getTimeFromUser(isStartTime: false);
                        },
                        icon: Icon(
                          Icons.access_time_filled_rounded,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              MyInputField(title: "Notification", hint: "$_selectedNotification reminder",
                widget: DropdownButton(
                  icon: Icon(Icons.keyboard_arrow_down,
                    color: Colors.grey,
                  ),
                  iconSize: 32,
                  elevation: 4,
                  style: subTitleStyle,
                  underline: Container(height: 0,),
                  onChanged: (String? newValue){
                    setState(() {
                      _selectedNotification = newValue!;
                    });
                  },
                  items: notificationList.map<DropdownMenuItem<String>>((String value){
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value, style: TextStyle(color: Colors.grey),),
                    );
                  }).toList(),
                ),
              ),

              MyInputField(title: "Radius", hint: "$_selectedRadius km radius",
                widget: DropdownButton(
                  icon: Icon(Icons.keyboard_arrow_down,
                    color: Colors.grey,
                  ),
                  iconSize: 32,
                  elevation: 4,
                  style: subTitleStyle,
                  underline: Container(height: 0,),
                  onChanged: (String? newValue){
                    setState(() {
                      _selectedRadius = int.parse(newValue!);
                    });
                  },
                  items: radiusList.map<DropdownMenuItem<String>>((int value){
                    return DropdownMenuItem<String>(
                      value: value.toString(),
                      child: Text(value.toString(), style: TextStyle(color: Colors.grey),),
                    );
                  }).toList(),
                ),
              ),

              MyInputField(title: "Remind",
                hint: "$_selectedRemind minutes early",
                widget: DropdownButton(
                  items: remindList
                      .map<DropdownMenuItem<String>>((int remindValue) {
                    return DropdownMenuItem<String>(
                      value: remindValue.toString(),
                      child: Text(remindValue.toString()),
                    );
                  }).toList(),
                  onChanged: (String? selectedValue) {
                    setState(() {
                      _selectedRemind = int.parse(selectedValue!);
                    });
                  },
                  icon: const Icon(
                    Icons.keyboard_arrow_down,
                    color: Colors.grey,
                  ),
                  iconSize: 32,
                  elevation: 5,
                  underline: Container(height: 0),
                  style: subTitleStyle,
                ),

              ),
              MyInputField(
                title: "Repeat",
                hint: _selectedRepeat,
                widget: DropdownButton(
                  items:
                  repeatList.map<DropdownMenuItem<String>>((String? value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(
                        value!,
                        style: const TextStyle(color: Colors.grey),
                      ),
                    );
                  }).toList(),
                  onChanged: (String? selectedValue) {
                    setState(() {
                      _selectedRepeat = selectedValue!;
                    });
                  },
                  icon: const Icon(
                    Icons.keyboard_arrow_down,
                    color: Colors.grey,
                  ),
                  iconSize: 32,
                  elevation: 5,
                  underline: Container(height: 0),
                  style: subTitleStyle,
                ),
              ),
              SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _colorPalette(),
                  ElevatedButton(
                    onPressed: () => _validateData(),
                    style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0), // Adjust padding for larger size
                        textStyle: TextStyle(fontSize: 20.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14.0), // Adjust border radius to round the edges
                        ),
                        backgroundColor:Colors.purple,
                      foregroundColor: Colors.white,
                    ),
                    child: Text('Save Event'),
                  ),
                  //button(label: "Create Task", onTap: ()=> _validateData())
                ],
              )
            ],
          ),

        ),
      ),
    );
  }

  _validateData() {
    if (_titleController.text.isNotEmpty && _noteController.text.isNotEmpty) {
      if (widget.task != null) {
        // If editing existing task, update it
        _updateTaskInDB();
      } else {
        // If creating new task, add it to database
        _addTaskToDB();
      }
      Get.back(); // Close page
    } else {
      Get.snackbar(
        "Required",
        "All fields are required !",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.white,
        colorText: Colors.purple,
        icon: Icon(Icons.warning_amber_rounded, color: Colors.red),
      );
    }
  }

  _addTaskToDB() async{
    int value = await _taskController.addTask(
        task:Task(
          note: _noteController.text,
          title: _titleController.text,
          date: DateFormat.yMd().format(_selectedDate),
          startTime: _startTime,
          endTime: _endTime,
          remind: _selectedRemind,
          repeat: _selectedRepeat,
          color: _selectedColor,
          isCompleted: 0,
        )
    );
    print("My id is " + "$value");
  }

  _updateTaskInDB() async {
    // Update task in database
    int value = await _taskController.updateTask(
      Task(
        id: widget.task!.id, // Keep the same ID
        note: _noteController.text,
        title: _titleController.text,
        date: DateFormat.yMd().format(_selectedDate),
        startTime: _startTime,
        endTime: _endTime,
        remind: _selectedRemind,
        repeat: _selectedRepeat,
        color: _selectedColor,
        isCompleted: 0,
      ),
    );
    print("Task updated");
    // Refresh task list
    _taskController.getTasks();
  }

  _colorPalette() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Color',
          style: titleStyle,
        ),
        const SizedBox(
          height: 8,
        ),
        Wrap(
            children: List.generate(3, (index) {
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedColor = index;
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: CircleAvatar(
                      radius: 14,
                      backgroundColor: index == 0
                          ? primaryClr
                          : index == 1
                          ? Colors.pink
                          : Colors.orange,
                      child: _selectedColor == index
                          ? const Icon(
                        Icons.done,
                        color: Colors.white,
                        size: 15,
                      )
                          : Container()),
                ),
              );
            }))
      ],
    );
  }

  _appBar(BuildContext context) {
    return AppBar(
      backgroundColor: context.theme.colorScheme.background,
      elevation: 0,
      leading: GestureDetector(
          onTap: () {
            Get.back();
          },
          child: Icon(
            Icons.arrow_back_ios_new,
            size: 20,
            color: Get.isDarkMode ? Colors.white : Colors.black,
          )),
      actions: const [
        CircleAvatar(
          backgroundImage: AssetImage("assets/images/pfp.jpg"),
        ),
        SizedBox(width: 20),
      ],
    );
  }

  _getDateFromUser() async {
    DateTime? pickerDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2020),
        lastDate: DateTime(2035));

    if (pickerDate != null) {
      setState(() {
        _selectedDate = pickerDate;
      });
    }
  }

  _getTimeFromUser({required bool isStartTime}) async {
    var pickedTime = await showTimePicker(
        initialEntryMode: TimePickerEntryMode.dial,
        context: context,
        initialTime: TimeOfDay(
            hour: int.parse(_startTime.split(":")[0]),
            minute: int.parse(_startTime.split(":")[1].split(" ")[0])));
    String formattedTime = pickedTime!.format(context);
    if (isStartTime) {
      setState(() {
        _startTime = formattedTime;
      });
    } else {
      setState(() {
        _endTime = formattedTime;
      });
    }
  }
  _showTimePicker() {
    return showTimePicker(
        initialEntryMode: TimePickerEntryMode.input,
        context: context,
        initialTime: TimeOfDay(
          // _startTime --> 10:30 AM
          hour: int.parse(_startTime.split(":")[0]),
          minute: int.parse(_startTime.split(":")[1].split(" ")[0]),
        )
    );
  }
}