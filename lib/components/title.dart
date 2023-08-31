import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


class AppTitle extends StatelessWidget {
  const AppTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return    Container(
                child: Column(children: [
                  Text(
                    "WORKFLOW",
                    style: GoogleFonts.roboto(
                        color: Color(0XFF6e78f7), fontSize: 35),
                  ),
                  Text(
                    "Approval 2.0",
                    textAlign: TextAlign.end,
                    style: GoogleFonts.roboto(
                        color: Color(0XFF6e78f7), fontSize: 15),
                  )
                ]),
              );
  }
}