import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';

import '../../utils/focus.dart';

const kThreeLineTileHeight = 80.0;
const kTwoLineTileHeight = 52.0;
const kOneLineTileHeight = 48.0;

const kDefaultContentPadding = EdgeInsets.symmetric(
  horizontal: 12.0,
  vertical: 6.0,
);

class ListTile extends StatelessWidget {
  const ListTile({
    Key? key,
    this.tileColor,
    this.shape,
    this.leading,
    this.title,
    this.subtitle,
    this.isThreeLine = false,
    this.contentPadding = kDefaultContentPadding,
  })  : assert(
          subtitle != null ? title != null : true,
          'To have a subtitle, there must be a title',
        ),
        super(key: key);

  final Color? tileColor;
  final ShapeBorder? shape;

  final Widget? leading;
  final Widget? title;
  final Widget? subtitle;

  final bool isThreeLine;

  final EdgeInsetsGeometry contentPadding;

  bool get isTwoLine => subtitle != null;

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(ColorProperty('tileColor', tileColor));
    properties.add(FlagProperty('isThreeLine', value: isThreeLine));
    properties.add(DiagnosticsProperty('shape', shape));
    properties.add(DiagnosticsProperty<EdgeInsetsGeometry>(
      'contentPadding',
      contentPadding,
    ));
  }

  @override
  Widget build(BuildContext context) {
    debugCheckHasFluentTheme(context);
    final style = context.theme;
    return Container(
      decoration: ShapeDecoration(
        shape: shape ?? ContinuousRectangleBorder(),
        color: tileColor,
      ),
      height: isThreeLine
          ? kThreeLineTileHeight
          : isTwoLine
              ? kTwoLineTileHeight
              : kOneLineTileHeight,
      padding: contentPadding,
      child: Row(children: [
        if (leading != null)
          Padding(
            padding: EdgeInsets.only(right: 14),
            child: leading,
          ),
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (title != null)
                DefaultTextStyle(
                  child: title!,
                  style: (style.typography?.base ?? TextStyle()).copyWith(
                    fontSize: 16,
                  ),
                ),
              if (subtitle != null)
                DefaultTextStyle(
                  child: subtitle!,
                  style: style.typography?.body ?? TextStyle(),
                ),
            ],
          ),
        )
      ]),
    );
  }
}

class TappableListTile extends StatelessWidget {
  const TappableListTile({
    Key? key,
    this.tileColor,
    this.shape,
    this.leading,
    this.title,
    this.subtitle,
    this.isThreeLine = false,
    this.onTap,
    this.focusNode,
    this.autofocus = false,
    this.contentPadding = kDefaultContentPadding,
  }) : super(key: key);

  final VoidCallback? onTap;

  final ButtonState<Color>? tileColor;
  final ButtonState<ShapeBorder>? shape;

  final Widget? leading;
  final Widget? title;
  final Widget? subtitle;

  final bool isThreeLine;

  final FocusNode? focusNode;
  final bool autofocus;

  final EdgeInsetsGeometry contentPadding;

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(ObjectFlagProperty('onTap', onTap, ifNull: 'disabled'));
    properties.add(FlagProperty('autofocus', value: autofocus));
    properties.add(ObjectFlagProperty.has('focusNode', focusNode));
  }

  @override
  Widget build(BuildContext context) {
    debugCheckHasFluentTheme(context);
    final style = context.theme;
    return HoverButton(
      cursor: buttonCursor,
      onPressed: onTap,
      focusNode: focusNode,
      autofocus: autofocus,
      builder: (context, state) {
        final Color tileColor =
            this.tileColor?.call(state) ?? uncheckedInputColor(style, state);
        Widget child = ListTile(
          contentPadding: contentPadding,
          leading: leading,
          title: title,
          subtitle: subtitle,
          isThreeLine: isThreeLine,
          tileColor: tileColor,
          shape: shape?.call(state),
        );
        child = FocusBorder(
          child: child,
          focused: state.isFocused,
        );
        return child;
      },
    );
  }
}