import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextFormField extends StatelessWidget {
  const CustomTextFormField({
    super.key,
    required this.controller,
    this.hintText,
    this.validator,
    this.suffixIcon,
    this.onTap,
    this.keyboardType,
    this.inputFormatters,
    this.readOnly = false,
    this.focusNode,
    this.prefixIcon,
    this.textInputAction,
    this.onFieldSubmitted,
    
  });
  final TextEditingController? controller;
  final String? hintText;
  final Widget? suffixIcon;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final List<TextInputFormatter>? inputFormatters;
  final Function()? onTap;
  final bool readOnly;
  final FocusNode? focusNode;
  final Widget? prefixIcon;
  final TextInputAction? textInputAction;
  final Function(String)? onFieldSubmitted;
  

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      focusNode: focusNode,
      textInputAction: textInputAction,
      readOnly: readOnly,
      decoration: InputDecoration(
        prefixIcon: prefixIcon,
        
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(width: 2, color: Colors.grey[700]!),
          borderRadius: BorderRadius.circular(10),
        ),
        border: OutlineInputBorder(
          borderSide: BorderSide(width: 2, color: Color(0xFF6C63FF)),
          borderRadius: BorderRadius.circular(10),
        ),
        hintText: hintText,
        suffixIcon: suffixIcon,
      ),
      validator: validator,
      onFieldSubmitted: onFieldSubmitted,
      inputFormatters: inputFormatters,
      onTap: onTap,
    );
  }
}
