# Custom Flutter Dialog

A versatile, smooth, and fully customizable dialog for Flutter with support for:

- Title & message
- Up to 3 buttons with automatic alignment
- Image or GIF (local or network)
- Slide or fade animations
- Positioning: top, center, bottom
- Markdown-style text: \*\*bold\*\* and \_\_italic\_\_
- Auto-dismiss after a duration
- Queue support (multiple dialogs show one by one)

---

## Installation

Simply copy `dialog.dart` into your Flutter project and import:
- lib/dialog.dart
```dart
import 'dialog.dart';
```
**OR**
- lib/utils/dialog.dart
```dart
import 'dialog.dart';
```
## 🤐 GET CODE
<details>
  <summary>
    SEE Dialog.dart
  </summary>
  
  ```dart
import 'package:flutter/material.dart';

enum DialogPosition { center, top, bottom }
enum DialogAnimation { fade, slide }
enum DialogMediaPosition { top, bottom, left, right }

class CustomDialog {
  static final List<_DialogRequest> _queue = [];
  static bool _isShowing = false;

  static void show(
    BuildContext context, {
    required String title,
    String? message,
    String? mediaPath, // image/gif/icon
    bool mediaIsGif = false,
    DialogMediaPosition mediaPosition = DialogMediaPosition.top,
    Color titleColor = Colors.black,
    Color messageColor = Colors.black87,
    Color backgroundColor = Colors.white,
    double borderRadius = 12,
    double fontSizeTitle = 18,
    double fontSizeMessage = 14,
    Duration duration = const Duration(seconds: 0),
    Duration animDuration = const Duration(milliseconds: 300),
    DialogPosition position = DialogPosition.center,
    DialogAnimation animation = DialogAnimation.fade,
    List<DialogButton>? buttons,
    MainAxisAlignment? buttonsAlignment,
    EdgeInsetsGeometry? padding,
  }) {
    _queue.add(
      _DialogRequest(
        context: context,
        title: title,
        message: message,
        mediaPath: mediaPath,
        mediaIsGif: mediaIsGif,
        mediaPosition: mediaPosition,
        titleColor: titleColor,
        messageColor: messageColor,
        backgroundColor: backgroundColor,
        borderRadius: borderRadius,
        fontSizeTitle: fontSizeTitle,
        fontSizeMessage: fontSizeMessage,
        duration: duration,
        animDuration: animDuration,
        position: position,
        animation: animation,
        buttons: buttons,
        buttonsAlignment: buttonsAlignment,
        padding: padding ?? const EdgeInsets.all(16),
      ),
    );

    if (!_isShowing) _showNext();
  }

  static void _showNext() {
    if (_queue.isEmpty) {
      _isShowing = false;
      return;
    }

    _isShowing = true;
    final request = _queue.removeAt(0);
    final overlay = Overlay.of(request.context);
    late OverlayEntry overlayEntry;

    overlayEntry = OverlayEntry(
      builder: (context) => _DialogWidget(
        request: request,
        onDismissed: () {
          overlayEntry.remove();
          _showNext();
        },
      ),
    );

    overlay.insert(overlayEntry);
  }
}

/// Dialog button
class DialogButton {
  final String text;
  final VoidCallback onPressed;
  final Color? textColor;
  final Color? backgroundColor;

  DialogButton({required this.text, required this.onPressed, this.textColor, this.backgroundColor});
}

/// Internal request
class _DialogRequest {
  final BuildContext context;
  final String title;
  final String? message;
  final String? mediaPath;
  final bool mediaIsGif;
  final DialogMediaPosition mediaPosition;
  final Color titleColor;
  final Color messageColor;
  final Color backgroundColor;
  final double borderRadius;
  final double fontSizeTitle;
  final double fontSizeMessage;
  final Duration duration;
  final Duration animDuration;
  final DialogPosition position;
  final DialogAnimation animation;
  final List<DialogButton>? buttons;
  final MainAxisAlignment? buttonsAlignment;
  final EdgeInsetsGeometry padding;

  _DialogRequest({
    required this.context,
    required this.title,
    this.message,
    this.mediaPath,
    this.mediaIsGif = false,
    this.mediaPosition = DialogMediaPosition.top,
    required this.titleColor,
    required this.messageColor,
    required this.backgroundColor,
    required this.borderRadius,
    required this.fontSizeTitle,
    required this.fontSizeMessage,
    required this.duration,
    required this.animDuration,
    required this.position,
    required this.animation,
    this.buttons,
    this.buttonsAlignment,
    required this.padding,
  });
}

/// Helper function: parse **bold** and __italic__ text
TextSpan parseMarkdown(String text, {TextStyle? style}) {
  List<TextSpan> spans = [];
  final regex = RegExp(r'\*\*(.*?)\*\*|__(.*?)__');
  int lastIndex = 0;

  for (final match in regex.allMatches(text)) {
    if (match.start > lastIndex) {
      spans.add(TextSpan(text: text.substring(lastIndex, match.start), style: style));
    }
    if (match.group(1) != null) {
      spans.add(TextSpan(
          text: match.group(1),
          style: style?.copyWith(fontWeight: FontWeight.bold) ?? const TextStyle(fontWeight: FontWeight.bold)));
    } else if (match.group(2) != null) {
      spans.add(TextSpan(
          text: match.group(2),
          style: style?.copyWith(fontStyle: FontStyle.italic) ?? const TextStyle(fontStyle: FontStyle.italic)));
    }
    lastIndex = match.end;
  }

  if (lastIndex < text.length) {
    spans.add(TextSpan(text: text.substring(lastIndex), style: style));
  }

  return TextSpan(children: spans, style: style);
}

/// Dialog widget
class _DialogWidget extends StatefulWidget {
  final _DialogRequest request;
  final VoidCallback onDismissed;

  const _DialogWidget({Key? key, required this.request, required this.onDismissed}) : super(key: key);

  @override
  State<_DialogWidget> createState() => _DialogWidgetState();
}

class _DialogWidgetState extends State<_DialogWidget> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(vsync: this, duration: widget.request.animDuration);
    _fadeAnimation = Tween(begin: 0.0, end: 1.0).animate(_controller);
    _slideAnimation = Tween(begin: const Offset(0, 0.3), end: Offset.zero)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    WidgetsBinding.instance.addPostFrameCallback((_) => _controller.forward());

    if (widget.request.duration.inMilliseconds > 0) {
      Future.delayed(widget.request.duration, () async {
        await _controller.reverse();
        widget.onDismissed();
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _buildMedia() {
    if (widget.request.mediaPath == null) return const SizedBox.shrink();

    final mediaWidget = widget.request.mediaIsGif
        ? (widget.request.mediaPath!.startsWith("http")
            ? Image.network(widget.request.mediaPath!, width: 150, height: 150)
            : Image.asset(widget.request.mediaPath!, width: 150, height: 150))
        : Icon(Icons.image, size: 60, color: Colors.grey);

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: mediaWidget,
    );
  }

  Widget _buildText(String text, TextStyle style) {
    return Text.rich(parseMarkdown(text, style: style));
  }

  Widget _buildButtons() {
    if (widget.request.buttons == null || widget.request.buttons!.isEmpty) return const SizedBox.shrink();

    int count = widget.request.buttons!.length;
    List<Widget> btnWidgets = [];

    for (var i = 0; i < count; i++) {
      final b = widget.request.buttons![i];
      btnWidgets.add(
        Flexible(
          fit: count == 1 ? FlexFit.loose : FlexFit.tight,
          child: ElevatedButton(
            onPressed: () {
              b.onPressed();
              widget.onDismissed();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: b.backgroundColor ?? Theme.of(context).primaryColor,
            ),
            child: Text.rich(
              parseMarkdown(b.text, style: TextStyle(color: b.textColor ?? Colors.white)),
            ),
          ),
        ),
      );
    }

    MainAxisAlignment alignment = widget.request.buttonsAlignment ??
        (count == 1
            ? MainAxisAlignment.end
            : count == 2
                ? MainAxisAlignment.spaceBetween
                : MainAxisAlignment.spaceEvenly);

    return Row(mainAxisAlignment: alignment, children: btnWidgets);
  }

  Widget _buildDialogContent() {
    List<Widget> children = [];

    switch (widget.request.mediaPosition) {
      case DialogMediaPosition.top:
        if (widget.request.mediaPath != null) children.add(_buildMedia());
        if (widget.request.title.isNotEmpty)
          children.add(_buildText(widget.request.title,
              TextStyle(fontSize: widget.request.fontSizeTitle, color: widget.request.titleColor)));
        if (widget.request.message != null)
          children.add(_buildText(widget.request.message!,
              TextStyle(fontSize: widget.request.fontSizeMessage, color: widget.request.messageColor)));
        break;
      case DialogMediaPosition.bottom:
        if (widget.request.title.isNotEmpty)
          children.add(_buildText(widget.request.title,
              TextStyle(fontSize: widget.request.fontSizeTitle, color: widget.request.titleColor)));
        if (widget.request.message != null)
          children.add(_buildText(widget.request.message!,
              TextStyle(fontSize: widget.request.fontSizeMessage, color: widget.request.messageColor)));
        if (widget.request.mediaPath != null) children.add(_buildMedia());
        break;
      case DialogMediaPosition.left:
      case DialogMediaPosition.right:
        children.add(Row(
          mainAxisSize: MainAxisSize.min,
          children: widget.request.mediaPosition == DialogMediaPosition.left
              ? [
                  if (widget.request.mediaPath != null) _buildMedia(),
                  const SizedBox(width: 8),
                  Flexible(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (widget.request.title.isNotEmpty)
                          _buildText(widget.request.title,
                              TextStyle(fontSize: widget.request.fontSizeTitle, color: widget.request.titleColor)),
                        if (widget.request.message != null)
                          _buildText(widget.request.message!,
                              TextStyle(fontSize: widget.request.fontSizeMessage, color: widget.request.messageColor)),
                      ],
                    ),
                  ),
                ]
              : [
                  Flexible(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (widget.request.title.isNotEmpty)
                          _buildText(widget.request.title,
                              TextStyle(fontSize: widget.request.fontSizeTitle, color: widget.request.titleColor)),
                        if (widget.request.message != null)
                          _buildText(widget.request.message!,
                              TextStyle(fontSize: widget.request.fontSizeMessage, color: widget.request.messageColor)),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  if (widget.request.mediaPath != null) _buildMedia(),
                ],
        ));
        break;
    }

    children.add(const SizedBox(height: 12));
    children.add(_buildButtons());

    return Column(mainAxisSize: MainAxisSize.min, children: children);
  }

  @override
  Widget build(BuildContext context) {
    Widget content = Container(
      padding: widget.request.padding,
      decoration: BoxDecoration(
        color: widget.request.backgroundColor,
        borderRadius: BorderRadius.circular(widget.request.borderRadius),
      ),
      child: _buildDialogContent(),
    );

    if (widget.request.animation == DialogAnimation.fade) {
      content = FadeTransition(opacity: _fadeAnimation, child: content);
    } else {
      content = SlideTransition(position: _slideAnimation, child: content);
    }

    return Positioned(
      top: widget.request.position == DialogPosition.top ? 50 : null,
      bottom: widget.request.position == DialogPosition.bottom ? 50 : null,
      left: 20,
      right: 20,
      child: Material(color: Colors.transparent, child: Center(child: content)),
    );
  }
}

  ```

