import 'package:flutter/material.dart';

import 'cust_form_field.dart';

class PasswordFormField extends CustFormField {
  const PasswordFormField({
    super.key,
    required super.controller,
    super.hintText = "Enter your password",
  }) : super(keyboardType: TextInputType.text);

  @override
  PasswordFormFieldState createState() => PasswordFormFieldState();
}

class PasswordFormFieldState extends CustFormFieldState {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    final OutlineInputBorder fieldBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(10.0),
      borderSide: const BorderSide(color: Colors.green, width: 2.0),
    );

    return TextFormField(
      controller: widget.controller,
      obscureText: _obscureText,
      keyboardType: TextInputType.text,
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
        suffixIcon: IconButton(
          icon: Icon(
            _obscureText ? Icons.visibility_off : Icons.visibility,
            color: Colors.brown[400],
          ),
          onPressed: () {
            setState(() {
              _obscureText = !_obscureText;
            });
          },
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
