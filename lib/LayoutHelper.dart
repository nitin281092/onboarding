import 'package:flutter/cupertino.dart';

class CenterHorizontal extends StatelessWidget {
  CenterHorizontal(this.child);
  final Widget child;

  @override
  Widget build(BuildContext context) => Padding(
      padding: EdgeInsets.all(15),
      child:
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [child]));
}

class TextColumn extends StatelessWidget {
  final String head;
  final String value;
  TextColumn(this.head, this.value);

  @override
  Widget build(BuildContext context) => Padding(
      padding: EdgeInsets.all(15),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
              flex: 2,
              child: Text(head, style: TextStyle(fontWeight: FontWeight.bold))),
          Expanded(
              child: Text(":", style: TextStyle(fontWeight: FontWeight.bold))),
          Expanded(flex: 3, child: Text(value)),
        ],
      ));
}
