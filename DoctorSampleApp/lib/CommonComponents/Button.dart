import 'package:dev_sample_app/Styles/Colors.dart';
import 'package:flutter/material.dart';

class CustomStyledButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String label;

  const CustomStyledButton({
    required this.onPressed,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: AppColors.webengagePurple,
        side: BorderSide(color: AppColors.webengagePurple),
      ),
      child: Container(
        width: 200,
        height: 80,
        child: Center(
          child: Text(
            label,
            style: TextStyle(fontSize: 20),
          ),
        ),
      ),
    );
  }
}
