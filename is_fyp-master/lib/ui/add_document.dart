import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../SQLite/sqlite.dart'; // Import image_picker package

class Document {
  final String? name;
  final String? description;
  final String? imagePath;


  Document({required this.name, required this.description, required this.imagePath});
}

class AddDocument extends StatefulWidget {
  const AddDocument({Key? key, required this.document}) : super(key: key);

  final Document document;

  @override
  State<StatefulWidget> createState() => _AddDocumentState();

}

class _AddDocumentState extends State<AddDocument> {
  TextEditingController nameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  String? imagePath;

  void addDocument() async{
    if (nameController.text.isNotEmpty &&
        descriptionController.text.isNotEmpty &&
        imagePath != null) {
      setState(() {
        Document newDocument = Document(
          name: nameController.text,
          description: descriptionController.text,
          imagePath: imagePath!,
        );
        // Add the new document to the list or save it as needed
      });
    }
    await DatabaseHelper().insertImage(imagePath!);

    setState(() {
      // Add the new document to the list or save it as needed
    });
  }

  Future<void> _getImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.getImage(source: source);
    if (pickedFile != null) {
      saveImage(pickedFile.path); // Save the selected image path
    }
  }

  void saveImage(String imagePath) {
    setState(() {
      this.imagePath = imagePath;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Document"),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.all(10.0),
          padding: EdgeInsets.all(10.0),
          child: Column(
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: 'Document Name',
                  border: UnderlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),
              TextField(
                controller: descriptionController,
                decoration: InputDecoration(
                  labelText: 'Description',
                  border: UnderlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),
              Text(
                "Upload Documents",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      _getImage(ImageSource.camera); // Open camera
                    },
                    child: CameraGalleryUploadingIcons(
                      icon: Icons.camera_alt_outlined,
                      txt: "Camera",
                      color: Colors.green, // Custom color
                      size: 64.0,
                      saveImage: saveImage, // Pass the function here
                    ),
                  ),
                  SizedBox(width: 20),
                  GestureDetector(
                    onTap: () {
                      _getImage(ImageSource.gallery); // Open gallery
                    },
                    child: CameraGalleryUploadingIcons(
                      icon: Icons.image,
                      txt: "Gallery",
                      color: Colors.orange, // Custom color
                      size: 64.0, // Custom size
                      saveImage: saveImage, // Pass the function here
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  addDocument();
                  // Clear text fields and image path after adding document
                  nameController.clear();
                  descriptionController.clear();
                  setState(() {
                    imagePath = null;
                  });
                },
                child: Text('Save Document'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CameraGalleryUploadingIcons extends StatelessWidget {
  final IconData icon;
  final String txt;
  final Color color;
  final double size;
  final Function(String) saveImage;

  const CameraGalleryUploadingIcons({
    required this.icon,
    required this.txt,
    this.color = Colors.blue, // Default color
    this.size = 48.0, // Default size
    required this.saveImage,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
      ),
      child: Center(
        child: Icon(
          icon,
          color: Colors.white,
          size: size * 0.6, // Adjust icon size based on box size
        ),
      ),
    );
  }
}
