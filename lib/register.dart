import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import './login.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  late String email, password, nama;
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
      save();
    }
  }

  save() async {
    try {
      final response = await http.post(
        Uri.parse(
          "http://10.10.20.239:4000/api/spending/registrations",
        ),
        body: {
          "name": nama,
          "email": email,
          "password": password,
        },
      );
      final data = jsonDecode(response.body);
      print(data);
      int value = data['metadata']['http_code'];
      if (value == 201 || value == 200) {
        Navigator.pop(context);
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
    } on Exception catch (_, e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _key,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: pRegister(),
            )
          ],
        ),
      ),
    );
  }

  Widget pRegister() {
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
                  return "Please insert fullname";
                }
                return null;
              },
              onSaved: (e) => nama = e!,
              style: const TextStyle(fontSize: 18.0, fontFamily: "regular:"),
              obscureText: false,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.fromLTRB(24, 18, 24, 18),
                hintText: "Nama",
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
                "Daftar",
                style: TextStyle(fontSize: 18.0, color: Color(0XFFffffff), fontFamily: "Medium"),
              ),
            ),
            const SizedBox(height: 24),
            InkWell(
              onTap: () {
                Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const LoginPage()));
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const <Widget>[
                  Text("Sudah punya akun? ", textAlign: TextAlign.center, style: TextStyle(fontSize: 18.0, fontFamily: "Medium")),
                  SizedBox(width: 8),
                  Text("Login",
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
