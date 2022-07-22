import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import './register.dart';

import 'home.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

enum LoginStatus { notSignIn, signIn }

class _LoginPageState extends State<LoginPage> {
  LoginStatus _loginStatus = LoginStatus.notSignIn;
  late String email, password;
  final _key = GlobalKey<FormState>();

  bool _secureText = true;

  showHide() {
    setState(() {
      _secureText = !_secureText;
    });
  }

  check() {
    final form = _key.currentState;
    if (form!.validate()) {
      form.save();
      login();
    }
  }

  login() async {
    final response = await http
        .post(Uri.parse("http://10.10.20.239:4000/api/spending/sessions/login"), body: {"email": email, "password": password});
    final data = jsonDecode(response.body);
    int value = data['metadata']['http_code'];
    if (value == 200 || value == 201) {
      String id = data['data']['user']['id'];
      String emailAPI = data['data']['user']['email'];
      String namaAPI = data['data']['user']['name'];
      print(id);
      savePref(emailAPI, namaAPI, id);
    } else {
      String message = data['error']['message'];
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text("Ya"))
            ],
            content: Text(message),
          );
        },
      );
    }
  }

  savePref(String email, String nama, String id) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      preferences.setString("nama", nama);
      preferences.setString("email", email);
      preferences.setString("id", id);
    });
    getPref();
  }

  // ignore: prefer_typing_uninitialized_variables
  late String value;
  getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      value = preferences.getString("nama") ?? "";

      _loginStatus = value != "" ? LoginStatus.signIn : LoginStatus.notSignIn;
    });
  }

  signOut() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      preferences.setInt("value", 0);
      _loginStatus = LoginStatus.notSignIn;
    });
  }

  @override
  void initState() {
    super.initState();
    getPref();
  }

  @override
  Widget build(BuildContext context) {
    switch (_loginStatus) {
      case LoginStatus.notSignIn:
        return Scaffold(
          body: Form(
            key: _key,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: pLogin(),
                ),
              ],
            ),
          ),
        );
      case LoginStatus.signIn:
        return HomePage(signOut: signOut);
    }
  }

  Widget pLogin() {
    return Center(
      child: SingleChildScrollView(
          child: Container(
        alignment: Alignment.center,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 30),
            Image.asset("assets/logo_tedc.png", height: 100, width: 100),
            const SizedBox(height: 16),
            TextFormField(
              validator: (e) {
                if (e!.isEmpty) {
                  return "Please insert email";
                }
                return null;
              },
              onSaved: (e) => email = e!,
              style: const TextStyle(fontSize: 18.0, fontFamily: "regular:"),
              obscureText: false,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.fromLTRB(24, 18, 24, 18),
                hintText: "Email",
                filled: true,
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(40), borderSide: const BorderSide(color: Color(0XFFE8E8E8), width: 0.0)),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(40),
                  borderSide: const BorderSide(color: Color(0XFFE8E8E8), width: 0.0),
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              style: const TextStyle(fontSize: 18.0, fontFamily: "regular:"),
              obscureText: _secureText,
              onSaved: (e) => password = e!,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.fromLTRB(24, 18, 24, 18),
                hintText: "Password",
                filled: true,
                suffixIcon: IconButton(
                  onPressed: showHide,
                  icon: Icon(_secureText ? Icons.visibility_off : Icons.visibility,
                      color: const Color.fromARGB(255, 180, 179, 179)),
                ),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(40), borderSide: const BorderSide(color: Color(0XFFE8E8E8), width: 0.0)),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(40),
                  borderSide: const BorderSide(color: Color(0XFFE8E8E8), width: 0.0),
                ),
              ),
            ),
            const SizedBox(height: 8),
            MaterialButton(
              height: 60,
              minWidth: double.infinity,
              textColor: const Color(0XFFff8080),
              color: const Color(0XFFff8080),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40.0)),
              onPressed: () => {
                check(),
              },
              child: const Text(
                "Login",
                style: TextStyle(fontSize: 18.0, color: Color(0XFFffffff), fontFamily: "Medium"),
              ),
            ),
            const SizedBox(height: 24),
            InkWell(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => const RegisterPage()));
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const <Widget>[
                  Text("Belum punya akun? ", textAlign: TextAlign.center, style: TextStyle(fontSize: 18.0, fontFamily: "Medium")),
                  SizedBox(width: 8),
                  Text("Register",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 18.0, fontFamily: "Medium", color: Color(0XFF1D36C0))),
                ],
              ),
            )
          ],
        ),
      )),
    );
  }
}
