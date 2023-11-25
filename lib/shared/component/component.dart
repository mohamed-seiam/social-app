// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

Widget defaultformfield({
  required TextEditingController? controller,
  required TextInputType type,
  required String label,
  required String? Function(String?)? validate,
  required IconData icon,
  String? Function(String?)? onSubmit,
  String? Function(String?)? onChanged,
  Function()? onTap,
  IconData? suffix,
  Function()? suufixpress,
  bool isPassword = false,
}) =>
    TextFormField(
      controller: controller,
      keyboardType: type,
      validator: validate,
      obscureText: isPassword,
      onTap: onTap,
      onChanged: onChanged,
      onFieldSubmitted: onSubmit,
      decoration: InputDecoration(
        labelText: label,
        // labelStyle: TextStyle(color: Colors.white),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(20.0))),
        prefixIcon: Icon(
          icon,
        ),
        suffixIcon: suffix != null
            ? IconButton(onPressed: suufixpress, icon: Icon(suffix))
            : null,
      ),
    );

Widget defaultButton({
  double width = double.infinity,
  Color background = Colors.blue,
  bool isUpperCase = true,
  double readuis = 0.0,
  required void Function()? function,
  required String text,
}) =>
    Container(
      width: width,
      height: 40.0,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(readuis),
        color: background,
      ),
      child: MaterialButton(
        onPressed: function,
        child: Text(
          isUpperCase ? text.toUpperCase() : text,
          style: TextStyle(color: Colors.white),
        ),
      ),
    );

Widget defaultTextButton({
  required Function()? function,
  required String text,
}) =>
    TextButton(onPressed: function, child: Text(text.toUpperCase()));

Widget mydivider() => Padding(
      padding: const EdgeInsetsDirectional.only(start: 20.0, end: 20, top: 5),
      child: Container(
        width: double.infinity,
        height: 1,
        color: Colors.grey[500],
      ),
    );

void navigteTo(context, widget) => Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => widget),
    );

void showToast({
  required String text,
  required Toaststate state,
}) =>
    Fluttertoast.showToast(
      msg: text,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 10,
      backgroundColor: chooseToastcolor(state),
      textColor: Colors.white,
      fontSize: 20.0,
    );

//  enum>> to swap color
enum Toaststate { SUCCESS, ERROR, WARNING }

// method change color
Color? chooseToastcolor(Toaststate state) {
  Color color;
  switch (state) {
    case Toaststate.SUCCESS:
      color = Colors.green;
      break;
    case Toaststate.ERROR:
      color = Colors.red;
      break;
    case Toaststate.WARNING:
      color = Colors.amber;
      break;
  }
  return color;
}

void navigateAndFinish(context, Widget) => Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => Widget,
      ),
      (route) {
        return false;
      },
    );

PreferredSizeWidget defaultAppbar({
  required BuildContext context,
  String? title,
  List<Widget>? actions,
}) =>
    AppBar(
      title: Text(title!),
      titleSpacing: 5.0,
      leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.chevron_left,
          )),
      actions: actions,
    );

showCustomSnackBar({required BuildContext context, required String msg}) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text(msg),
    backgroundColor: Colors.blue.withOpacity(.8),
    behavior: SnackBarBehavior.floating,
  ));
}
