import 'package:flutter/material.dart';
import 'package:flutter_app/curvepage.dart';
//import 'package:sky_engine/ui/ui.dart';

class HomePage extends StatefulWidget {

  @override
  State createState() {
    return new _HomePageState();
  }
}

class _HomePageState extends State<HomePage> {

  final TextStyle _biggerFont = const TextStyle(fontSize: 18.0);
  // TODO Add build method

  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
      appBar: AppBar(
        title: new Text(
          'Startup Name Generator',
          style: new TextStyle(color: Colors.white),),
//        actions: <Widget>[
//          new IconButton(
//              icon: const Icon(Icons.list),
//              color: Colors.black,
//              onPressed: _pushSaved),
//        ],
        centerTitle: true,
        backgroundColor: Colors.blueGrey,
      ),
//      body: _buildSuggestions(),
      body: _buildMainBody(),
      drawer: _buildLeftDrawer(),
    );
  }

  Widget leftDrawerHeader = new DrawerHeader(
    padding: EdgeInsets.zero,
    decoration: BoxDecoration(
        image: new DecorationImage(
          image: new ExactAssetImage('images/drawerheader_w800.jpg'),
          fit: BoxFit.fill,)
    ),
    child: Container(
      padding: EdgeInsets.all(8.0),
//      padding: EdgeInsets.fromLTRB(double.infinity, double.infinity, 10.0, 10.0),
      alignment: Alignment.bottomLeft,
      child: new Directionality(
        textDirection: TextDirection.ltr,
        child: Text(
          'Choose Curve Type here.\nThen click SIMU.',
          style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w800,
              fontFamily: 'Roboto',
              fontSize: 20.0
          ),
        ),
      ),
    ),
  );


  Widget _buildLeftDrawer()
  {
    Widget drawer = new Drawer(
      child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            leftDrawerHeader,
//          userHeader,
            _buildLeftDrawerListItem('BezierCurve(2)','Create Lv2 Bezier Curve'),
            _buildLeftDrawerListItem('BezierCurve(3)','Create Lv3 Bezier Curve'),
            _buildLeftDrawerListItem('BezierCurve(4)','Create Lv4 Bezier Curve'),
            _buildLeftDrawerListItem('BezierCurve(5)','Create Lv5 Bezier Curve'),
            _buildLeftDrawerListItem('BezierCurve(6)','Create Lv6 Bezier Curve'),
            _buildLeftDrawerListItem('BezierCurve(7)','Create Lv7 Bezier Curve'),
            _buildLeftDrawerListItem('BezierCurve(8)','Create Lv8 Bezier Curve'),
            _buildLeftDrawerListItem('BezierCurve(9)','Create Lv9 Bezier Curve'),
            _buildLeftDrawerListItem('BezierCurve(10)','Create Lv10 Bezier Curve'),]
      ),
    );
    return drawer;
  }

  void _pushCurvePagewithAnimation(String title, String subtitle)
  {
    Navigator.of(context).push(
        new PageRouteBuilder(
            opaque: false,
            pageBuilder: (BuildContext context, _, __){
              return CurvePage(title: title,subtitle: subtitle,);
            },
            transitionsBuilder: (_, Animation<double> animation, __, Widget child) {
              return new FadeTransition(
                opacity: animation,
                child: new SlideTransition(
                  position: new Tween<Offset>(
                    begin: const Offset(1.0, 0.0),
                    end: const Offset(0.0, 0.0),
                  ).animate(animation),
                  child: child,
                ),
              );
            }
        )
    );
  }

  Widget _buildLeftDrawerListItem(String title,String subtitle)
  {
    return new Container(
      //width: 160.0,
      child: new ListTile(
        title: new Text(title),
        subtitle: new Text(subtitle),
        trailing: new Icon(Icons.blur_off),
        onTap: (){
          _pushCurvePagewithAnimation(title,subtitle);
//            _openNewPage();
        },
      ),
    );
  }

  Widget _buildMainBody()
  {
    Widget body = Container(
      child: Text('This is PageMainbody'),
    );
    return body;
  }

  /// followed functions (Widgets) are used temporarily for practice;
  /// back up here for future possible assistant.
  Widget userHeader = UserAccountsDrawerHeader(
    decoration: BoxDecoration(
        image: new DecorationImage(
          image: new ExactAssetImage('images/drawerheader_w800.jpg'),
          fit: BoxFit.fill,)
    ),
    accountName: new Text('chimaeraqm'),
    accountEmail: new Text('chimaeraqm@126.com'),
    currentAccountPicture: new CircleAvatar(
      backgroundImage: AssetImage(
          'images/icon.png'),
      radius: 35.0,
    ),
  );

  void _openNewPage() {
    Navigator.of(context).push(new PageRouteBuilder(
        opaque: false,
        pageBuilder: (BuildContext context, _, __) {
          return new Center(child: new Text('定制页面路由'));
        },
        transitionsBuilder: (_, Animation<double> animation, __, Widget child) {
          return new FadeTransition(
            opacity: animation,
            child: new RotationTransition(
              turns: new Tween<double>(begin: 0.5, end: 1.0).animate(animation),
              child: child,
            ),
          );
        }
    ));
  }
}