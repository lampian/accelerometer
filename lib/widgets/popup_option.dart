// @dart=2.9
import 'package:flutter/material.dart';

class PopupOption extends StatelessWidget {
  PopupOption({
    Key key,
    this.options,
    this.callBack,
    this.icon,
  }) : super(key: key);
  final List<PopupItem> options;
  final dynamic Function(PopupItem popupItem) callBack;
  final Icon icon;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
        icon: icon,
        onSelected: callBack,
        itemBuilder: (_) => options
            .map((e) => PopupMenuItem(
                value: e,
                child: Row(
                  children: [
                    Icon(e.icon),
                    SizedBox(width: 8),
                    Text(e.title),
                  ],
                ))) //Row( Text(e.title))))
            .toList());
  }
}

class PopupItem {
  PopupItem({this.title, this.icon});
  String title;
  IconData icon;
}
