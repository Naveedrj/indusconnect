
import 'package:flutter/material.dart';

class Custom {

  Color primary =  Colors.teal;
  Color secondary =  Colors.tealAccent;


  static Widget textfield({
    required TextEditingController controller,
    required String labelText,
    required IconData suffixIcon,
  }) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25),
            borderSide: BorderSide(color: Colors.teal)
        ),
        labelText: labelText,
        labelStyle: const TextStyle(
            color: Color(0xFF008080),
        ),
        suffixIcon: suffixIcon != null ? Icon(suffixIcon, color: Colors.teal,) : null,
      ),
    );
  }



  static Widget button({
    required VoidCallback onPress,
    required String text,
    required String backgroundColor,
    required String textColor,
    required double length,
    required double textSize,
    required double radius,
  }) {
    return Column(
      children: [
      ElevatedButton(
      onPressed: onPress,
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.symmetric(horizontal: length, vertical: 10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radius),
        ),
        primary: Color(int.parse(backgroundColor)),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: textSize,
          fontWeight: FontWeight.bold,
          color: Color(int.parse(textColor)),
        ),
      ),
    ),
        SizedBox(
          height: 18,
        )
      ],
    );
  }

  static Widget box({
    required double height,
    required double width,
}){
    return SizedBox(
      height: height,
      width: width,
    );
  }


static Widget alert({
    required String text,
    required String content,
}){
    return AlertDialog(
      title: Text(text),
      content: Text(content),
      actions: [
        TextButton(
          onPressed: () {

          },
          child: Text('OK'),
        ),
      ],
      backgroundColor: Colors.white,
      elevation: 8.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      titleTextStyle: TextStyle(
        color: Colors.blue,
        fontWeight: FontWeight.bold,
      ),
      contentTextStyle: TextStyle(
        color: Colors.black,
      ),
      buttonPadding: EdgeInsets.symmetric(horizontal: 16.0),
      iconColor: Colors.blue,
    );


}





}
