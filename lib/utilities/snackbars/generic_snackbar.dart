import 'package:collevo_teacher/colors.dart';
import 'package:flutter/material.dart';

void showGenericSnackbar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        message,
        style: const TextStyle(
          color: CustomColors.voidColor,
          fontSize: 16,
        ),
      ),
      backgroundColor: CustomColors.surf,
      duration: const Duration(seconds: 2),
    ),
  );
}
