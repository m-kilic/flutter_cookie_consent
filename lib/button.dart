import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CookieConsentButton extends StatelessWidget {
  const CookieConsentButton({
    required this.onPressed,
    required this.label,
    this.icon,
    this.useCupertino = false,
    this.isPrimary = false,
    this.isDestructive = false,
    super.key,
  });

  final void Function() onPressed;
  final String? label;
  final IconData? icon;
  final bool useCupertino;
  final bool isPrimary;
  final bool isDestructive;

  @override
  Widget build(BuildContext context) {
    Widget child = Text(
      label ?? '',
      style: TextStyle(color: isPrimary ? null : Colors.black),
    );
    if (icon != null) {
      child = Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: isPrimary ? null : Colors.grey.shade600),
          const SizedBox(width: 8.0),
          child,
        ],
      );
    }
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: useCupertino
          ? LimitedBox(
              maxWidth: 200,
              child: CupertinoDialogAction(
                onPressed: onPressed,
                isDefaultAction: isPrimary,
                isDestructiveAction: isDestructive,
                child: child,
              ),
            )
          : ElevatedButton(
              onPressed: onPressed,
              style: ButtonStyle(
                  backgroundColor: isDestructive
                      ? MaterialStateProperty.all(Colors.red)
                      : !isPrimary
                          ? MaterialStateProperty.all(Colors.grey.shade300)
                          : null),
              child: child,
            ),
    );
  }
}
