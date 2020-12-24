import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ButtonGeneral extends StatelessWidget {
  const ButtonGeneral({
    Key key,
    @required this.label,
    @required this.icon,
    @required this.onPressedCallback,
    @required this.onLongPressedCallback,
  }) : super(key: key);

  final Widget label;
  final Icon icon;
  final Function onPressedCallback;
  final Function onLongPressedCallback;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      label: label,
      icon: icon,
      onPressed: () => onPressedCallback(),
      onLongPress: () => onLongPressedCallback(),
      style: ElevatedButton.styleFrom(
        primary: Colors.blueGrey[600],
        elevation: 15.0,
        shadowColor: Colors.grey[700],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
          side: BorderSide(
              color: Get
                  .theme.buttonTheme.colorScheme.primaryVariant), //.grey[600]),
        ),
      ),
    );
  }
}
