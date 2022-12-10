// ignore_for_file: prefer_const_constructors, sort_child_properties_last

import 'package:flutter/material.dart';

Image imgWidget(String imageName, double h, double w) {
  return Image.asset(
    imageName,
    fit: BoxFit.fitWidth,
    width: w,
    height: h,
  );
}

TextField reuasbleTextField(
    String hintTxt, IconData icon, bool isPass, TextEditingController cont) {
  return TextField(
    textAlign: TextAlign.right,
    controller: cont,
    obscureText: isPass,
    enableSuggestions: !isPass,
    autocorrect: !isPass,
    style: TextStyle(color: Colors.black),
    decoration: InputDecoration(
      prefixIcon: Icon(
        icon,
        color: Colors.black,
      ),
      hintText: hintTxt,
      hintStyle: TextStyle(color: Colors.grey),
      floatingLabelBehavior: FloatingLabelBehavior.never,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
      ),
      filled: true,
    ),
    keyboardType:
        isPass ? TextInputType.visiblePassword : TextInputType.emailAddress,
  );
}
