import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';

class PageView extends StatefulWidget {
  final List<Widget> pages;
  final int current;
  final Color color;

  PageView({
    Key key,
    @required this.pages,
    @required this.current,
    this.color = Colors.white,
  }) : super(key: key);

  @override
  PageViewState createState() => PageViewState();
}

class PageViewState extends State<PageView>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  final Duration duration = Duration(milliseconds: 400);
  int current;
  int showPage;
  List<Widget> pages;
  Animation curve;
  Animation<double> animation;
  double circleRadius = 0;
  @override
  void initState() {
    _controller = new AnimationController(
      duration: duration,
      vsync: this,
    );
    _controller.addListener(() {
      _controller.value;
    });
    curve = CurvedAnimation(parent: _controller, curve: Curves.easeOut);
    this.pages = widget.pages;
    this.current = widget.current;
    this.showPage = widget.current;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final double displayHeight =
        MediaQuery.of(context).size.height.toDouble() * 1.5;
    if (this.current != widget.current) {
      this.current = widget.current;
      _controller.reset();
      animation = Tween<double>(begin: current.toDouble(), end: displayHeight)
          .animate(curve)
            ..addListener(() {
              setState(() {
                final double displayHeightHalf = displayHeight / 2;
                if (animation.value < displayHeightHalf) {
                  circleRadius = animation.value * 2;
                } else {
                  circleRadius = displayHeight - animation.value;
                  if (showPage != current) {
                    showPage = current;
                  }
                }
              });
            });
      _controller.forward();
    }
    return Container(child: _body());
  }

  Widget _body() {
    if (circleRadius == 0) {
      return this.pages[this.showPage];
    } else {
      return Stack(
        children: <Widget>[
          Positioned(
            child: this.pages[this.showPage],
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            top: 0,
            child: CustomPaint(
              painter:
                  PageShapesPainter(radius: circleRadius, color: widget.color),
            ),
          ),
        ],
      );
    }
  }
}

class PageShapesPainter extends CustomPainter {
  final double radius;
  final Color color;
  PageShapesPainter({
    this.radius = 0,
    this.color,
  });
  @override
  void paint(Canvas canvas, Size size) {
    double itemWidth = size.width / 2;
    double itemHeight = size.height / 2;
    final paint = Paint();
    paint.color = color;
    var center = Offset(itemWidth, itemHeight);
    canvas.drawCircle(center, radius, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
