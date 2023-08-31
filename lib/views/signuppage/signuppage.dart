import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:page_transition/page_transition.dart';
 
import 'package:workflow/components/buttonWithoutIcon.dart';
import 'package:workflow/views/loginpage/loginpage.dart';

import '../../components/title.dart';
import '../../models/companyModel.dart';
import '../../models/departmentModel.dart';
import '../../models/gradeModel.dart';
import '../../services/apiservices.dart';

class Signuppage extends StatefulWidget {
  const Signuppage({super.key});

  @override
  State<Signuppage> createState() => _SignuppageState();
}

class _SignuppageState extends State<Signuppage> {
  @override
  Widget build(BuildContext context) {
   
    return SignupForm();
  }
}

class SignupForm extends StatefulWidget {
  const SignupForm({super.key});

  @override
  State<SignupForm> createState() => _SignupFormState();
}

class _SignupFormState extends State<SignupForm> {
  final PageController controller = new PageController();
  TextEditingController _companyIdcontroller = TextEditingController();
  TextEditingController _emailcontroller = TextEditingController();
  TextEditingController _usernamecontroller = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _confirmPasswordController = TextEditingController();
  String? _username = "",
      _password = "",
      _companyId = "",
      _email = "",
      _confirmPassword = "",
      responseMessage = "";
  int currentPage = 0;
  String _department = 'DEPARTMENT';
  List<GradeModel> gradeList = [
    GradeModel(maxAmount: '0', word: "GRADE", gradeId: 0)
  ];
  List<DepartmentModel> departmentList = [DepartmentModel(departmentName: "DEPARTMENT", departmentId: 0)];
  String _grade = 'GRADE';
  bool isSignup = false;
  Future<bool> checkCredential(
      String companyId,
      String email,
      String username,
      String department,
      String grade,
      String password,
      String maxAmount) async {
    final response = await signupApi(
        companyId.toLowerCase(), email.toLowerCase(), username, department, grade, password, maxAmount);
    setState(() {
      responseMessage = response;
    });
    if (response != "success") {
      return false;
    } else {
      return true;
    }
  }

  Future<CompanyModel> checkCompanyId(String companyId) async {
    return await getCompanyData(companyId);
  }

  String getMaxAmountByGradeName(String gradeName) {
    for (var grade in gradeList) {
      if (grade.word == gradeName) {
        return grade.maxAmount;
      }
    }
    return '';
  }

