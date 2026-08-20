import 'package:flutter/material.dart';

class CustomTextField extends StatefulWidget {
  final String label;
  final TextEditingController textEditingController;
  final bool obsecure;
  final TextInputType textInputType;
  final Widget prefixIcon;
  final String? Function(String?)? validator;

  const CustomTextField({
    super.key,
    required this.label,
    required this.textEditingController,
    required this.obsecure,
    required this.textInputType,
    required this.prefixIcon,
    this.validator,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  final FocusNode focusNode = FocusNode();

  @override
  void dispose() {
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: TextFormField(
        style: Theme.of(context).textTheme.bodyLarge,
        validator: widget.validator,
        cursorColor: colors.primary,
        focusNode: focusNode,
        controller: widget.textEditingController,
        obscureText: widget.obsecure,
        keyboardType: widget.textInputType,
        decoration: InputDecoration(
          prefixIcon: widget.prefixIcon,
          prefixIconColor: colors.primary,
          labelText: widget.label,
        ),
      ),
    );
  }
}
