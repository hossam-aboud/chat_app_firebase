import 'package:chat_app/shared/styles/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';

String? userID = '';

enum StateType { success, warning, error }

showToast({
  required String message,
  required StateType stateType,
  Toast toastLength = Toast.LENGTH_LONG,
  ToastGravity gravity = ToastGravity.BOTTOM,
  Color txtColor = Colors.white,
}) {
  Fluttertoast.showToast(
    msg: message,
    textColor: txtColor,
    toastLength: toastLength,
    gravity: gravity,
    backgroundColor: checkStatusToast(type: stateType),
  );
}

Color checkStatusToast({
  required StateType type,
}) {
  late Color color;
  switch (type) {
    case StateType.success:
      color = Colors.green;
      break;
    case StateType.warning:
      color = Colors.yellow;
      break;
    default:
      color = Colors.red;
      break;
  }
  return color;
}

PreferredSizeWidget defaultAppBar({
  required BuildContext context,
  required String title,
  List<Widget>? actions,
}) {
  return AppBar(
    leading: IconButton(
      onPressed: () {
        Navigator.of(context).pop();
      },
      icon: const Icon(
        Icons.arrow_back,
      ),
    ),
    titleSpacing: 5.0,
    title: Text(
      title,
    ),
    actions: actions,
  );
}

void navigateTo({
  required BuildContext context,
  required Widget screen,
}) {
  Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) {
    return screen;
  }));
}

void removeUntilScreen({
  required BuildContext context,
  required Widget screen,
}) {
  Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(
    builder: (BuildContext context) {
      return screen;
    },
  ), (route) => false);
}

class DefaultTextField extends StatelessWidget {
  final Key key;
  final String label;
  final TextEditingController controller;
  final TextInputType typeText;
  final bool secureText;
  final IconData prefixIcon;
  final IconData? suffixIcon;
  final void Function(String)? onChanged;
  final String? Function(String?)? validator;
  final void Function()? onTap;
  final void Function()? onEditingComplete;
  final void Function(String)? onFieldSubmitted;
  final void Function()? suffixOnPressed;
  final double borderRadius;

  DefaultTextField({
    required this.key,
    required this.label,
    required this.controller,
    required this.typeText,
    this.secureText = false,
    this.borderRadius = 4.0,
    required this.prefixIcon,
    this.suffixIcon,
    this.onChanged,
    required this.validator,
    this.onTap,
    this.onEditingComplete,
    this.onFieldSubmitted,
    this.suffixOnPressed,
  });
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      key: key,
      controller: controller,
      keyboardType: typeText,
      obscureText: secureText,
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.left,
      textAlignVertical: TextAlignVertical.center,
      style: const TextStyle(),
      onChanged: onChanged,
      validator: validator,
      onTap: onTap,
      onEditingComplete: onEditingComplete,
      onFieldSubmitted: onFieldSubmitted,
      decoration: InputDecoration(
        errorStyle: const TextStyle(
          color: Colors.white,
          fontSize: 0.0,
        ),
        border: OutlineInputBorder(
          borderSide: const BorderSide(
            color: Colors.grey,
          ),
          borderRadius: BorderRadius.all(
            Radius.circular(
              borderRadius,
            ),
          ),
        ),
        labelText: label,
        prefixIcon: Icon(
          prefixIcon,
        ),
        suffixIcon: suffixIcon != null
            ? IconButton(
                icon: Icon(suffixIcon),
                onPressed: suffixOnPressed,
              )
            : null,
      ),
    );
  }
}

class DefaultElevatedButton extends StatelessWidget {
  final String labelText;
  final double height;
  final void Function()? onPressed;

  DefaultElevatedButton({
    required this.labelText,
    required this.onPressed,
    this.height = 50.0,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.none,
      height: height,
      decoration: const BoxDecoration(
        color: Colors.blue,
        borderRadius: BorderRadius.all(
          Radius.circular(
            6.0,
          ),
        ),
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        child: Text(
          labelText.toUpperCase(),
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        style: ButtonStyle(
          elevation: MaterialStateProperty.all<double>(0.0),
        ),
      ),
    );
  }
}

class DefaultTextButton extends StatelessWidget {
  final String text;
  final void Function()? onPressed;
  final bool isEnabled;

  DefaultTextButton(
      {required this.text, this.isEnabled = true, required this.onPressed});
  @override
  Widget build(BuildContext context) {
    return TextButton(
      child: Text(
        text.toUpperCase(),
      ),
      style: ButtonStyle(
        textStyle: MaterialStateProperty.all<TextStyle>(
          TextStyle(
            color: defaultColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      onPressed: isEnabled ? onPressed : null,
    );
  }
}

// Course Hassan Fliah

void courseHassan() {
  FirebaseFirestore.instance.collection('chats').snapshots().listen(
    (event) {
      // all element
      for (var element in event.docs) {
        print(element['text']);
      }
      // or (one element)
      print(event.docs[0]['text']);
    },
  ).onError(
    (error) {
      // on error
    },
  );
}
