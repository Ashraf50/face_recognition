import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget {
  final String title;
  final IconData? icon;
  final void Function()? onPressed;
  const CustomAppBar({
    super.key,
    required this.title,
    this.icon,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          onPressed: onPressed,
          icon: Icon(
            icon,
            color: Colors.black,
            size: 25,
          ),
        ),
        const SizedBox(
          width: 50,
        ),
        Text(
          title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w500,
            color: Color(0xffE06A39),
          ),
        ),
      ],
    );
  }
}
