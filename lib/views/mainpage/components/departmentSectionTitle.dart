import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/svg.dart';

class DepartementSectionTitle extends StatelessWidget {
  const DepartementSectionTitle(
      {super.key,
      required this.title,
      required this.subtitle,
      required this.quantity,
      required this.icon});
  final String title;
  final String subtitle;
  final String icon;

  final int quantity;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                    height: 30,
                    width: 30,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        color: Color(0xFF050403)),
                    child: Center(
                      child: SvgPicture.asset(
                        "assets/icons/${icon}.svg",
                        width: 13,
                      ),
                    )),
                SizedBox(
                  width: 10,
                ),
                Text("${title}",
                    style: GoogleFonts.roboto(fontWeight: FontWeight.w500)),
                SizedBox(
                  width: 10,
                ),
                Text("${this.subtitle}",
                    style: GoogleFonts.roboto(color: Colors.grey)),
              ],
            ),
          ),
          Row(
            children: [
              Text("${quantity}", style: GoogleFonts.roboto(color: Colors.grey)),
              GestureDetector(
                child: Icon(Icons.more_vert),
              )
            ],
          )
        ],
      ),
    );
  }
}
