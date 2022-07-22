import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:frontend/form_update_spending_page.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'model/response_spending_model.dart';

class ListSpendingPage extends StatefulWidget {
  const ListSpendingPage({Key? key}) : super(key: key);

  @override
  State<ListSpendingPage> createState() => _ListSpendingPageState();
}

class _ListSpendingPageState extends State<ListSpendingPage> {
  String prefEmail = "", prefNama = "", prefUserId = "";
  List<Datum> listSpending = [];
  final oCcy = NumberFormat("#,##0", "en_US");
  @override
  initState() {
    super.initState();
    getPref();
  }

  getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      prefEmail = preferences.getString("email")!;
      prefNama = preferences.getString("nama")!;
      prefUserId = preferences.getString("id")!;
    });
    getSpending();
  }

  getSpending() async {
    try {
      final response = await http.get(
        Uri.parse(
          "http://10.10.20.239:4000/api/spending/spendingByUser?user_id=" + prefUserId,
        ),
      );
      final data = jsonDecode(response.body);
      int value = data['metadata']['http_code'];
      if (value == 201 || value == 200) {
        ResponseSpending responseSpending = ResponseSpending.fromJson(data);
        setState(() {
          listSpending = responseSpending.data;
        });
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

  deleteSpending(String spendingId) async {
    try {
      final response = await http.delete(
        Uri.parse(
          "http://10.10.20.239:4000/api/spending/delete/" + spendingId,
        ),
      );
      final data = jsonDecode(response.body);
      int value = data['metadata']['http_code'];
      if (value == 201 || value == 200) {
        setState(() {
          listSpending = [];
        });
        getSpending();
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
              content: const Text("Berhasil hapus data spending"),
            );
          },
        );
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

  confirmDelete(String spendingId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Tidak"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                deleteSpending(spendingId);
              },
              child: const Text("Ya"),
            )
          ],
          content: const Text("Apakah yakin untuk dihapus ?"),
        );
      },
    );
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
        title: const Text("Tambah Pengeluaran"),
      ),
      body: Container(
        padding: const EdgeInsets.all(16),
        alignment: Alignment.topLeft,
        child: ListView.builder(
          itemCount: listSpending.length,
          itemBuilder: (context, index) {
            return widgetPengeluaran(listSpending[index]);
          },
        ),
      ),
    );
  }

  Widget widgetPengeluaran(Datum data) {
    return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Colors.black.withOpacity(0.5),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    data.name,
                  ),
                  Text(
                    "Rp. " + oCcy.format(data.nominal),
                  ),
                ],
              ),
            ),
            Column(
              children: [
                InkWell(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => FormUpdateSpendingPage(dataSpending: data),
                      ),
                    );
                  },
                  child: const Icon(
                    Icons.edit,
                  ),
                ),
                InkWell(
                  onTap: () {
                    confirmDelete(data.id);
                  },
                  child: const Icon(
                    Icons.delete,
                    color: Colors.red,
                  ),
                )
              ],
            )
          ],
        ));
  }
}
