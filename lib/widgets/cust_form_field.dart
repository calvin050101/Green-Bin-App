import 'package:flutter/material.dart';

class CustFormField extends StatefulWidget {
  final TextEditingController controller;
  final TextInputType keyboardType;
  final String hintText;
  final bool isPassword;

  const CustFormField({
    super.key,
    required this.controller,
    required this.keyboardType,
    required this.hintText,
    required this.isPassword,
  });

  @override
  State<CustFormField> createState() => _CustFormFieldState();
}

class _CustFormFieldState extends State<CustFormField> {
  @override
  Widget build(BuildContext context) {
    final OutlineInputBorder fieldBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(10.0),
      borderSide: const BorderSide(color: Colors.green, width: 2.0),
    );

    return TextFormField(
      controller: widget.controller,
      obscureText: widget.isPassword,
      keyboardType: widget.keyboardType,
      decoration: InputDecoration(
        hintText: widget.hintText,
        hintStyle: TextStyle(color: Colors.brown[400]),
        filled: true,
        fillColor: Colors.transparent,
        border: fieldBorder,
        enabledBorder: fieldBorder,
        focusedBorder: fieldBorder,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16.0,
          vertical: 12.0,
        ),
      ),
      style: TextStyle(
        color: Colors.brown[700],
        fontFamily: 'Montserrat',
        fontSize: 16,
      ),
    );
  }
}
