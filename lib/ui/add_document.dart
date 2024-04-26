import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';

// import 'package:firebase_core/firebase_core.dart';
// //import 'firebase_options.dart';


class addDocument extends StatefulWidget {
  const addDocument({super.key});
  @override
  State<addDocument> createState() => _addDocumentState();
}
class _addDocumentState extends State<addDocument> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Add Document"),
        ),
        body: SingleChildScrollView(
            child:  Container(
                margin: EdgeInsets.all(10.0),
                padding: EdgeInsets.all(10.0),
                child: Column( children: [
                  TextField(
                    decoration: InputDecoration(
                      labelText: 'Document Name',
                      border: UnderlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 16),
                  Row(
                    children: [
                      Text("Upload document", style: TextStyle(fontSize: 20)),
                      IconButton(
                        icon: Icon(Icons.add),
                        onPressed: () async {
                          FilePickerResult? result = await FilePicker.platform.pickFiles(
                            type: FileType.custom,
                            allowedExtensions: ['pdf', 'doc', 'docx', 'jpg', 'jpeg', 'png'],
                          );
                          if (result != null) {
                            File file = File(result.files.single.path!);
                            // Check the file type and handle accordingly
                            if (file.path.toLowerCase().endsWith('.pdf') ||
                                file.path.toLowerCase().endsWith('.doc') ||
                                file.path.toLowerCase().endsWith('.docx')) {
                              // Handle document upload
                            } else if (file.path.toLowerCase().endsWith('.jpg') ||
                                file.path.toLowerCase().endsWith('.jpeg') ||
                                file.path.toLowerCase().endsWith('.png')) {
                              // Handle image upload
                            } else {
                              // Unsupported file type
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: Text('Unsupported File Type'),
                                  content: Text('Please select a supported file type.'),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: Text('OK'),
                                    ),
                                  ],
                                ),
                              );
                            }
                          } else {
                            // User canceled the picker
                          }
                        },
                      ),
                    ],
                  )

                ],)

            )
        )

    );
  }
}
