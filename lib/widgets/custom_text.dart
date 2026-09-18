import 'package:flutter/material.dart';

class CustomText extends StatelessWidget {

  final bool obscureText;
  final int maxLength;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final Function()? onTapSuffixIcon;
  final bool usePassword;
  final String hintText;
  final String label;
  final TextInputType keyboardType;

  const CustomText({
    super.key, 
    this.obscureText = false,  
    this.maxLength = 255, 
    required this.controller, 
    this.validator,
    this.usePassword = false, 
    this.onTapSuffixIcon, 
    required this.hintText, 
    required this.label,  
    this.keyboardType = TextInputType.text,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: obscureText,
      maxLength: maxLength,
      controller: controller,
      validator: validator,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        counterText: '',
        label: Text(label),
        hintText: hintText,
        isDense: true,
        suffixIcon: usePassword
          ? InkWell(
              onTap: onTapSuffixIcon,
              child: Icon(
                !obscureText
                  ? Icons.remove_circle
                  : Icons.remove_red_eye
              ),
            )
          : null,
      ),
      
    );
  }
}