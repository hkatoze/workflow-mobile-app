import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ButtonWithoutIcon extends StatelessWidget {
  const ButtonWithoutIcon(
      {super.key,
      required this.title,
      required this.bgColor,
      required this.titleColor,
       this.onPressed});
  final String title;
  final VoidCallback? onPressed;
  final Color bgColor;
  final Color titleColor;

  @override
  Widget build(BuildContext context) {

    return Container(
      child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            primary: bgColor, // couleur de fond
            onPrimary: Colors.white, // couleur du texte
            side: BorderSide(
                color: Colors.white,
                width: 0.5), // couleur et largeur de la bordure
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
          onPressed: onPressed,
          child: Container(
            margin: EdgeInsets.all(15),
            child: Text(
              "${title} ",
              textAlign: TextAlign.center,
              style: GoogleFonts.roboto(
                  fontWeight: FontWeight.w600, color: titleColor, fontSize: 20),
            ),
          )),
    );
  }
}