</details>

## 1️⃣ Basic Dialog (title + message)

```dart
CustomDialog.show(
  context,
  title: "Hello",
  message: "This is a simple message",
);
```

* No media, no buttons, just title and message.
* Closes manually (duration=0).

---

## 2️⃣ Dialog with single button

```dart
CustomDialog.show(
  context,
  title: "Notice",
  message: "Click OK to continue",
  buttons: [
    DialogButton(
      text: "OK",
      onPressed: () => print("OK pressed"),
    ),
  ],
);
```

* Single button aligns **right** by default.

---

## 3️⃣ Dialog with two buttons

```dart
CustomDialog.show(
  context,
  title: "Confirm",
  message: "Do you want to delete?",
  buttons: [
    DialogButton(
      text: "Cancel",
      onPressed: () => print("Cancel pressed"),
      backgroundColor: Colors.grey,
    ),
    DialogButton(
      text: "Delete",
      onPressed: () => print("Delete pressed"),
      backgroundColor: Colors.red,
    ),
  ],
);
```

* Two buttons align **left + right** automatically.

---

## 4️⃣ Dialog with three buttons

```dart
CustomDialog.show(
  context,
  title: "Choose option",
  message: "Select one of the following",
  buttons: [
    DialogButton(text: "Option 1", onPressed: () => print("1")),
    DialogButton(text: "Option 2", onPressed: () => print("2")),
    DialogButton(text: "Option 3", onPressed: () => print("3")),
  ],
);
```

