## Advance Custom Toast for Flutter Application (Cros Platfrom)

* Local & network image support
* Circle image option (avatar style)
* Image position: left / right / top / bottom
* Customizable background, text style, size, duration, position
* Animations (fade / slide)
* Works across **all platforms**

---

## 🔥 `toast.dart`
<details>
<summary>👉 VIEW FULL TOAST.dart HERE </summary>
  
```dart
import 'package:flutter/material.dart';

enum ToastPosition { top, bottom, center }
enum ToastAnimation { fade, slide }
enum ToastImagePosition { left, right, top, bottom }

class Toast {
  static final List<_ToastRequest> _queue = [];
  static bool _isShowing = false;

  static void show(
    BuildContext context, {
    required String message,
    Color textColor = Colors.white,
    Color backgroundColor = Colors.black87,
    double fontSize = 14,
    double borderRadius = 8,
    Duration duration = const Duration(seconds: 2),
    Duration animDuration = const Duration(milliseconds: 300),
    ToastPosition position = ToastPosition.bottom,
    ToastAnimation animation = ToastAnimation.fade,
    double maxWidthFactor = 0.8,
    double paddingH = 16,
    double paddingV = 12,
    String? img,
    bool circleImg = false,
    ToastImagePosition imgPosition = ToastImagePosition.left,
    double imgSize = 40,
  }) {
    _queue.add(
      _ToastRequest(
        context: context,
        message: message,
        textColor: textColor,
        backgroundColor: backgroundColor,
        fontSize: fontSize,
        borderRadius: borderRadius,
        duration: duration,
        animDuration: animDuration,
        position: position,
        animation: animation,
        maxWidthFactor: maxWidthFactor,
        paddingH: paddingH,
        paddingV: paddingV,
        img: img,
        circleImg: circleImg,
        imgPosition: imgPosition,
        imgSize: imgSize,
      ),
    );

    if (!_isShowing) {
      _showNext();
    }
  }

  static void _showNext() {
    if (_queue.isEmpty) {
      _isShowing = false;
      return;
    }

    _isShowing = true;
    final request = _queue.removeAt(0);

    final overlay = Overlay.of(request.context);
    final overlayEntry = OverlayEntry(
      builder: (context) {
        return _ToastWidget(
          request: request,
          onDismissed: () {
            overlayEntry.remove();
            _showNext(); // show next toast in queue
          },
        );
      },
    );

    overlay.insert(overlayEntry);
  }
}

/// Internal request object
class _ToastRequest {
  final BuildContext context;
  final String message;
  final Color textColor;
  final Color backgroundColor;
  final double fontSize;
  final double borderRadius;
  final Duration duration;
  final Duration animDuration;
  final ToastPosition position;
  final ToastAnimation animation;
  final double maxWidthFactor;
  final double paddingH;
  final double paddingV;
  final String? img;
  final bool circleImg;
  final ToastImagePosition imgPosition;
  final double imgSize;

  _ToastRequest({
    required this.context,
    required this.message,
    required this.textColor,
    required this.backgroundColor,
    required this.fontSize,
    required this.borderRadius,
    required this.duration,
    required this.animDuration,
    required this.position,
    required this.animation,
    required this.maxWidthFactor,
    required this.paddingH,
    required this.paddingV,
    this.img,
    this.circleImg = false,
    this.imgPosition = ToastImagePosition.left,
    this.imgSize = 40,
  });
}

class _ToastWidget extends StatefulWidget {
  final _ToastRequest request;
  final VoidCallback onDismissed;

  const _ToastWidget({Key? key, required this.request, required this.onDismissed})
      : super(key: key);

  @override
  State<_ToastWidget> createState() => _ToastWidgetState();
}

class _ToastWidgetState extends State<_ToastWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: widget.request.animDuration);
    _fadeAnimation = Tween(begin: 0.0, end: 1.0).animate(_controller);
    _slideAnimation = Tween(
      begin: const Offset(0, 0.3),
      end: const Offset(0, 0),
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _controller.forward();
    Future.delayed(widget.request.duration, () {
      _controller.reverse().then((_) => widget.onDismissed());
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _buildImage() {
    if (widget.request.img == null) return const SizedBox.shrink();
    final imgWidget = widget.request.img!.startsWith("http")
        ? Image.network(widget.request.img!,
            width: widget.request.imgSize,
            height: widget.request.imgSize,
            fit: BoxFit.cover)
        : Image.asset(widget.request.img!,
            width: widget.request.imgSize,
            height: widget.request.imgSize,
            fit: BoxFit.cover);

    return widget.request.circleImg
        ? ClipOval(child: imgWidget)
        : ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: imgWidget,
          );
  }

  Widget _buildContent() {
    final imgWidget = _buildImage();
    switch (widget.request.imgPosition) {
      case ToastImagePosition.left:
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (widget.request.img != null) ...[imgWidget, const SizedBox(width: 8)],
            Flexible(
              child: Text(widget.request.message,
                  style: TextStyle(
                      color: widget.request.textColor,
                      fontSize: widget.request.fontSize)),
            ),
          ],
        );
      case ToastImagePosition.right:
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
              child: Text(widget.request.message,
                  style: TextStyle(
                      color: widget.request.textColor,
                      fontSize: widget.request.fontSize)),
            ),
            if (widget.request.img != null) ...[const SizedBox(width: 8), imgWidget],
          ],
        );
      case ToastImagePosition.top:
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (widget.request.img != null) ...[imgWidget, const SizedBox(height: 6)],
            Text(widget.request.message,
                style: TextStyle(
                    color: widget.request.textColor,
                    fontSize: widget.request.fontSize)),
          ],
        );
      case ToastImagePosition.bottom:
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(widget.request.message,
                style: TextStyle(
                    color: widget.request.textColor,
                    fontSize: widget.request.fontSize)),
            if (widget.request.img != null) ...[const SizedBox(height: 6), imgWidget],
          ],
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget toastContent = Container(
      padding: EdgeInsets.symmetric(
          horizontal: widget.request.paddingH, vertical: widget.request.paddingV),
      decoration: BoxDecoration(
        color: widget.request.backgroundColor,
        borderRadius: BorderRadius.circular(widget.request.borderRadius),
      ),
      constraints: BoxConstraints(
        maxWidth:
            MediaQuery.of(context).size.width * widget.request.maxWidthFactor,
      ),
      child: _buildContent(),
    );

    if (widget.request.animation == ToastAnimation.fade) {
      toastContent = FadeTransition(opacity: _fadeAnimation, child: toastContent);
    } else {
      toastContent = SlideTransition(position: _slideAnimation, child: toastContent);
    }

    return Positioned(
      top: widget.request.position == ToastPosition.top ? 50 : null,
      bottom: widget.request.position == ToastPosition.bottom ? 50 : null,
      left: 0,
      right: 0,
      child: Material(color: Colors.transparent, child: Center(child: toastContent)),
    );
  }
}

```
</details>

