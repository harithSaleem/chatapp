import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  final Color color;
  final String titel;
  final VoidCallback onpressed;
  const MyButton({
    Key? key,
    required this.color,
    required this.titel,
    required this.onpressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Material(
        elevation: 5,
        color: color,
        borderRadius: BorderRadius.circular(10),
        child: MaterialButton(
          onPressed: onpressed,
          minWidth: 200,
          height: 42,
          child: Text(
            titel,
            style: const TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
