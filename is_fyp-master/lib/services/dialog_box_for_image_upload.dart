import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


class CameraGallerUploadingIcons extends StatelessWidget {
  const CameraGallerUploadingIcons({
    super.key,
    required this.icon,
    required this.txt,
  });
  final IconData icon;
  final String txt;
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: BorderRadius.circular(9)),
          child: Icon(
            icon,
            size: 27,
            color: Colors.white,
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        Text(
          txt,
          style: GoogleFonts.lato(
            fontSize: 16,
            color: Colors.black87,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