  void signup() async {
    setState(() {
      isSignup = true;
    });

    bool isAuthenticated = await checkCredential(
        _companyId!,
        _email!,
        _username!,
        _department,
        _grade,
        _password!,
        getMaxAmountByGradeName(_grade));

    if (isAuthenticated) {
      Fluttertoast.showToast(
          msg: "You are registered !",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0);
      Navigator.push(
          context,
          PageTransition(
              type: PageTransitionType.leftToRightJoined,
              duration: Duration(milliseconds: 200),
              childCurrent: Signuppage(),
              reverseDuration: Duration(milliseconds: 200),
              child: Loginpage()));

      setState(() {
        isSignup = false;
      });
    } else {
      setState(() {
        isSignup = false;
      });

      Fluttertoast.showToast(
          msg: responseMessage != ''
              ? "${responseMessage}"
              : "Server connexion error",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

  void _onPageChanged(int page) {
    setState(() {
      currentPage = page;
    });
    controller.animateToPage(page,
        duration: Duration(milliseconds: 200), curve: Curves.easeIn);
  }

  Widget _buildPageIndicator(int page) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 2.0),
      height: page == currentPage ? 10.0 : 6.0,
      width: page == currentPage ? 10.0 : 6.0,
      decoration: BoxDecoration(
        color: page == currentPage ? Color(0XFF784af5) : Colors.grey,
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double currentHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SafeArea(
          child: Container(
              child: SingleChildScrollView(
                  child: Column(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.1,
          ),
          Center(
              child: Text(
            "Registration".toUpperCase(),
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              decoration: TextDecoration.underline,
              decorationThickness: 1,
              decorationStyle: TextDecorationStyle.dotted,
            ),
          )),
          SizedBox(
            height: currentHeight * 0.1,
          ),
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("assets/images/workflow-logo.png"))),
          ),
          AppTitle(),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.05,
          ),
          Container(
            height: MediaQuery.of(context).size.height * 0.45,
            child: PageView(
              pageSnapping: false,
              physics: NeverScrollableScrollPhysics(),
              children: [
                companyIdBox(),
                emailBox(),
                userNameBox(),
                departmentBox(),
                gradeBox(),
                passwordBox(),
                recapView()
              ],
              controller: controller,
              onPageChanged: _onPageChanged,
            ),
          ),
          if (currentPage != 6)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildPageIndicator(0),
                    _buildPageIndicator(1),
                    _buildPageIndicator(2),
                    _buildPageIndicator(3),
                    _buildPageIndicator(4),
                    _buildPageIndicator(5),
                  ],
                ),
              ),
            ),
          if (currentPage == 6)
            Container(
                width: MediaQuery.of(context).size.width * 0.5,
                child: isSignup
                    ? SpinKitFadingCircle(
                        color: Color(0xFFf58184),
                        size: 53.0,
                      )
                    : ButtonWithoutIcon(
                        title: "Sign Up",
                        bgColor: Color(0xFF8359f6),
                        titleColor: Colors.white,
                        onPressed: () {
                          signup();
                        },
                      ))
        ],
      )))),
    );
  }

  Widget companyIdBox() {
    return Container(
      alignment: Alignment.center,
      child: Column(
        children: [
          Container(
            width: MediaQuery.of(context).size.width * 0.5,
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
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
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
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.next,
                    style: TextStyle(
                        color: Color(0XFF535580),
                        fontSize: 15,
                        fontWeight: FontWeight.bold),
                    decoration: InputDecoration(
                        hintText: "Company ID",
                        border: InputBorder.none,
                        hintStyle: TextStyle(color: Colors.grey, fontSize: 15)),
                  ),
                )
              ],
            ),
          ),
          Container(
              width: MediaQuery.of(context).size.width * 0.5,
              child: ButtonWithoutIcon(
                title: "NEXT",
                bgColor: Color(0xFF8359f6),
                titleColor: Colors.white,
                onPressed: () async {
                  setState(() {
                    _companyId = _companyIdcontroller.text;
                  });

                  if (_companyId != '') {
                    CompanyModel checking = await checkCompanyId(_companyId!);

                    if (checking.status == true) {
                      setState(() {
                        gradeList.addAll(checking.grades);
                        departmentList.addAll(
                            checking.departments as List<DepartmentModel>);
                      });
                      _onPageChanged(1);
                    } else {
                      Fluttertoast.showToast(
                          msg: "This Company ID does not exist.",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Colors.red,
                          textColor: Colors.white,
                          fontSize: 16.0);
                    }
                  } else {
                    Fluttertoast.showToast(
                        msg: "Enter Company ID please.",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Colors.red,
                        textColor: Colors.white,
                        fontSize: 16.0);
                  }
                },
              ))
        ],
      ),
    );
  }

  Widget emailBox() {
    return Container(
      alignment: Alignment.center,
      child: Column(
        children: [
          Container(
            width: MediaQuery.of(context).size.width * 0.5,
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
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                    ),
                    child: Icon(
                      Icons.email,
                      color: Color(0XFF784af5).withOpacity(0.7),
                    )),
                const SizedBox(width: 14),
                Container(
                  width: MediaQuery.of(context).size.width * 0.3,
                  child: TextFormField(
                    controller: _emailcontroller,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Enter your email address";
                      }
                      return null;
                    },
                    onSaved: (value) => _email = value!,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    style: TextStyle(
                        color: Color(0XFF535580),
                        fontSize: 15,
                        fontWeight: FontWeight.bold),
                    decoration: InputDecoration(
                        hintText: "Email",
                        border: InputBorder.none,
                        hintStyle: TextStyle(color: Colors.grey, fontSize: 15)),
                  ),
                )
              ],
            ),
          ),
          Container(
              width: MediaQuery.of(context).size.width * 0.5,
              child: ButtonWithoutIcon(
                title: "NEXT",
                bgColor: Color(0xFF8359f6),
                titleColor: Colors.white,
                onPressed: () async {
                  setState(() {
                    _email = _emailcontroller.text;
                  });
                  if (_email != '') {
                    _onPageChanged(2);
                  } else {
                    Fluttertoast.showToast(
                        msg: "Enter a valid email address please.",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Colors.red,
                        textColor: Colors.white,
                        fontSize: 16.0);
                  }
                },
              ))
        ],
      ),
    );
  }

  Widget userNameBox() {
    return Container(
      alignment: Alignment.center,
      child: Column(
        children: [
          Container(
            width: MediaQuery.of(context).size.width * 0.5,
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
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                    ),
                    child: Icon(
                      Icons.account_box,
                      color: Color(0XFF784af5).withOpacity(0.7),
                    )),
                const SizedBox(width: 14),
                Container(
                  width: MediaQuery.of(context).size.width * 0.3,
                  child: TextFormField(
                    controller: _usernamecontroller,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Enter your username";
                      }
                      return null;
                    },
                    onSaved: (value) => _username = value!,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    style: TextStyle(
                        color: Color(0XFF535580),
                        fontSize: 15,
                        fontWeight: FontWeight.bold),
                    decoration: InputDecoration(
                        hintText: "Username",
                        border: InputBorder.none,
                        hintStyle: TextStyle(color: Colors.grey, fontSize: 15)),
                  ),
                )
              ],
            ),
          ),
          Container(
              width: MediaQuery.of(context).size.width * 0.5,
              child: ButtonWithoutIcon(
                title: "NEXT",
                bgColor: Color(0xFF8359f6),
                titleColor: Colors.white,
                onPressed: () {
                  setState(() {
                    _username = _usernamecontroller.text;
                  });
                  if (_username != '') {
                    _onPageChanged(3);
                  } else {
                    Fluttertoast.showToast(
                        msg: "Enter your username please.",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Colors.red,
                        textColor: Colors.white,
                        fontSize: 16.0);
                  }
                },
              ))
        ],
      ),
    );
  }

  Widget departmentBox() {
    return Container(
      alignment: Alignment.center,
      child: Column(
        children: [
          Container(
            width: MediaQuery.of(context).size.width * 0.5,
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
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                    ),
                    child: Icon(
                      Icons.work,
                      color: Color(0XFF784af5).withOpacity(0.7),
                    )),
                Container(
                    width: MediaQuery.of(context).size.width * 0.35,
                    child: DropdownButtonHideUnderline(
                      child: ButtonTheme(
                        alignedDropdown: true,
                        child: DropdownButton(
                          value: _department,
                          isExpanded: true,
                          items: departmentList.map<DropdownMenuItem<String>>(
                              (DepartmentModel value) {
                            return DropdownMenuItem<String>(
                              value: value.departmentName,
                              child: Text(
                                value.departmentName,
                                style: TextStyle(fontSize: 13),
                              ),
                            );
                          }).toList(),
                          onChanged: (newValue) {
                            setState(() {
                              _department = newValue.toString();
                            });
                          },
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ),
                    )),
                SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
          Container(
              width: MediaQuery.of(context).size.width * 0.5,
              child: ButtonWithoutIcon(
                title: "NEXT",
                bgColor: Color(0xFF8359f6),
                titleColor: Colors.white,
                onPressed: () {
                  if (_department != '') {
                    _onPageChanged(4);
                  } else {
                    Fluttertoast.showToast(
                        msg: "Select your department please.",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Colors.red,
                        textColor: Colors.white,
                        fontSize: 16.0);
                  }
                },
              ))
        ],
      ),
    );
  }

  Widget gradeBox() {
    return Container(
      alignment: Alignment.center,
      child: Column(
        children: [
          Container(
            width: MediaQuery.of(context).size.width * 0.5,
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
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                    ),
                    child: Icon(
                      Icons.grade,
                      color: Color(0XFF784af5).withOpacity(0.7),
                    )),
                Container(
                    width: MediaQuery.of(context).size.width * 0.35,
                    child: DropdownButtonHideUnderline(
                      child: ButtonTheme(
                        alignedDropdown: true,
                        child: DropdownButton(
                          value: _grade,
                          isExpanded: true,
                          items: gradeList
                              .map<DropdownMenuItem<String>>((dynamic value) {
                            return DropdownMenuItem<String>(
                              value: value.word,
                              child: Text(
                                value.word,
                                style: TextStyle(fontSize: 13),
                              ),
                            );
                          }).toList(),
                          onChanged: (newValue) {
                            setState(() {
                              _grade = newValue.toString();
                            });
                          },
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ),
                    )),
                SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
          Container(
              width: MediaQuery.of(context).size.width * 0.5,
              child: ButtonWithoutIcon(
                title: "NEXT",
                bgColor: Color(0xFF8359f6),
                titleColor: Colors.white,
                onPressed: () {
                  if (_grade != '') {
                    _onPageChanged(5);
                  } else {
                    Fluttertoast.showToast(
                        msg: "Select your grade please.",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Colors.red,
                        textColor: Colors.white,
                        fontSize: 16.0);
                  }
                },
              ))
        ],
      ),
    );
  }

  Widget passwordBox() {
    return Container(
      alignment: Alignment.center,
      child: Column(
        children: [
          Container(
            width: MediaQuery.of(context).size.width * 0.5,
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
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                    ),
                    child: Icon(
                      Icons.password,
                      color: Color(0XFF784af5).withOpacity(0.7),
                    )),
                const SizedBox(width: 14),
                Container(
                  width: MediaQuery.of(context).size.width * 0.3,
                  child: TextFormField(
                    controller: _passwordController,
                    obscureText: true,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Enter a valid password";
                      }
                      return null;
                    },
                    onSaved: (value) => _password = value!,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    style: TextStyle(
                        color: Color(0XFF535580),
                        fontSize: 15,
                        fontWeight: FontWeight.bold),
                    decoration: InputDecoration(
                        hintText: "New password",
                        border: InputBorder.none,
                        hintStyle: TextStyle(color: Colors.grey, fontSize: 15)),
                  ),
                )
              ],
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width * 0.5,
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
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                    ),
                    child: Icon(
                      Icons.password,
                      color: Color(0XFF784af5).withOpacity(0.7),
                    )),
                const SizedBox(width: 14),
                Container(
                  width: MediaQuery.of(context).size.width * 0.3,
                  child: TextFormField(
                    controller: _confirmPasswordController,
                    obscureText: true,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Enter a valid password";
                      }
                      return null;
                    },
                    onSaved: (value) => _confirmPassword = value!,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    style: TextStyle(
                        color: Color(0XFF535580),
                        fontSize: 15,
                        fontWeight: FontWeight.bold),
                    decoration: InputDecoration(
                        hintText: "Confirm password",
                        border: InputBorder.none,
                        hintStyle: TextStyle(color: Colors.grey, fontSize: 15)),
                  ),
                )
              ],
            ),
          ),
          Container(
              width: MediaQuery.of(context).size.width * 0.5,
              child: ButtonWithoutIcon(
                title: "FINISHED",
                bgColor: Color(0xFF8359f6),
                titleColor: Colors.white,
                onPressed: () {
                  setState(() {
                    _password = _passwordController.text;
                    _confirmPassword = _confirmPasswordController.text;
                  });
                  if (_password != '' && _confirmPassword != '') {
                    if (_password != _confirmPassword) {
                      Fluttertoast.showToast(
                          msg: "Your passwords do not match",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Colors.red,
                          textColor: Colors.white,
                          fontSize: 16.0);
                    } else {
                      _onPageChanged(6);
                    }
                  } else {
                    Fluttertoast.showToast(
                        msg: "Enter a new password please.",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Colors.red,
                        textColor: Colors.white,
                        fontSize: 16.0);
                  }
                },
              ))
        ],
      ),
    );
  }

  Widget recapView() {
    return Container(
      alignment: Alignment.center,
      child: SingleChildScrollView(
          child: Column(
        children: [
          Container(
            child: Text(
              "Signup Details",
              textAlign: TextAlign.start,
              style: TextStyle(color: Colors.black, fontSize: 17),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 20),
            color: Colors.grey.withOpacity(0.1),
            child: Column(children: [
              ReccapViewItem(
                title: "Company ID",
                value: _companyId!,
              ),
              ReccapViewItem(
                title: "Email address",
                value: _email!,
              ),
              ReccapViewItem(
                title: "Username",
                value: _username!,
              ),
              ReccapViewItem(
                title: "Department",
                value: _department,
              ),
              ReccapViewItem(
                title: "Grade",
                value: _grade,
              ),
            ]),
          ),
        ],
      )),
    );
  }
}

class ReccapViewItem extends StatelessWidget {
  const ReccapViewItem({super.key, required this.title, required this.value});
  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${title}",
                  style: TextStyle(color: Color(0xFF8359f6)),
                ),
                SizedBox(
                  height: 7,
                ),
                Text(
                  "${value}",
                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 17),
                ),
              ],
            ),
          ],
        )
      ]),
    );
  }
}
