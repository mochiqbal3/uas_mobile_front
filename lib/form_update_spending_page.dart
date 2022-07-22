import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:frontend/model/response_spending_model.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class FormUpdateSpendingPage extends StatefulWidget {
  final Datum dataSpending;
  const FormUpdateSpendingPage({Key? key, required this.dataSpending}) : super(key: key);

  @override
  State<FormUpdateSpendingPage> createState() => _FormUpdateSpendingPageState();
}

class _FormUpdateSpendingPageState extends State<FormUpdateSpendingPage> {
  late String deskripsi, nominal, nama;
  final _key = GlobalKey<FormState>();
  TextEditingController textEditingControllerName = TextEditingController();
  TextEditingController textEditingControllerDescription = TextEditingController();
  TextEditingController textEditingControllerNominal = TextEditingController();

  String prefEmail = "", prefNama = "", prefUserId = "";
  var isScrollable = false;

  @override
  initState() {
    super.initState();
    getPref();
    textEditingControllerName.text = widget.dataSpending.name;
    textEditingControllerNominal.text = widget.dataSpending.nominal.toString();
    textEditingControllerDescription.text = widget.dataSpending.description;
  }

  getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      prefEmail = preferences.getString("email")!;
      prefNama = preferences.getString("nama")!;
      prefUserId = preferences.getString("id")!;
    });
  }

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
      final response = await http.put(
        Uri.parse(
          "http://10.10.20.239:4000/api/spending/update/" + widget.dataSpending.id,
        ),
        body: {
          "name": nama,
          "description": deskripsi,
          "nominal": nominal,
          "user_id": prefUserId,
        },
      );
      final data = jsonDecode(response.body);
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
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(Icons.arrow_back),
        ),
        title: const Text("Ubah Pengeluaran"),
      ),
      body: SingleChildScrollView(
        child: Container(
          alignment: Alignment.topLeft,
          child: Form(
            key: _key,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: pRegister(),
            ),
          ),
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
              controller: textEditingControllerName,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.fromLTRB(24, 18, 24, 18),
                hintText: "Nama Pengeluaran",
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
                  return "Please insert deskripsi";
                }
                return null;
              },
              onSaved: (e) => deskripsi = e!,
              controller: textEditingControllerDescription,
              style: const TextStyle(fontSize: 18.0, fontFamily: "regular:"),
              obscureText: false,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.fromLTRB(24, 18, 24, 18),
                hintText: "Deskripsi",
                filled: true,
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(40),
                  borderSide: const BorderSide(
                    color: Color(0XFFE8E8E8),
                    width: 0.0,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(40),
                  borderSide: const BorderSide(
                    color: Color(0XFFE8E8E8),
                    width: 0.0,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              keyboardType: TextInputType.number,
              validator: (e) {
                if (e!.isEmpty) {
                  return "Please insert nominal";
                }
                return null;
              },
              controller: textEditingControllerNominal,
              onSaved: (e) => nominal = e!,
              style: const TextStyle(fontSize: 18.0, fontFamily: "regular:"),
              obscureText: false,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.fromLTRB(24, 18, 24, 18),
                hintText: "Nominal",
                filled: true,
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(40),
                  borderSide: const BorderSide(
                    color: Color(0XFFE8E8E8),
                    width: 0.0,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(40),
                  borderSide: const BorderSide(
                    color: Color(0XFFE8E8E8),
                    width: 0.0,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            MaterialButton(
              height: 60,
              minWidth: double.infinity,
              textColor: const Color(0XFFff8080),
              color: Colors.blue,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40.0)),
              onPressed: () => {
                check(),
              },
              child: const Text(
                "Simpan",
                style: TextStyle(fontSize: 18.0, color: Color(0XFFffffff), fontFamily: "Medium"),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      )),
    );
  }
}
