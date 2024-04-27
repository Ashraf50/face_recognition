import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final Widget icon;
  final Function() onPressed;
  const CustomButton({
    super.key,
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5),
      child: Container(
        decoration: const BoxDecoration(
          color: Color(0xffE06A39),
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        child: IconButton(
          onPressed: onPressed,
          icon: icon,
          color: Colors.white,
        ),
      ),
    );
  }
}
