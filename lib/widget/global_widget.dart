import 'package:flutter/material.dart';

Text formHeading(var label) {
  return Text(label,
      style: const TextStyle(fontSize: 30, fontFamily: 'Bold'),
      textAlign: TextAlign.center);
}

Text formSubHeadingForm(var label) {
  return Text(label,
      style: const TextStyle(fontSize: 20, fontFamily: 'Bold'),
      textAlign: TextAlign.center);
}

BoxDecoration boxDecoration(
    {double radius = 2,
    Color color = Colors.transparent,
    Color? bgColor,
    var showShadow = false}) {
  return BoxDecoration(
    color: bgColor ?? Colors.white,
    boxShadow: showShadow
        ? defaultBoxShadow(shadowColor: Colors.grey.withOpacity(0.2))
        : [const BoxShadow(color: Colors.transparent)],
    border: Border.all(color: color),
    borderRadius: BorderRadius.all(Radius.circular(radius)),
  );
}

List<BoxShadow> defaultBoxShadow({
  Color? shadowColor,
  double? blurRadius,
  double? spreadRadius,
  Offset offset = const Offset(0.0, 0.0),
}) {
  return [
    BoxShadow(
      color: shadowColor ?? Colors.grey.withOpacity(0.2),
      blurRadius: blurRadius ?? 4.0,
      spreadRadius: spreadRadius ?? 1.0,
      offset: offset,
    )
  ];
}

Widget loadingScreen() {
  // make loading circle midle of screen
  return const Center(
    child: CircularProgressIndicator(),
  );
}
