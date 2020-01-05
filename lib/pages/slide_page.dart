import 'package:code_on/models/user.dart';
import 'package:code_on/pages/profile_tab.dart';
import 'package:code_on/pages/recommended_problems_page.dart';
import 'package:code_on/pages/solved_problems_page.dart';
import 'package:flutter/material.dart';

class SlidePage extends StatefulWidget {
  final User user;
  SlidePage({@required this.user});
  @override
  _SlidePageState createState() => _SlidePageState();
}

class _SlidePageState extends State<SlidePage> {
  final PageController ctrl = PageController(viewportFraction: 0.8);
  int currentPage = 0;
  @override
  void initState() {
    super.initState();
    ctrl.addListener(() {
      int next = ctrl.page.round();
      if (next != currentPage) {
        setState(() {
          currentPage = next;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedContainer(
        duration: Duration(milliseconds: 500),
        curve: Curves.easeIn,
        // color: _startColor
        decoration: BoxDecoration(
            gradient: LinearGradient(colors: [
          (currentPage == 1) ? Colors.blue : Colors.indigo,
          Colors.blue[50]
        ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
        child: PageView.builder(
          controller: ctrl,
          itemCount: 3,
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, int index) {
            if (index == 0) {
              return SolvedProblemsPage(
                  user: widget.user, active: (index == currentPage));
            } else if (index == 1) {
              return RecommendedListPage(
                user: widget.user,
                active: (index == currentPage),
              );
            } else if (index == 2) {
              return ProfilePage(
                  user: widget.user, active: (index == currentPage));
            }
          },
        ),
      ),
    );
  }
}