* Three buttons align **left, center, right**.
* Supports custom colors/texts for each button.

---

## 5️⃣ Dialog with **image/gif** (top, local)

```dart
CustomDialog.show(
  context,
  title: "Awesome GIF",
  message: "Look at this animation",
  mediaPath: "assets/sample.gif",
  mediaIsGif: true,
  mediaPosition: DialogMediaPosition.top,
);
```

* Image/GIF appears **above the title**.
* Works with local assets.

---

## 6️⃣ Dialog with **image/gif** (bottom, network)

```dart
CustomDialog.show(
  context,
  title: "Network Image",
  message: "This image is loaded from the web",
  mediaPath: "https://example.com/sample.png",
  mediaPosition: DialogMediaPosition.bottom,
);
```

* Image appears **below the message**.
* Supports any URL image.

---

## 7️⃣ Dialog with **image left/right**

```dart
// Media left
CustomDialog.show(
  context,
  title: "Left Image",
  message: "Image is on the left",
  mediaPath: "assets/sample.png",
  mediaPosition: DialogMediaPosition.left,
);

// Media right
CustomDialog.show(
  context,
  title: "Right Image",
  message: "Image is on the right",
  mediaPath: "assets/sample.png",
  mediaPosition: DialogMediaPosition.right,
);
```

* Image and text arranged **side by side** automatically.

---

## 8️⃣ Dialog with **Markdown style text**

```dart
CustomDialog.show(
  context,
  title: "Markdown Demo",
  message: "This is **bold** and __italic__ text",
);
```

* Supports `**bold**` and `__italic__` in the message.

---

## 9️⃣ Dialog with **auto dismiss** (duration)

```dart
CustomDialog.show(
  context,
  title: "Auto Dismiss",
  message: "This will close in 3 seconds",
  duration: const Duration(seconds: 3),
);
```

* No button needed, closes automatically after the duration.

---

## 🔟 Dialog **custom animation** & position

```dart
CustomDialog.show(
  context,
  title: "Slide Top",
  message: "Dialog slides in from bottom",
  animation: DialogAnimation.slide,
  position: DialogPosition.top,
);
```

* Animations: `fade` (default) or `slide`.
* Positions: `center` (default), `top`, `bottom`.
---
### ✅ Notes

* Max buttons: 3 (layout auto-adjusts).
* Media: only **image/gif** (local or network).
* Messages support **inline bold/italic**.
* Auto dismiss works via `duration`.
* Overlay queue ensures multiple dialogs show one by one.
