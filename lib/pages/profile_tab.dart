import 'package:code_on/models/user.dart';
import 'package:code_on/pages/auth_page.dart';
import 'package:code_on/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatefulWidget {
  final User user;
  final bool active;
  ProfilePage({@required this.active, @required this.user});
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  int type = 0;
  SharedPreferences prefs;
  @override
  void initState() {
    super.initState();
    SharedPreferences.getInstance().then((pref) {
      prefs = pref;
      setState(() {
        type = prefs.getInt('type');
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    bool active = widget.active;
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    AuthService _auth = AuthService();

    return SafeArea(
      child: AnimatedContainer(
        duration: Duration(milliseconds: 500),
        margin: EdgeInsets.fromLTRB(active ? 0.0 : 30.0,
            active ? 10.0 : height / 4, active ? 0.0 : 10.0, 20.0),
        child:
            Column(mainAxisAlignment: MainAxisAlignment.spaceAround, children: <
                Widget>[
          Padding(
            padding: EdgeInsets.all(10.0),
            child: Text(
              'Profile',
              style: GoogleFonts.varelaRound(
                  fontWeight: FontWeight.bold,
                  textStyle: TextStyle(fontSize: 30.0, color: Colors.white)),
            ),
          ),
          Center(
            child: Container(
              margin: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 10.0),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black26,
                        blurRadius: active ? 30.0 : 10.0,
                        offset:
                            Offset(active ? 30.0 : 10.0, active ? 30.0 : 10.0))
                  ]),
              child: Column(
                children: <Widget>[
                  ExpansionTile(
                    title: Row(children: <Widget>[
                      Radio(
                        value: 0,
                        groupValue: type,
                        onChanged: (x) async {
                          prefs = await SharedPreferences.getInstance();
                          prefs.setInt('type', x);
                          setState(() {
                            type = x;
                          });
                        },
                      ),
                      Text('Hybrid')
                    ]),
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.fromLTRB(50.0, 10.0, 10.0, 10.0),
                        child: Text(
                          'A mixture of User and Item based Collaborative Filtering.',
                          style: TextStyle(color: Colors.blueGrey),
                        ),
                      )
                    ],
                  ),
                  ExpansionTile(
                    title: Row(children: <Widget>[
                      Radio(
                        value: 1,
                        groupValue: type,
                        onChanged: (x) async {
                          prefs = await SharedPreferences.getInstance();
                          prefs.setInt('type', x);
                          setState(() {
                            type = x;
                          });
                        },
                      ),
                      Text('User-Based')
                    ]),
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.fromLTRB(50.0, 10.0, 10.0, 10.0),
                        child: Text(
                          'Users similar to the target users are found and the selections corresponding to these \'similar\' users are recommended to our target user. The similarity between two users is computed from the amount of items they have in common in the dataset by cosine similarity. This algorithm is very efficient when the number of users is way smaller than the number of items.',
                          style: TextStyle(color: Colors.blueGrey),
                        ),
                      )
                    ],
                  ),
                  ExpansionTile(
                    title: Row(children: <Widget>[
                      Radio(
                        value: 2,
                        groupValue: type,
                        onChanged: (x) async {
                          prefs = await SharedPreferences.getInstance();
                          prefs.setInt('type', x);
                          setState(() {
                            type = x;
                          });
                        },
                      ),
                      Text('Item-Based')
                    ]),
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.fromLTRB(50.0, 10.0, 10.0, 10.0),
                        child: Text(
                          'The “item-item” algorithm uses the same approach but reverses the view between users and items. It recommends items that are similar to the ones previously liked by the target user. As before the similarity between two items is computed using the amount of users they have in common in the dataset by cosine similarity.',
                          style: TextStyle(color: Colors.blueGrey),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
          AnimatedContainer(
            width: width,
            height: 48.0,
            duration: Duration(milliseconds: 500),
            decoration: BoxDecoration(
                color: active ? Colors.indigo : Colors.blue[300],
                borderRadius: BorderRadius.circular(10.0),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black26,
                      blurRadius: active ? 30.0 : 10.0,
                      offset:
                          Offset(active ? 30.0 : 10.0, active ? 30.0 : 10.0))
                ]),
            child: SizedBox.expand(
              child: FlatButton(
                splashColor: Colors.white,
                color: Colors.transparent,
                child: Center(
                  child: Text(
                    'Logout',
                    style: TextStyle(color: Colors.white, fontSize: 16.0),
                  ),
                ),
                onPressed: () async {
                  await _auth.signOut();
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  prefs.remove('uid');
                  prefs.remove('recommendationData');
                  prefs.remove('solvedProblems');
                  Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => Authenticate()));
                },
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
