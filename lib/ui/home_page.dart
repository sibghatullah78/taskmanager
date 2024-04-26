import 'package:date_picker_timeline/date_picker_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:is_fyp/controllers/task_controller.dart';
import 'package:is_fyp/services/notification_services.dart';
import 'package:is_fyp/services/theme_services.dart';
import 'package:is_fyp/ui/add_task_bar.dart';
import 'package:is_fyp/ui/profile_provider.dart';
import 'package:is_fyp/ui/settings.dart';
import 'package:is_fyp/ui/theme.dart';
import 'package:is_fyp/ui/widgets/button.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:flutter/painting.dart';
import 'package:is_fyp/ui/widgets/task_tile.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import '../Authentication/login.dart';
import '../models/task.dart';
import '../models/userProfile.dart';
import 'add_document.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DateTime _selectedDate = DateTime.now();
  final _taskController = Get.put(TaskController());
  var notifyHelper;
  @override
  void initState(){
    super.initState();
    notifyHelper= NotifyHelper();
    notifyHelper.initializeNotification();
    notifyHelper.requestIOSPermissions();
  }

  @override
  Widget build(BuildContext context) {
    print("build method called");
    return Scaffold(
      appBar: _appBar(context),
      drawer: DrawerWidget(),
      backgroundColor: context.theme.backgroundColor,
      body: Column(
        children: [
          _addEventbar(),
          _addDateBar(),
          SizedBox(height: 10,),
          _showTasks(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Get.to(() => AddTaskPage());
          _taskController.getTasks();
        },
        tooltip: 'Add Task',
        child: Icon(Icons.add, size: 40,),
      ),
    );
  }

  _showTasks() {
    return Expanded(child: Obx((){
      return ListView.builder(
          itemCount: _taskController.taskList.length,
          itemBuilder: (_, index){
            Task task = _taskController.taskList[index];
            print(task.toJson());
            if(task.repeat == 'Daily') {
              DateTime date;
              try {
                date = DateFormat("h:mm a").parse(task.startTime.toString());
              } catch (e) {
                print("Error parsing time: $e");
                return Container(); // Handle error gracefully
              }
              var myTime = DateFormat("HH:mm").format(date);
              notifyHelper.scheduledNotification(
                  int.parse(myTime.toString().split(":")[0]),
                  int.parse(myTime.toString().split(":")[1]),
                  task
              );
              print(myTime);
              return AnimationConfiguration.staggeredList(
                  position: index,
                  child: SlideAnimation(
                      child: FadeInAnimation(child: Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              _showBottomSheet(context, task);
                            },
                            child: TaskTile(task),
                          )
                        ],
                      )
                      )
                  )
              );
            }
            if (task.date == DateFormat.yMd().format(_selectedDate)){
              return AnimationConfiguration.staggeredList(
                  position: index,
                  child: SlideAnimation(
                      child: FadeInAnimation(child: Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              _showBottomSheet(context, task);
                            },
                            child: TaskTile(task),
                          )
                        ],
                      )
                      )
                  )
              );
            }else{
              return Container();
            }
          });
    }),
    );
  }

  _showBottomSheet(BuildContext context, Task task) {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.only(top: 5),
        height: task.isCompleted==1?
        MediaQuery.of(context).size.height*0.24:
        MediaQuery.of(context).size.height*0.24,
        color: Get.isDarkMode?darkGreyClr:Colors.white,
        child: Column(
          children: [
            Container(
              height: 6,
              width: 120,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Get.isDarkMode?Colors.grey[600]:Colors.grey[300],
              ),
            ),
            Spacer(),
            task.isCompleted==1
                ?Container()
                : _bottomSheetButton(label: "Task Completed",
              onTap:() {
                _taskController.markTaskCompleted(task.id!);
                Get.back();
              },
              clr: primaryClr,
              context: context,
            ),
            _bottomSheetButton(
              label: "Delete Task",
              onTap:() {
                _taskController.delete(task);
                Get.back();
              },
              clr: Colors.red[300]!,
              context: context,
            ),
            _bottomSheetButton(
              label: "Edit Task",
              onTap:() {
                Get.back();
                _editTask(task);
              },
              clr: Colors.green!,
              isClose: true,
              context: context,
            ),
          ],
        ),
      ),
      ).then((value) {
        // Refresh task list after bottom sheet is closed
        _taskController.getTasks();
      });
  }

  _editTask(Task task) {
    Get.to(() => AddTaskPage(task: task));
  }

  _bottomSheetButton({
    required String label,
    required Function()? onTap,
    required Color clr,
    bool isClose =  false,
    required BuildContext context,
  }) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 2),
          height: 50,
          width: MediaQuery.of(context).size.width*0.9,
          decoration: BoxDecoration(
            border: Border.all(
                width: 2,
                color:isClose==true?Get.isDarkMode?Colors.grey[600]!:Colors.grey[300]!:clr
            ),
            borderRadius: BorderRadius.circular(20),
            color: isClose == true? Colors.transparent:clr,
          ),

          child: Center(
            child: Text(
              label,
              style: isClose?titleStyle:titleStyle.copyWith(color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }

  _addDateBar() {
    return Container(
      margin: const EdgeInsets.only(top: 20, left: 20),
      child: DatePicker(
        DateTime.now(),
        height: 100,
        width: 80,
        initialSelectedDate: DateTime.now(),
        selectionColor: primaryClr,
        selectedTextColor: Colors.white,
        dateTextStyle: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: Colors.grey,
        ),
        dayTextStyle: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: Colors.blueGrey,
        ),
        monthTextStyle: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: Colors.blueGrey,
        ),
        onDateChange: (date) {
          setState(() {
            _selectedDate = date;
          });
        },
      ),
    );
  }

  _addEventbar() {
    return Container(
      margin: const EdgeInsets.only(left: 20, right: 20, top: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  DateFormat.yMMMMd().format(DateTime.now()),
                  style: subheadingStyle,
                ),
                Text(
                  "Today",
                  style: headingStyle,
                )
              ],
            ),
          ),
          ElevatedButton.icon(
            onPressed: () async {
              // await Get.to(()=>AddTaskPage());
              // _taskController.getTasks(); } )
            },
            icon: Icon(Icons.location_on),
            label: Text('Live Location'),
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
              textStyle: TextStyle(fontSize: 20.0,),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14.0),
              ),
              backgroundColor: Colors.purple,
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }


  _appBar(BuildContext scaffoldContext) {
    return AppBar(
      elevation: 0,
      backgroundColor: context.theme.backgroundColor,
    leading: Builder(
      builder: (context) => IconButton(
        onPressed: () {
          Scaffold.of(context).openDrawer();
        },
        icon: Icon(Icons.person, size: 40,),
      ),
    ),
      actions: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: GestureDetector(
            onTap: () {
              ThemeServices().switchTheme();
              notifyHelper.displayNotification(
                title:"Theme Changed",
                body: Get.isDarkMode? "Activated Light Mode":"Activated Dark Mode",
              );
              notifyHelper.scheduledNotification();
            },
            child: Icon(
              Get.isDarkMode ? Icons.sunny : Icons.nightlight_round,
              size: 30,
              color: Get.isDarkMode ? Colors.white : Colors.black,
            ),
          ),
        ),
      ],
    );
  }
}

