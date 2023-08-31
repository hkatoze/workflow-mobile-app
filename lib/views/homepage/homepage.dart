import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workflow/views/homepage/components/homecarditem.dart';
import 'package:page_transition/page_transition.dart';
import '../../services/apiservices.dart';

import 'package:workflow/views/mainpage/mainpage.dart';

class Homepage extends StatefulWidget {
  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  String page = "home";
  String username = '';
  String grade = '';
  String department = '';
  String companyId = '';
  String maxAmount = '';
  String email = '';
  int purchaseRequisitionLength = 0;
  void initState() {
    super.initState();
    _getCredentials();
  }

  Future<void> _getCredentials() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      username = prefs.getString('username')!;
      grade = prefs.getString('grade')!;
      department = prefs.getString('department')!;
      companyId = prefs.getString('companyId')!;
      maxAmount = prefs.getString('maxAmount')!;
      email = prefs.getString('email')!;
    });

    getRequisitions(companyId, department, maxAmount).then((value) {
      setState(() {
        purchaseRequisitionLength = value.length;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    double currentHeight = MediaQuery.of(context).size.height;
    return Container(
      color: Color(0XFFf9cf64),
      child: Column(children: [
        Expanded(
            child: Container(
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image:
                            AssetImage("assets/images/home-background.PNG"))))),
        Container(
          height: currentHeight * 0.55,
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30), topRight: Radius.circular(30))),
          child: Container(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          PageTransition(
                              type: PageTransitionType.scale,
                              alignment: Alignment.bottomCenter,
                              duration: Duration(milliseconds: 200),
                              childCurrent: Homepage(),
                              reverseDuration: Duration(milliseconds: 200),
                              child: Mainpage(page: "requisition")));
                    },
                    child: HomecardItem(
                        blocked: false,
                        color: Color.fromARGB(255, 243, 223, 173),
                        number: purchaseRequisitionLength,
                        wording: "Requisitions"),
                  ),
                  GestureDetector(
                    onTap: () {
                      Fluttertoast.showToast(
                          msg: "LOCK MODULE",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Colors.grey,
                          textColor: Colors.white,
                          fontSize: 16.0);
                      /* Navigator.push(
                          context,
                          PageTransition(
                              type: PageTransitionType.scale,
                              alignment: Alignment.bottomCenter,
                              duration: Duration(milliseconds: 200),
                              childCurrent: Homepage(),
                              reverseDuration: Duration(milliseconds: 200),
                              child: Mainpage(page: "invoice"))); */
                    },
                    child: HomecardItem(
                        blocked: true,
                        color: Color.fromARGB(255, 203, 189, 241),
                        number: 0,
                        wording: "Invoices"),
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {
                      /*    Navigator.push(
                          context,
                          PageTransition(
                              type: PageTransitionType.scale,
                              alignment: Alignment.bottomCenter,
                              duration: Duration(milliseconds: 200),
                              childCurrent: Homepage(),
                              reverseDuration: Duration(milliseconds: 200),
                              child: Mainpage(page: "requisition"))); */

                      Fluttertoast.showToast(
                          msg: "LOCK MODULE",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Colors.grey,
                          textColor: Colors.white,
                          fontSize: 16.0);
                    },
                    child: HomecardItem(
                        blocked: true,
                        color: Color.fromARGB(255, 50, 243, 108),
                        number: purchaseRequisitionLength,
                        wording: "Orders"),
                  ),
                 
                ],
              )
            ],
          )),
        )
      ]),
    );
  }
}
