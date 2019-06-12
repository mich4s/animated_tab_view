import 'package:flutter/material.dart';
import 'package:animated_tab_view/animated_tab_view.dart' as Animated;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class Page extends StatelessWidget {
  final int page;

  Page({
    Key key,
    @required this.page,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: GestureDetector(
          child: Text(
            "${this.page}",
            style: TextStyle(
              color: Colors.white,
              fontSize: 100,
            ),
          ),
          onTap: () {
            print("Tapped page: ${this.page}");
          },
        ),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int page = 2;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red,
      body: Animated.PageView(
        current: this.page,
        pages: <Widget>[
          Page(page: 1),
          Page(page: 2),
          Page(page: 3),
          Page(page: 4),
          Page(page: 5),
        ],
      ),
      bottomNavigationBar: Animated.BottomTabBar(
        onPageChange: (int page) {
          setState(() {
            this.page = page;
          });
        },
        current: this.page,
        items: [
          Icons.home,
          Icons.mail,
          Icons.person,
          Icons.person,
          Icons.person,
        ],
      ),
    );
  }
}
