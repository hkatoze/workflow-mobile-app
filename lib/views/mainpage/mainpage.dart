import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workflow/passerel.dart';
import 'package:workflow/services/apiservices.dart';
import 'package:workflow/views/homepage/homepage.dart';

import 'package:workflow/views/requisitionsPage/requisitionsPage.dart';

class Mainpage extends StatefulWidget {
  Mainpage({Key? key, required this.page});
  final String page;
  @override
  State<Mainpage> createState() => _MainpageState();
}

class _MainpageState extends State<Mainpage> {
  final GlobalKey<ScaffoldState> _scaffoldkey = new GlobalKey();

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
    page = widget.page;
    _getCredentials();
  }

  void callback(String page) {
    setState(
      () {
        page = "${page}";
      },
    );
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

  Future<void> _logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('email', '');

    Navigator.push(
        context,
        PageTransition(
            type: PageTransitionType.leftToRightJoined,
            duration: Duration(milliseconds: 200),
            childCurrent: Mainpage(
              page: "home",
            ),
            reverseDuration: Duration(milliseconds: 200),
            child: Passerell()));

    print("LOGOUT");
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: Scaffold(
            key: _scaffoldkey,
            extendBodyBehindAppBar: true,
            drawer: Drawer(
                backgroundColor: Color(0xFFe7e7fe).withOpacity(0.8),
                child: Column(
                  children: [
                    UserAccountsDrawerHeader(
                      accountName: Text("${username}"),
                      accountEmail: Text("${department} ${grade}"),
                      currentAccountPicture: CircleAvatar(
                        backgroundColor: Color(0xFFe7e7fe),
                        child: Container(
                            child:
                                Image.asset("assets/images/workflow-logo.png")),
                      ),
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage(
                            "assets/images/android-drawer-bg.jpeg",
                          ),
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                    ListTile(
                      leading: CircleAvatar(
                        child: Icon(
                          Icons.home,
                          color: Colors.black,
                        ),
                        backgroundColor: Color(0XFFf9cf64),
                      ),
                      title: Text(
                        "Home",
                        style: TextStyle(fontSize: 18),
                      ),
                      onTap: () {
                        setState(
                          () {
                            page = "home";
                          },
                        );
                        Navigator.pop(context);
                      },
                    ),
                    ListTile(
                      leading: CircleAvatar(
                        child: Icon(
                          Icons.local_grocery_store,
                          color: Colors.black,
                        ),
                        backgroundColor: Color(0XFFf9cf64),
                      ),
                      title: Text(
                        "Purchase Requisitions",
                        style: TextStyle(fontSize: 18),
                      ),
                      trailing: Text(
                        "${purchaseRequisitionLength}",
                        style: TextStyle(
                            fontSize: 18,
                            color: Color(0xFF8359f6),
                            fontWeight: FontWeight.bold),
                      ),
                      onTap: () {
                        setState(() {
                          page = "requisition";
                        });
                        Navigator.pop(context);
                      },
                    ),
                    ListTile(
                      leading: CircleAvatar(
                        child: Icon(
                          Icons.assignment,
                          color: Colors.black,
                        ),
                        backgroundColor: Color(0XFFf9cf64),
                      ),
                      title: Text(
                        "Invoices",
                        style: TextStyle(fontSize: 18),
                      ),
                      trailing: Icon(Icons.lock),
                      onTap: () {
                        /*        setState(
                          () {
                            page = "invoice";
                          },
                        );
                        Navigator.pop(context); */

                        Fluttertoast.showToast(
                            msg: "LOCK MODULE",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            timeInSecForIosWeb: 1,
                            backgroundColor: Colors.grey,
                            textColor: Colors.white,
                            fontSize: 16.0);
                      },
                    ),
                    ListTile(
                      leading: CircleAvatar(
                        child: Icon(
                          Icons.bookmark,
                          color: Colors.black,
                        ),
                        backgroundColor: Color(0XFFf9cf64),
                      ),
                      title: Text(
                        "Purchase Orders",
                        style: TextStyle(fontSize: 18),
                      ),
                      trailing: Icon(Icons.lock),
                      onTap: () {
                        /* setState(
                          () {
                            page = "invoice";
                          },
                        );
                        Navigator.pop(context); */

                        Fluttertoast.showToast(
                          msg: "LOCK MODULE",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Colors.grey,
                          textColor: Colors.white,
                          fontSize: 16.0);
                      },
                    ),
                    Expanded(child: Container()),
                    Container(
                      margin:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                              onTap: () {
                                setState(
                                  () {
                                    page = "options";
                                  },
                                );
                                Navigator.pop(context);
                              },
                              child: Container(
                                child: Row(children: [
                                  Icon(Icons.settings),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                    "Options",
                                    style: TextStyle(fontSize: 17),
                                  )
                                ]),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                _logout();
                              },
                              child: Container(
                                child: Row(children: [
                                  Icon(Icons.logout),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                    "Log out",
                                    style: TextStyle(fontSize: 17),
                                  )
                                ]),
                              ),
                            )
                          ]),
                    )
                  ],
                )),
            appBar: AppBar(
              backgroundColor: Color(0XFFf9cf64),
              leading: GestureDetector(
                onTap: () {
                  _scaffoldkey.currentState!.openDrawer();
                },
                child: Icon(
                  Icons.menu,
                  size: 30,
                  color: Colors.black,
                ),
              ),
              title: Text(
                page == "home"
                    ? "Home"
                    : (page == "invoice"
                        ? "Invoices"
                        : (page == "requisition"
                            ? "Purchase requisitions"
                            : "Options")),
                style: GoogleFonts.roboto(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    color: Colors.black),
              ),
              centerTitle: true,
            ),
            body: page == "home"
                ? Homepage()
                : (page == "invoice"
                    ? Container(
                        color: Colors.white,
                      )
                    : (page == "requisition"
                        ? PurchaseRequisitionPage(
                            companyId: companyId,
                            department: department,
                            maxAmount: maxAmount,
                            email: email,
                          )
                        : Container(
                            color: Colors.white,
                          )))),
        onWillPop: () async {
          if (page == "requisition") {
            Navigator.push(
                context,
                PageTransition(
                    type: PageTransitionType.scale,
                    alignment: Alignment.topCenter,
                    duration: Duration(milliseconds: 200),
                    childCurrent: Mainpage(
                      page: "requisition",
                    ),
                    reverseDuration: Duration(milliseconds: 200),
                    child: Mainpage(
                      page: "home",
                    )));
          }

          if (page == "invoice") {
            Navigator.push(
                context,
                PageTransition(
                    type: PageTransitionType.scale,
                    alignment: Alignment.topCenter,
                    duration: Duration(milliseconds: 200),
                    childCurrent: Mainpage(
                      page: "invoice",
                    ),
                    reverseDuration: Duration(milliseconds: 200),
                    child: Mainpage(
                      page: "home",
                    )));
          }
          return false;
        });
  }
}
