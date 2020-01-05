import 'dart:async';

import 'package:code_on/models/complex_problems.dart';
import 'package:code_on/models/problems.dart';
import 'package:code_on/models/user.dart';
import 'package:code_on/pages/web_view.dart';
import 'package:flutter/material.dart';
import 'package:code_on/services/database.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class RecommendedListPage extends StatefulWidget {
  final User user;
  final bool active;
  RecommendedListPage({@required this.user, @required this.active});
  @override
  _RecommendedListPageState createState() => _RecommendedListPageState();
}

class _RecommendedListPageState extends State<RecommendedListPage> {
  User user;
  Stream<List<Problem>> recommendedProblems;
  StreamController<List<Problem>> _controller;
  bool isLoading = false;
  @override
  void initState() {
    super.initState();
    user = widget.user;
    _controller = StreamController<List<Problem>>.broadcast();
    recommendedProblems = _controller.stream;
    readRecommendations();
  }

  @override
  Widget build(BuildContext context) {
    bool active = widget.active;
    List<String> assets = [
      'assets/images/algorithms.png',
      'assets/images/Mathematics.png',
      'assets/images/DataStructures.png',
      'assets/images/basic-programming.png',
      'assets/images/DataBase.png',
      'assets/images/C++.png',
    ];
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return SafeArea(
      child: AnimatedContainer(
        duration: Duration(milliseconds: 500),
        margin: EdgeInsets.fromLTRB(active ? 0.0 : 20.0,
            active ? 10.0 : height / 4, active ? 0.0 : 20.0, 20.0),
        child: Column(children: <Widget>[
          Padding(
            padding: EdgeInsets.all(10.0),
            child: Text(
              'Recommendations',
              style: GoogleFonts.varelaRound(
                  fontWeight: FontWeight.bold,
                  textStyle: TextStyle(fontSize: 30.0, color: Colors.white)),
            ),
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.0),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black26,
                        blurRadius: active ? 30.0 : 10.0,
                        offset:
                            Offset(active ? 30.0 : 10.0, active ? 30.0 : 10.0))
                  ]),
              child: StreamBuilder(
                stream: recommendedProblems,
                builder: (context, AsyncSnapshot snapshot) {
                  if (!snapshot.hasData) {
                    return Center(
                        child: SpinKitChasingDots(color: Colors.blue));
                  } else {
                    return LiquidPullToRefresh(
                      showChildOpacityTransition: false,
                      onRefresh: () async {
                        readRecommendations(forceReload: true);
                      },
                      child: ListView.builder(
                        scrollDirection: Axis.vertical,
                        itemCount: 20,
                        itemBuilder: (BuildContext context, int index) {
                          // List<Tag> tags = snapshot.data[index].tags;
                          // int icon;
                          // //Algorithm->0
                          // //Maths->1
                          // //DataStructures->2
                          // //Basic->3
                          // //DP->4
                          // //C++->5
                          // if ((tags.indexOf(Tag.BINARY_SEARCH) != -1) ||
                          //     (tags.indexOf(Tag.BRUTE_FORCE) != -1) ||
                          //     (tags.indexOf(Tag.GREEDY) != -1) ||
                          //     (tags.indexOf(Tag.SORTINGS) != -1) ||
                          //     (tags.indexOf(Tag.TERNARY_SEARCH) != -1) ||
                          //     (tags.indexOf(Tag.DFS_AND_SIMILAR) != -1) ||
                          //     (tags.indexOf(Tag.TWO_POINTERS) != -1) ||
                          //     (tags.indexOf(Tag.CONSTRUCTIVE_ALGORITHMS) !=
                          //         -1) ||
                          //     (tags.indexOf(Tag.SHORTEST_PATHS) != -1)) {
                          //   icon = 0;
                          //   // icon = Image.asset('images/tag/Algorithm.svg');
                          // } else if ((tags.indexOf(Tag.BITMASKS) != -1) ||
                          //     (tags.indexOf(Tag.CHINESE_REMAINDER_THEOREM) !=
                          //         -1) ||
                          //     (tags.indexOf(Tag.COMBINATORICS) != -1) ||
                          //     (tags.indexOf(Tag.GEOMETRY) != -1) ||
                          //     (tags.indexOf(Tag.MATH) != -1) ||
                          //     (tags.indexOf(Tag.PROBABILITIES) != -1) ||
                          //     (tags.indexOf(Tag.FFT) != -1) ||
                          //     (tags.indexOf(Tag.NUMBER_THEORY) != -1)) {
                          //   icon = 1;
                          //   // icon = Image.asset('images/tag/Mathematics.svg');
                          // } else if ((tags.indexOf(Tag.DATA_STRUCTURES) !=
                          //         -1) ||
                          //     (tags.indexOf(Tag.GRAPH_MATCHINGS) != -1) ||
                          //     (tags.indexOf(Tag.GRAPHS) != -1) ||
                          //     (tags.indexOf(Tag.TREES) != -1)) {
                          //   icon = 2;
                          //   // icon = Image.asset('images/tag/DataStructures.svg');
                          // } else if ((tags.indexOf(Tag.EXPRESSION_PARSING) !=
                          //         -1) ||
                          //     (tags.indexOf(Tag.FLOWS) != -1) ||
                          //     (tags.indexOf(Tag.IMPLEMENTATION) != -1) ||
                          //     (tags.indexOf(Tag.INTERACTIVE) != -1) ||
                          //     (tags.indexOf(Tag.STRINGS) != -1)) {
                          //   icon = 3;
                          //   // icon =
                          //   // Image.asset('images/tag/basic-programming.png');
                          // } else if ((tags.indexOf(Tag.BITMASKS) != -1) ||
                          //     (tags.indexOf(Tag.DP) != -1) ||
                          //     (tags.indexOf(Tag.DSU) != -1)) {
                          //   icon = 4;
                          //   // icon = Image.asset('images/tag/DataBase.svg');
                          // } else {
                          //   icon = 5;
                          //   // icon = Image.asset('images/tag/C++.svg');
                          // }
                          return Container(
                            margin: EdgeInsets.symmetric(horizontal: 10.0),
                            decoration: BoxDecoration(
                                border: Border(
                                    bottom: BorderSide(
                                        color: Colors.blue[100], width: 1.5))),
                            child: ListTile(
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        ProblemWebView(
                                          title: snapshot.data[index].name,
                                          selectedUrl:
                                              "https://codeforces.com/problemset/problem/" +
                                                  snapshot
                                                      .data[index].contestID +
                                                  "/" +
                                                  snapshot.data[index].index,
                                        )));
                              },
                              title: Text(snapshot.data[index].name),
                              subtitle: Text(snapshot.data[index].contestID +
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
                        },
                      ),
                    );
                  }
                },
              ),
            ),
          ),
        ]),
      ),
    );
  }

  void readRecommendations({bool forceReload = false}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if ((!prefs.containsKey('recommendationData')) || (forceReload)) {
      final DatabaseService _dataBase = DatabaseService(uid: user.uid);
      await _dataBase.fetchRecommendation(user: user);
    }
    var result = json.decode(prefs.getString('recommendationData'));
    _controller.add(
        List<Problem>.from(result["problems"].map((x) => Problem.fromJson(x))));
  }
}
