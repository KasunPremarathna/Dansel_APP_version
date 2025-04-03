import 'package:dansal_app/constent_values/const_colors.dart';
import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String btnName;
  const CustomButton({super.key, required this.btnName});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      height: 50,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.5),
            spreadRadius: 2,
            blurRadius: 9,
            offset: Offset(0, 3), // changes position of shadow
          ),
        ],
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomLeft,
          colors: [
            const Color.fromARGB(255, 255, 171, 81),
            const Color.fromARGB(255, 232, 91, 47),
          ],
        ),
      ),
      child: Center(
        child: Text(
          btnName,
          style: TextStyle(
            fontSize: 23,
            color: whiteFontColor,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}