class DrawerWidget extends StatefulWidget {
  const DrawerWidget({Key? key}) : super(key: key);

  @override
  _DrawerWidgetState createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<DrawerWidget> {
  late TextEditingController _nameController;
  late TextEditingController _designationController;
  late TextEditingController _emailController;

  late String name = '';
  late String designation = '';
  late String email = '';


  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _designationController = TextEditingController();
    _emailController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _designationController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 10.0),
        child: Column(
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
              ),
              child: CircleAvatar(
                radius: 70,
                child: ClipOval(
                  child: Image.asset(
                    "assets/profile.png",
                    fit: BoxFit.cover,
                    width: 120,
                    height: 120,
                  ),
                ),
              ),
            ),

            ListTile(
              leading: Text(
                "Name:",
                style: TextStyle(fontSize: 20,),
              ),
              title: Text(
                name,
                style: TextStyle(fontSize: 20,),
              ),
            ),

            ListTile(
              leading: Text(
                "Designation:",
                style: TextStyle(fontSize: 20,),
              ),
              title: Text(
                designation,
                style: TextStyle(fontSize: 20,),
              ),
            ),

            ListTile(
              leading: Text(
                "Email:",
                style: TextStyle(fontSize: 20,),
              ),
              title: Text(
                email,
                style: TextStyle(fontSize: 20,),
              ),
            ),

            ListTile(
              leading: Text("Documents", style: TextStyle(fontSize: 20)),
              trailing: IconButton(
                icon: Icon(Icons.add),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => addDocument(),
                    ),
                  );
                },
              ),
            ),
            ListTile(
              leading: Text("Settings", style: TextStyle(fontSize: 20)),
              trailing: IconButton(
                icon: Icon(Icons.settings),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => settings(),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 20,),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: ElevatedButton(
                onPressed: () => _showEditProfileDialog(context),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 40.0),
                  textStyle: TextStyle(fontSize: 20.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14.0),
                  ),
                  backgroundColor: Colors.purpleAccent,
                  foregroundColor: Colors.white,
                ),
                child: Text('Edit Profile'),
              ),
            ),
            Spacer(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: ElevatedButton(
                onPressed: () => LoginScreen(),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 40.0),
                  textStyle: TextStyle(fontSize: 20.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14.0),
                  ),
                  backgroundColor: Colors.purpleAccent,
                  foregroundColor: Colors.white,
                ),
                child: Text('Logout'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showEditProfileDialog(BuildContext context) {
    final userProfileProvider = Provider.of<UserProfileProvider>(context, listen: false);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit Profile'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Name'),
                onChanged: (value) => name = value,
              ),
              TextField(
                controller: _designationController,
                decoration: InputDecoration(labelText: 'Designation'),
                onChanged: (value) => designation = value,
              ),
              TextField(
                controller: _emailController,
                decoration: InputDecoration(labelText: 'Email'),
                onChanged: (value) => email = value,
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                String newName = _nameController.text;
                String newDesignation = _designationController.text;
                String newEmail = _emailController.text;

                final userProfile = UserProfile(name: newName, designation: newDesignation, email: newEmail);
                userProfileProvider.setUserProfile(userProfile);

                name = newName;
                designation = newDesignation;
                email = newEmail;

                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }

}
