import 'package:flutter/material.dart';

class MyElevatedButton extends StatelessWidget {
  final String text;
  final Function onPressed;

  const MyElevatedButton({super.key, required this.text, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 200, 
      height: 50, 
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          textStyle: const TextStyle(
            fontSize: 20,
          )
        ),
        onPressed: () => onPressed(),
        child: Text(text),
      ),
    ); 
  }
}