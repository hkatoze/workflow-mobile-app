import 'package:flutter/material.dart';

import 'package:page_transition/page_transition.dart';
import 'package:workflow/components/buttonWithIcon.dart';
import 'package:workflow/components/title.dart';
import 'package:workflow/views/loginpage/loginpage.dart';

class Startpage extends StatefulWidget {
  const Startpage({
    super.key,
  });

  @override
  State<Startpage> createState() => _StartpageState();
}

class _StartpageState extends State<Startpage> {
  @override
  Widget build(BuildContext context) {
 
    double currentHeight = MediaQuery.of(context).size.height;
    return Scaffold(
        body: Container(
      height: currentHeight,
      decoration: BoxDecoration(
        color: Color(0XFFf6f8fb),
      ),
      child: Column(
        children: [
          SizedBox(height: currentHeight * 0.08),
          Container(
            child: Column(children: [
           AppTitle()
            ]),
          ),
          Expanded(
              child: Container(
            decoration: BoxDecoration(
                image: DecorationImage(
                    fit: BoxFit.cover,
                    image: AssetImage("assets/images/background.PNG"))),
            child: Column(
              children: [
                SizedBox(
                  height: currentHeight * 0.73,
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(),
                      ButtonWithIcon(
                          icon: Icons.arrow_forward,
                          onPressed: () {
                            Navigator.push(
                                context,
                                PageTransition(
                                    type: PageTransitionType.rightToLeftJoined,
                                    duration: Duration(milliseconds: 200),
                                    childCurrent: Startpage(),
                                    reverseDuration:
                                        Duration(milliseconds: 200),
                                    child: Loginpage()));
                          },
                          title: "Get started",
                          bgColor: Color(0XFFfc9296)),
                    ],
                  ),
                )
              ],
            ),
          ))
        ],
      ),
    ));
  }
}
