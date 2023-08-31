import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/config.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workflow/components/buttonWithoutIcon.dart';
import 'package:workflow/components/title.dart';
import 'package:workflow/views/mainpage/mainpage.dart';
import 'package:workflow/views/signuppage/signuppage.dart';

import '../../services/apiservices.dart';

class Loginpage extends StatefulWidget {
  const Loginpage({super.key});

  @override
  State<Loginpage> createState() => _LoginpageState();
}

class _LoginpageState extends State<Loginpage> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _companyIdcontroller = TextEditingController();
  ZoomDrawerController zoomDrawerController = ZoomDrawerController();

  String? _email, _password, _companyId;
  bool rememberMe = true;
  bool isLogin = false;

  void initState() {
    super.initState();

    _getCredentials();
  }

  Future<void> _getCredentials() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _emailController.text = prefs.getString('email') ?? '';
      _passwordController.text = prefs.getString('password') ?? '';
      _companyIdcontroller.text = prefs.getString('companyId') ?? '';
    });
  }

  void login() async {
    if (_formKey.currentState!.validate()) {
       if(_companyIdcontroller.text !=''){
         SharedPreferences prefs = await SharedPreferences.getInstance();
      _formKey.currentState!.save();
      setState(() {
        isLogin = true;
      });

      String isAuthenticated = await checkCredentials(
          _email!, _password!, _companyIdcontroller.text);

      if (isAuthenticated == "Authentification réussie.") {
        
     

        var response = await getRequisitions(prefs.getString('companyId')!,
            prefs.getString('department')!, prefs.getString('maxAmount')!);
        await prefs.setInt('oldRequisitionLength', response.length);
        Fluttertoast.showToast(
            msg: "You are connected !",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.green,
            textColor: Colors.white,
            fontSize: 16.0);

        
           
        Navigator.push(
            context,
            PageTransition(
                type: PageTransitionType.rightToLeftJoined,
                duration: Duration(milliseconds: 200),
                childCurrent: Loginpage(),
                reverseDuration: Duration(milliseconds: 200),
                child: Mainpage(
                  page: "home",
                )));

        setState(() {
          isLogin = false;
        });
      } else if (isAuthenticated == "Mot de passe incorrect.") {
        setState(() {
          isLogin = false;
        });

        Fluttertoast.showToast(
            msg: "Your password is incorrect.",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
      } else if (isAuthenticated == "L'utilisateur n'existe pas.") {
        setState(() {
          isLogin = false;
        });

        Fluttertoast.showToast(
            msg: "This email address is not registered.",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
      } else {
        setState(() {
          isLogin = false;
        });

        Fluttertoast.showToast(
            msg: "Server connection error.",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
      }
       }else{
        Fluttertoast.showToast(
            msg: "Enter Company ID please",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
       }
    }
  }

  Future<String> checkCredentials(
      String username, String password, String companyId) async {
    final response = await loginAPI(username, password, companyId);

    return response;
  }

  @override
  Widget build(BuildContext context) {
    double currentWidth = MediaQuery.of(context).size.width;
    double currentHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: ZoomDrawer(
          controller: zoomDrawerController,
          style: DrawerStyle.defaultStyle,
          drawerShadowsBackgroundColor: Color.fromARGB(0, 240, 239, 239),
          showShadow: true,
          borderRadius: 40.0,
          mainScreenTapClose: true,
          angle: 0.0,
          isRtl: true,
          duration: Duration(milliseconds: 500),
          reverseDuration: Duration(milliseconds: 500),
          openCurve: Curves.fastOutSlowIn,
          closeCurve: Curves.fastOutSlowIn,
          menuBackgroundColor: Color(0XFFf9cf64),
          slideWidth: MediaQuery.of(context).size.width * 0.65,
          moveMenuScreen: true,
          menuScreen: Builder(
              builder: (context) => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: currentHeight * 0.15,
                      ),
                      Container(
                        width: double.infinity,
                        padding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                        decoration: BoxDecoration(color: Color(0xFF8359f6)),
                        child: Text(
                          "ORDERING PORTAL CONFIGURATION",
                          style: TextStyle(color: Colors.white, fontSize: 13),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(
                          vertical: 10,
                        ),
                        padding: const EdgeInsets.all(10),
                        decoration: const BoxDecoration(
                          color: Color(0xFFecf1fc),
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                        child: Row(
                          children: [
                            Container(
                                padding: EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                  color: Color(0xFFecf1fc),
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(10)),
                                ),
                                child: Icon(
                                  Icons.account_balance,
                                  color: Color(0XFF784af5).withOpacity(0.7),
                                )),
                            const SizedBox(width: 14),
                            Container(
                              width: MediaQuery.of(context).size.width * 0.3,
                              child: TextFormField(
                                controller: _companyIdcontroller,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return "Enter your Company ID";
                                  }
                                  return null;
                                },
                                onSaved: (value) => _companyId = value!,
                                keyboardType: TextInputType.emailAddress,
                                textInputAction: TextInputAction.next,
                                style: GoogleFonts.roboto(
                                    color: Color(0XFF535580),
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold),
                                decoration: InputDecoration(
                                    hintText: "Company ID",
                                    border: InputBorder.none,
                                    hintStyle: TextStyle(
                                        color: Colors.grey, fontSize: 15)),
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  )),
          mainScreen: SingleChildScrollView(
              child: Container(
            height: currentHeight,
            decoration: BoxDecoration(
                image: DecorationImage(
                    fit: BoxFit.cover,
                    image: AssetImage("assets/images/login-background.PNG"))),
            child: Column(
              children: [
                SizedBox(
                  height: currentHeight * 0.05,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(),
                    GestureDetector(
                        onTap: () {
                          zoomDrawerController.toggle?.call();
                        },
                        child: Container(
                          width: 50,
                          height: 50,
                          color: Color(0xFFf6f8fb),
                          child: Icon(
                            Icons.settings,
                            size: 35,
                          ),
                        ))
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(),
                    Container(
                      width: currentWidth * 0.93,
                      child: Material(
                          borderRadius: BorderRadius.circular(25),
                          elevation: 2,
                          child: Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: currentHeight * 0.05),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [],
                                color: Colors.white,
                              ),
                              child: Form(
                                  key: _formKey,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      AppTitle(),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      Container(
                                        margin: EdgeInsets.symmetric(
                                            vertical: 10, horizontal: 10),
                                        padding: const EdgeInsets.all(10),
                                        decoration: const BoxDecoration(
                                          color: Color(0xFFecf1fc),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10)),
                                        ),
                                        child: Row(
                                          children: [
                                            Container(
                                                padding: EdgeInsets.all(5),
                                                decoration: BoxDecoration(
                                                  color: Color(0xFFecf1fc),
                                                  borderRadius:
                                                      const BorderRadius.all(
                                                          Radius.circular(10)),
                                                ),
                                                child: Icon(
                                                  Icons.person,
                                                  color: Color(0XFF784af5)
                                                      .withOpacity(0.7),
                                                )),
                                            const SizedBox(width: 14),
                                            Container(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.6,
                                              child: TextFormField(
                                                controller: _emailController,
                                                validator: (value) {
                                                  if (value!.isEmpty) {
                                                    return "Enter your email address";
                                                  }
                                                  return null;
                                                },
                                                onSaved: (value) =>
                                                    _email = value,
                                                keyboardType:
                                                    TextInputType.emailAddress,
                                                textInputAction:
                                                    TextInputAction.next,
                                                style: GoogleFonts.roboto(
                                                    color: Color(0XFF535580),
                                                    fontSize: 18,
                                                    fontWeight:
                                                        FontWeight.bold),
                                                decoration: InputDecoration(
                                                    hintText: "Email",
                                                    border: InputBorder.none,
                                                    hintStyle: TextStyle(
                                                        color: Colors.grey)),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                      Container(
                                        margin: EdgeInsets.symmetric(
                                            vertical: 10, horizontal: 10),
                                        padding: const EdgeInsets.all(10),
                                        decoration: const BoxDecoration(
                                          color: Color(0xFFecf1fc),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10)),
                                        ),
                                        child: Row(
                                          children: [
                                            Container(
                                                padding: EdgeInsets.all(5),
                                                decoration: BoxDecoration(
                                                  color: Color(0xFFecf1fc),
                                                  borderRadius:
                                                      const BorderRadius.all(
                                                          Radius.circular(10)),
                                                ),
                                                child: Icon(Icons.key,
                                                    color: Color(0XFF784af5)
                                                        .withOpacity(0.7))),
                                            const SizedBox(width: 14),
                                            Container(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.6,
                                              child: TextFormField(
                                                controller: _passwordController,
                                                obscureText: true,
                                                validator: (value) {
                                                  if (value!.isEmpty) {
                                                    return "Enter your password";
                                                  }
                                                  return null;
                                                },
                                                onSaved: (value) =>
                                                    _password = value,
                                                keyboardType: TextInputType
                                                    .visiblePassword,
                                                textInputAction:
                                                    TextInputAction.next,
                                                style: GoogleFonts.roboto(
                                                    color: Color(0XFF535580),
                                                    fontSize: 18,
                                                    fontWeight:
                                                        FontWeight.bold),
                                                decoration: InputDecoration(
                                                    hintText: "Password",
                                                    border: InputBorder.none,
                                                    hintStyle: TextStyle(
                                                        color: Colors.grey)),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                      Container(
                                          margin: EdgeInsets.symmetric(
                                              vertical: 5, horizontal: 10),
                                          child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  "Remember me",
                                                  style: GoogleFonts.roboto(
                                                      color: Color(0XFF6e78f7),
                                                      fontSize: 15),
                                                ),
                                                Switch(
                                                    value: rememberMe,
                                                    activeColor: Color(0XFF6e78f7),
                                                    onChanged: (value) {
                                                      setState(() {
                                                        rememberMe =
                                                            !rememberMe;
                                                      });
                                                    })
                                              ])),
                                      Container(
                                          width: currentWidth * 0.7,
                                          child: isLogin
                                              ? SpinKitFadingCircle(
                                                  color: Color(0xFFf58184),
                                                  size: 53.0,
                                                )
                                              : ButtonWithoutIcon(
                                                  title: "LOGIN",
                                                  bgColor: Color(0XFF784af5),
                                                  titleColor: Colors.white,
                                                  onPressed: () {
                                                    login();
                                                  })),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              PageTransition(
                                                  type: PageTransitionType
                                                      .rightToLeftJoined,
                                                  duration: Duration(
                                                      milliseconds: 200),
                                                  childCurrent: Loginpage(),
                                                  reverseDuration: Duration(
                                                      milliseconds: 200),
                                                  child: Signuppage()));
                                        },
                                        child: Container(
                                            margin: EdgeInsets.symmetric(
                                                vertical: 5, horizontal: 10),
                                            child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    "I haven't account ",
                                                    style: GoogleFonts.roboto(
                                                        fontSize: 15),
                                                  ),
                                                  Text(
                                                    "Sign Up",
                                                    style: GoogleFonts.roboto(
                                                        color:
                                                            Color(0XFF6e78f7),
                                                        fontSize: 15),
                                                  ),
                                                ])),
                                      )
                                    ],
                                  )))),
                    ),
                    Container()
                  ],
                )
              ],
            ),
          ))),
    );
  }
}
