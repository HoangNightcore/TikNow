import 'package:flutter/material.dart';

class CustomCheckbox extends StatelessWidget {
  final bool value;
  final ValueChanged<bool?> onChanged;
  final String text;
  final String linkText;
  final VoidCallback? onLinkPressed;
  const CustomCheckbox({
    Key? key,
    required this.value,
    required this.onChanged,
    required this.text,
    this.linkText = '',
    this.onLinkPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 20,
          height: 20,
          // margin: const EdgeInsets.only(top: 0),
          decoration: BoxDecoration(
            border: Border.all(
              color: value
                  ? const Color.fromRGBO(252, 196, 52, 1)
                  : Colors.white,
              width: 2,
            ),
            borderRadius: BorderRadius.circular(4),
            color: value
                ? const Color.fromRGBO(252, 196, 52, 1)
                : Colors.transparent,
          ),
          child: value
              ? const Icon(Icons.check, size: 16, color: Colors.black)
              : null,
        ),
        const SizedBox(width: 12),
        Flexible(
          fit: FlexFit.loose,
          child: GestureDetector(
            onTap: () => onChanged(!value),
            child: RichText(
              text: TextSpan(
                text: text,
                style: const TextStyle(color: Colors.white, fontSize: 16),
                children: linkText.isNotEmpty
                    ? [
                        TextSpan(
                          text: linkText,
                          style: const TextStyle(
                            color: Color(0xFFFDE047),
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ]
                    : null,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
