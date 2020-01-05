import 'dart:async';
import 'dart:convert';
import 'package:code_on/models/problems.dart';
import 'package:code_on/models/user.dart';
import 'package:code_on/pages/web_view.dart';
import 'package:code_on/services/api.dart';
import 'package:code_on/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SolvedProblemsPage extends StatefulWidget {
  final User user;
  final bool active;
  SolvedProblemsPage({@required this.user, @required this.active});

  @override
  _SolvedProblemsPageState createState() => _SolvedProblemsPageState();
}

class _SolvedProblemsPageState extends State<SolvedProblemsPage> {
  User user;
  Stream<List<Problem>> solvedProblems;
  StreamController<List<Problem>> _controller;

  @override
  void initState() {
    super.initState();
    user = widget.user;
    _controller = StreamController<List<Problem>>.broadcast();
    solvedProblems = _controller.stream;
    readSolves();
  }

  @override
  Widget build(BuildContext context) {
    bool active = widget.active;
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return SafeArea(
      child: AnimatedContainer(
        duration: Duration(milliseconds: 500),
        margin: EdgeInsets.fromLTRB(active ? 0.0 : 10.0,
            active ? 10.0 : height / 4, active ? 0.0 : 30.0, 20.0),
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(10.0),
              child: Text(
                'Solved Problems',
                style: GoogleFonts.varelaRound(
                    textStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 30.0,
                        color: Colors.white)),
              ),
            ),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20.0),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black26,
                          blurRadius: active ? 30.0 : 10.0,
                          offset: Offset(
                              active ? 30.0 : 10.0, active ? 30.0 : 10.0))
                    ]),
                child: StreamBuilder(
                    stream: solvedProblems,
                    builder: (context, AsyncSnapshot snapshot) {
                      if (!snapshot.hasData) {
                        return Center(
                            child: SpinKitChasingDots(color: Colors.indigo));
                      } else {
                        return LiquidPullToRefresh(
                          showChildOpacityTransition: false,
                          onRefresh: () async {
                            await readSolves(forceReload: true);
                          },
                          child: ListView.builder(
                              scrollDirection: Axis.vertical,
                              itemCount: 20,
                              itemBuilder: (BuildContext context, int index) {
                                return Container(
                                  margin:
                                      EdgeInsets.symmetric(horizontal: 10.0),
                                  decoration: BoxDecoration(
                                      border: Border(
                                          bottom: BorderSide(
                                              color: Colors.blue[100],
                                              width: 1.5))),
                                  child: ListTile(
                                    onTap: () {
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (BuildContext context) =>
                                                  ProblemWebView(
                                                    title: snapshot
                                                        .data[index].name,
                                                    selectedUrl:
                                                        "https://codeforces.com/problemset/problem/" +
                                                            snapshot.data[index]
                                                                .contestID +
                                                            "/" +
                                                            snapshot.data[index]
                                                                .index,
                                                  )));
                                    },
                                    title: Text(snapshot.data[index].name),
                                    subtitle: Text(
                                        snapshot.data[index].contestID +
                                            snapshot.data[index].index),
                                    leading: Container(
                                      padding: EdgeInsets.only(right: 12.0),
                                      decoration: new BoxDecoration(
                                          // image: DecorationImage(
                                          //     image: AssetImage(assets[icon])),
                                          border: new Border(
                                              right: new BorderSide(
                                                  width: 1.0,
                                                  color: Colors.blueAccent))),
                                      child: Icon(
                                        Icons.blur_on,
                                        color: Colors.blue,
                                      ),
                                    ),
                                  ),
                                );
                              }),
                        );
                      }
                    }),
                // child: Image.asset('images/icon.png'),
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<void> readSolves({bool forceReload = false}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<Problem> result;
    if ((!prefs.containsKey('solvedProblems')) || (forceReload)) {
      ApiService _api = ApiService();
      result = await _api.fetchUserData(user);
      prefs.setString(
          'solvedProblems',
          json.encode(
              {"problems": List<dynamic>.from(result.map((x) => x.toJson()))}));
    } else {
      result = List<Problem>.from(json
          .decode(prefs.getString('solvedProblems'))["problems"]
          .map((x) => Problem.fromJson(x)));
    }
    _controller.add(result);
  }
}
