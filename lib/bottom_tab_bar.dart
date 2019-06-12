import 'package:flutter/material.dart';
import 'package:flutter/animation.dart';
import 'dart:math' as math;

typedef void Callback(int page);

class BottomTabBar extends StatefulWidget {
  final List<IconData> items;
  final double selectedFontSize;
  final int current;
  final Color color;
  final Callback onPageChange;
  BottomTabBar({
    Key key,
    @required this.items,
    this.selectedFontSize = 14,
    this.current = 0,
    this.color = Colors.white,
    this.onPageChange,
  }) : super(key: key);

  @override
  BottomTabBarState createState() => BottomTabBarState();
}

class BottomTabBarState extends State<BottomTabBar>
    with SingleTickerProviderStateMixin {
  Animation<double> animation;
  AnimationController _controller;
  double backgroundPosition;
  final Duration duration = Duration(milliseconds: 300);
  Animation curve;
  int current;
  Color scaffoldColor;

  @override
  void initState() {
    _controller = new AnimationController(
      duration: duration,
      vsync: this,
    );
    curve = CurvedAnimation(parent: _controller, curve: Curves.easeOut);
    super.initState();
    current = widget.current;
    backgroundPosition = current.toDouble();
    scaffoldColor = Scaffold.of(context).widget.backgroundColor;
  }

  @override
  Widget build(BuildContext context) {
    final double additionalBottomPadding = math.max(
        MediaQuery.of(context).padding.bottom - widget.selectedFontSize / 2.0,
        0.0);
    return Semantics(
      explicitChildNodes: true,
      child: Material(
        color: widget.color,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: kBottomNavigationBarHeight + additionalBottomPadding,
          ),
          child: Padding(
            padding: EdgeInsets.only(bottom: additionalBottomPadding),
            child: MediaQuery.removePadding(
              context: context,
              removeBottom: true,
              child: ClipRect(
                child: CustomPaint(
                  painter: TabShapesPainter(
                      backgroundPosition, widget.items.length, scaffoldColor,
                      background: widget.color),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: _createChildren(),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _createChildren() {
    return widget.items
        .asMap()
        .map((index, value) {
          return MapEntry(index, _createItem(index, value));
        })
        .values
        .toList();
  }

  Widget _createItem(int index, IconData value) {
    return GestureDetector(
      onTap: () {
        if (widget.onPageChange != null) {
          widget.onPageChange(index);
        }
        setState(() {
          _controller.reset();
          animation =
              Tween<double>(begin: current.toDouble(), end: index.toDouble())
                  .animate(curve)
                    ..addListener(() {
                      setState(() {
                        backgroundPosition = animation.value;
                      });
                    });
          current = index;
        });

        _controller.forward();
      },
      child: AnimatedContainer(
        margin: EdgeInsets.only(top: index == current ? 10 : 20),
        duration: duration,
        child: Icon(
          value,
          color: index == current ? widget.color : scaffoldColor,
        ),
      ),
    );
  }
}

class TabShapesPainter extends CustomPainter {
  final double index;
  final int count;
  final Color color;
  final Color background;
  TabShapesPainter(this.index, this.count, this.color,
      {this.background = Colors.white});
  @override
  void paint(Canvas canvas, Size size) {
    double itemWidth = size.width / this.count;
    double currentItemCenterX = this.index * itemWidth + itemWidth / 2;
    final double currentItemCenterY = 20;
    final double sideCircleMove = 30.0 + currentItemCenterY;
    final paint = Paint();
    final otherPaint = Paint();
    otherPaint.color = this.background;
    paint.color = color;
    var center = Offset(currentItemCenterX, currentItemCenterY);
    canvas.drawRect(
      Rect.fromLTWH(currentItemCenterX - 50, 0, 100, currentItemCenterY),
      paint,
    );
    canvas.drawCircle(
      Offset(currentItemCenterX + sideCircleMove, currentItemCenterY),
      currentItemCenterY,
      otherPaint,
    );
    canvas.drawCircle(
      Offset(currentItemCenterX - sideCircleMove, currentItemCenterY),
      currentItemCenterY,
      otherPaint,
    );
    canvas.drawCircle(center, 30.0, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
