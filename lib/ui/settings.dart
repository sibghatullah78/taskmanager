import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class settings extends StatefulWidget {
  const settings({super.key});

  @override
  State<settings> createState() => _settingsState();
}

class _settingsState extends State<settings> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Settings"),
        ),
        // backgroundColor: context.theme.backgroundColor,
        // appBar: _appBar(context),
        body: Container(
            margin: EdgeInsets.only(top:30, ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.person,
                        size:45,
                        color:Colors.blueAccent),
                    SizedBox(width: 20),
                    Text("Account",
                        style: TextStyle(
                          fontSize: 30, // Adjust the font size
                          fontWeight: FontWeight.bold, // Make the text bold
                        ))
                  ],),
                Divider(color: Colors.grey, thickness: 2, ),
                Container(
                  margin: EdgeInsets.only(left:60,top:20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Socials",
                          style: TextStyle(
                            fontSize: 20, // Adjust the font size
                            fontWeight: FontWeight.bold, // Make the text bold
                          )),
                      SizedBox(height: 20,),
                      Text("Change Password",
                          style: TextStyle(
                            fontSize: 20, // Adjust the font size
                            fontWeight: FontWeight.bold, // Make the text bold
                          )),
                      SizedBox(height: 20,),
                      Text("Contect Settings",
                          style: TextStyle(
                            fontSize: 20, // Adjust the font size
                            fontWeight: FontWeight.bold, // Make the text bold
                          )),
                      SizedBox(height: 20,),
                      Text("Privacy Policy",
                          style: TextStyle(
                            fontSize: 20, // Adjust the font size
                            fontWeight: FontWeight.bold, // Make the text bold
                          )),
                    ],
                  ),
                ),
                SizedBox(height: 50),
                Row(
                  children: [
                    Icon(Icons.app_settings_alt,
                        size:45,
                        color:Colors.blueAccent),
                    SizedBox(width: 20),
                    Text("App Settings",
                        style: TextStyle(
                          fontSize: 30, // Adjust the font size
                          fontWeight: FontWeight.bold, // Make the text bold
                        ))
                  ],),
                Divider(color: Colors.grey, thickness: 2, ),
                Container(
                  margin: EdgeInsets.only(left:60,top:20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("About",
                          style: TextStyle(
                            fontSize: 20, // Adjust the font size
                            fontWeight: FontWeight.bold, // Make the text bold
                          )),
                      SizedBox(height: 20,),
                      Text("Contact",
                          style: TextStyle(
                            fontSize: 20, // Adjust the font size
                            fontWeight: FontWeight.bold, // Make the text bold
                          )),
                      SizedBox(height: 20,),
                      Text("Privacy Policy",
                          style: TextStyle(
                            fontSize: 20, // Adjust the font size
                            fontWeight: FontWeight.bold, // Make the text bold
                          )),
                      SizedBox(height: 20,),
                      Text("Help & Support",
                          style: TextStyle(
                            fontSize: 20, // Adjust the font size
                            fontWeight: FontWeight.bold, // Make the text bold
                          )),
                      SizedBox(height: 20,),
                      Text("Theme Dark",
                          style: TextStyle(
                            fontSize: 20, // Adjust the font size
                            fontWeight: FontWeight.bold, // Make the text bold
                          )),
                      SizedBox(height: 20,),
                      Text("Account Active",
                          style: TextStyle(
                            fontSize: 20, // Adjust the font size
                            fontWeight: FontWeight.bold, // Make the text bold
                          )),
                    ],
                  ),

                ),

              ],
            )
        )
    );
  }
}