import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:frontend/form_spending_page.dart';
import 'package:frontend/list_spending_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import './widget/global_widget.dart';

class HomePage extends StatefulWidget {
  final VoidCallback signOut;
  const HomePage({Key? key, required this.signOut}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  signOut() {
    setState(() {
      widget.signOut();
    });
  }

  String email = "", nama = "";
  var isScrollable = false;

  getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      email = preferences.getString("email")!;
      nama = preferences.getString("nama")!;
    });
  }

  @override
  void initState() {
    super.initState();
    getPref();
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    width = width - 50;
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
    return Scaffold(
      backgroundColor: const Color(0XFF130925),
      key: scaffoldKey,
      body: SafeArea(
        child: Stack(
          children: [
            Container(
              height: 70,
              margin: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      const CircleAvatar(
                        backgroundImage: AssetImage("assets/images/1.jpg"),
                        radius: 25,
                      ),
                      const SizedBox(width: 16),
                      Text(
                        nama,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontFamily: 'medium',
                        ),
                      ),
                    ],
                  ),
                  GestureDetector(
                    onTap: () {},
                    child: SvgPicture.asset(
                      "assets/images/t5_options.svg",
                      width: 25,
                      height: 25,
                      color: Colors.white,
                    ),
                  )
                ],
              ),
            ),
            SingleChildScrollView(
              padding: const EdgeInsets.only(top: 100),
              child: Container(
                padding: const EdgeInsets.only(top: 28),
                alignment: Alignment.topLeft,
                height: MediaQuery.of(context).size.height - 100,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(24),
                    topRight: Radius.circular(24),
                  ),
                ),
                child: Column(
                  children: [
                    Expanded(
                      child: GridView(
                        scrollDirection: Axis.vertical,
                        physics: isScrollable ? const ScrollPhysics() : const NeverScrollableScrollPhysics(),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                        ),
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => const FormSpendingPage(),
                                ),
                              );
                            },
                            child: Container(
                              alignment: Alignment.center,
                              decoration: const BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular(10)),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Container(
                                    height: width / 4,
                                    width: width / 4,
                                    margin: const EdgeInsets.only(bottom: 4, top: 8),
                                    padding: EdgeInsets.all(width / 30),
                                    decoration: boxDecoration(
                                      bgColor: const Color(0XFF45c7db),
                                      radius: 10,
                                    ),
                                    child: SvgPicture.asset(
                                      "assets/images/ppdb.svg",
                                      color: Colors.white,
                                    ),
                                  ),
                                  const Text(
                                    "Tambah Pengeluaran",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontFamily: 'medium',
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => const ListSpendingPage(),
                                ),
                              );
                            },
                            child: Container(
                              alignment: Alignment.center,
                              decoration: const BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular(10)),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Container(
                                    height: width / 4,
                                    width: width / 4,
                                    margin: const EdgeInsets.only(bottom: 4, top: 8),
                                    padding: EdgeInsets.all(width / 30),
                                    decoration: boxDecoration(
                                      bgColor: const Color(0XFF45c7db),
                                      radius: 10,
                                    ),
                                    child: SvgPicture.asset(
                                      "assets/images/info-ppdb.svg",
                                      color: Colors.white,
                                    ),
                                  ),
                                  const Text(
                                    "Daftar Pengeluaran",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontFamily: 'medium',
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              signOut();
                            },
                            child: Container(
                              alignment: Alignment.center,
                              decoration: const BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular(10)),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Container(
                                    height: width / 4,
                                    width: width / 4,
                                    margin: const EdgeInsets.only(bottom: 4, top: 8),
                                    padding: EdgeInsets.all(width / 30),
                                    decoration: boxDecoration(
                                      bgColor: const Color(0XFF45c7db),
                                      radius: 10,
                                    ),
                                    child: SvgPicture.asset(
                                      "assets/images/logout.svg",
                                      color: Colors.white,
                                    ),
                                  ),
                                  const Text(
                                    "Logout",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontFamily: 'medium',
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
