import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workflow/views/mainpage/mainpage.dart';
import 'package:workflow/views/startpage/startpage.dart';

class Passerell extends StatefulWidget {
  const Passerell({super.key});

  @override
  State<Passerell> createState() => _PasserellState();
}

class _PasserellState extends State<Passerell> {
  String email = '';
  String role = "";
  bool _isConnect = false;

  void initState() {
    super.initState();
    _isConnected();
  }

  void callback(bool isconnect) {
    setState(() {
      _isConnect = isconnect;
    });
  }

  Future<void> _isConnected() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      email = prefs.getString('email') ?? '';
    });
    print(email);
    if (email != '') {
      setState(() {
        _isConnect = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: _isConnect ? Mainpage(page: "home",) : Startpage(),
      onWillPop: () async {
        return true;
      },
    );
  }
}
