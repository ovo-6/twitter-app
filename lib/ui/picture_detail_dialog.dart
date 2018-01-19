import 'package:flutter/material.dart';


class PictureDetailDialog extends StatelessWidget {
  /// Creates a dialog.
  ///
  /// Typically used in conjunction with [showDialog].
  const PictureDetailDialog({
    Key key,
    this.child,
  }) : super(key: key);

  /// The widget below this widget in the tree.
  final Widget child;

  Color _getColor(BuildContext context) {
    return Theme.of(context).dialogBackgroundColor;
  }

  @override
  Widget build(BuildContext context) {
    return new Center(
        child: new Container(
            margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
            child: new ConstrainedBox(
                constraints: const BoxConstraints(minWidth: 280.0),
                child: new Material(
                    elevation: 24.0,
                    color: _getColor(context),
                    type: MaterialType.card,
                    child: child
                )
            )
        )
    );
  }
}
