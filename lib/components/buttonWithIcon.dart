import 'package:flutter/material.dart';

class ButtonWithIcon extends StatelessWidget {
  const ButtonWithIcon(
      {super.key,
      required this.icon,
      required this.title,
      required this.bgColor,
      required this.onPressed});

  final VoidCallback onPressed;
  final String title;
  final IconData icon;
  final Color bgColor;

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
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
          ),
          onPressed: onPressed,
          child: Container(
            margin: EdgeInsets.all(15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "${title} ",
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 17),
                ),
                Icon(
                  icon,
                  size: 17,
                )
              ],
            ),
          )),
    );
  }
}