# 🔥 All Usage Examples

### 1. **Simple Toast**

```dart
Toast.show(context, message: "Hello World!");
```

---

### 2. **Multiple Toasts (Queue support)**

```dart
Toast.show(context, message: "First message");
Toast.show(context, message: "Second message");
Toast.show(context, message: "Third message");
// ekta ekta kore sequentially show hobe
```

---

### 3. **Custom Colors + Font**

```dart
Toast.show(
  context,
  message: "Saved Successfully!",
  backgroundColor: Colors.green,
  textColor: Colors.white,
  fontSize: 18,
);
```

---

### 4. **Top Position + Slide Animation**

```dart
Toast.show(
  context,
  message: "Upload Complete",
  position: ToastPosition.top,
  animation: ToastAnimation.slide,
  backgroundColor: Colors.blue,
  duration: Duration(seconds: 3),
);
```

---

### 5. **Center Position + Fade**

```dart
Toast.show(
  context,
  message: "Processing...",
  position: ToastPosition.center,
  animation: ToastAnimation.fade,
  backgroundColor: Colors.orange,
);
```

---

### 6. **Toast with Local Image (Left)**

```dart
Toast.show(
  context,
  message: "Profile Updated",
  img: "assets/user.png",
  imgPosition: ToastImagePosition.left,
);
```

---

### 7. **Toast with Network Image (Right)**

```dart
Toast.show(
  context,
  message: "New Message!",
  img: "https://via.placeholder.com/150",
  imgPosition: ToastImagePosition.right,
);
```

---

### 8. **Toast with Circle Image (Avatar style)**

```dart
Toast.show(
  context,
  message: "Welcome Back!",
  img: "https://via.placeholder.com/150",
  circleImg: true,
  imgPosition: ToastImagePosition.left,
);
```

---

### 9. **Toast with Image on Top**

```dart
Toast.show(
  context,
  message: "Upload Finished",
  img: "assets/success.png",
  imgPosition: ToastImagePosition.top,
  backgroundColor: Colors.black87,
);
```

---

### 10. **Toast with Image on Bottom**

```dart
Toast.show(
  context,
  message: "Warning: Low Battery",
  img: "assets/warning.png",
  imgPosition: ToastImagePosition.bottom,
  backgroundColor: Colors.redAccent,
);
```

---

### 11. **Custom Size + Padding**

```dart
Toast.show(
  context,
  message: "This is a large toast with custom width and padding",
  maxWidthFactor: 0.9,
  paddingH: 24,
  paddingV: 16,
  backgroundColor: Colors.deepPurple,
  textColor: Colors.white,
  fontSize: 18,
);
```

---

### 12. **Long Duration Toast**

```dart
Toast.show(
  context,
  message: "This will stay for 5 seconds",
  duration: Duration(seconds: 5),
  backgroundColor: Colors.teal,
);
```

---

### 13. **Rounded Toast**

```dart
Toast.show(
  context,
  message: "Rounded Toast",
  borderRadius: 30,
  backgroundColor: Colors.pinkAccent,
);
```

---

### 14. **Queued Toasts with Images**

```dart
Toast.show(context, message: "Downloading...", img: "assets/download.png");
Toast.show(context, message: "Processing...", img: "assets/process.png");
Toast.show(context, message: "Complete!", img: "assets/success.png");
```

---

## ⚡ Summary

* **Text only** → just `message`
* **Custom style** → colors, font, size, radius, padding
* **Position** → top, bottom, center
* **Animation** → fade or slide
* **Image** → local / network / circle / any position
* **Queue system** → multiple toasts ek sathe sequentially

---
