// @dart=2.9
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ButtonGeneral extends StatelessWidget {
  ButtonGeneral({
    Key key,
    @required this.label,
    @required this.icon,
    @required this.onPressedCallback,
    @required this.onLongPressedCallback,
    this.enable = true,
  }) : super(key: key);

  final Widget label;
  final Icon icon;
  final Function onPressedCallback;
  final Function onLongPressedCallback;
  bool enable;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      label: label,
      icon: icon,
      onPressed: enable ? () => onPressedCallback() : null,
      onLongPress: enable ? () => onLongPressedCallback() : null,
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
