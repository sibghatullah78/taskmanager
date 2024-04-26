import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NotifiedPage extends StatelessWidget {
  final String? label;
  const NotifiedPage({super.key,required this.label});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(label.toString().split("|")[0],
          style: const TextStyle(color: Colors.black),
        ),
        backgroundColor: Get.isDarkMode?Colors.grey[600]:Colors.white,
        leading: IconButton(
            onPressed: (){
              Get.back();
            },
            icon: Icon(Icons.arrow_back_ios_new,
              color: Get.isDarkMode?Colors.white:Colors.grey,
            )
        ),
      ),
      body: Center(
        child: Container(
          alignment: Alignment.center,
          height: 400,
          width: 300,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Get.isDarkMode?Colors.white:Colors.purpleAccent,
          ),
          child: Text(label.toString().split("|")[1],
            style: TextStyle(
              fontSize: 25,
              color: Get.isDarkMode?Colors.black:Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
