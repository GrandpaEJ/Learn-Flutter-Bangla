import 'package:flutter/material.dart';

enum ToastPosition { top, bottom, center }
enum ToastAnimation { fade, slide }
enum ToastImagePosition { left, right, top, bottom }

class Toast {
  /// Show a new toast (stacking)
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
    final overlay = Overlay.of(context);
    late OverlayEntry overlayEntry;

    overlayEntry = OverlayEntry(
      builder: (context) => _ToastWidget(
        request: _ToastRequest(
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
        onDismissed: () => overlayEntry.remove(),
      ),
    );

    overlay.insert(overlayEntry);
  }
}

/// Internal toast request object
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

/// Toast widget with animation
class _ToastWidget extends StatefulWidget {
  final _ToastRequest request;
  final VoidCallback onDismissed;

  const _ToastWidget({
    Key? key,
    required this.request,
    required this.onDismissed,
  }) : super(key: key);

  @override
  State<_ToastWidget> createState() => _ToastWidgetState();
}

class _ToastWidgetState extends State<_ToastWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: widget.request.animDuration,
    );

    _fadeAnimation = Tween(begin: 0.0, end: 1.0).animate(_controller);
    _slideAnimation = Tween(
      begin: const Offset(0, 0.3),
      end: const Offset(0, 0),
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _controller.forward();

    Future.delayed(widget.request.duration, () async {
      await _controller.reverse();
      widget.onDismissed();
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
        ? Image.network(
            widget.request.img!,
            width: widget.request.imgSize,
            height: widget.request.imgSize,
            fit: BoxFit.cover,
          )
        : Image.asset(
            widget.request.img!,
            width: widget.request.imgSize,
            height: widget.request.imgSize,
            fit: BoxFit.cover,
          );

    return widget.request.circleImg
        ? ClipOval(child: imgWidget)
        : ClipRRect(borderRadius: BorderRadius.circular(6), child: imgWidget);
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
              child: Text(
                widget.request.message,
                style: TextStyle(
                  color: widget.request.textColor,
                  fontSize: widget.request.fontSize,
                ),
              ),
            ),
          ],
        );

      case ToastImagePosition.right:
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
              child: Text(
                widget.request.message,
                style: TextStyle(
                  color: widget.request.textColor,
                  fontSize: widget.request.fontSize,
                ),
              ),
            ),
            if (widget.request.img != null) ...[const SizedBox(width: 8), imgWidget],
          ],
        );

      case ToastImagePosition.top:
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (widget.request.img != null) ...[imgWidget, const SizedBox(height: 6)],
            Text(
              widget.request.message,
              style: TextStyle(
                color: widget.request.textColor,
                fontSize: widget.request.fontSize,
              ),
            ),
          ],
        );

      case ToastImagePosition.bottom:
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              widget.request.message,
              style: TextStyle(
                color: widget.request.textColor,
                fontSize: widget.request.fontSize,
              ),
            ),
            if (widget.request.img != null) ...[const SizedBox(height: 6), imgWidget],
          ],
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget toastContent = Container(
      padding: EdgeInsets.symmetric(
        horizontal: widget.request.paddingH,
        vertical: widget.request.paddingV,
      ),
      decoration: BoxDecoration(
        color: widget.request.backgroundColor,
        borderRadius: BorderRadius.circular(widget.request.borderRadius),
      ),
      constraints: BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width * widget.request.maxWidthFactor,
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
      child: Material(
        color: Colors.transparent,
        child: Center(child: toastContent),
      ),
    );
  }
}
