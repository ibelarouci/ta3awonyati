import 'package:flutter/services.dart';
import 'package:flutter/material.dart';

import 'dashboard_screen1.dart';
import 'harvest.dart';
import 'login_screen.dart';
import 'transition_route_observer.dart';

//final AuthLink authLink = AuthLink(getToken: () => Constants.p_a_t);

void main() async {
//  GqlClient.getHarvestByOwner();
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      systemNavigationBarColor:
          SystemUiOverlayStyle.dark.systemNavigationBarColor,
    ),
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Login Demo',
      theme: ThemeData(
        // brightness: Brightness.dark,
        primarySwatch: Colors.deepPurple,
        accentColor: Colors.orange,
        textSelectionTheme: TextSelectionThemeData(cursorColor: Colors.orange),
        // fontFamily: 'SourceSansPro',
        textTheme: TextTheme(
          headline3: TextStyle(
            fontSize: 45.0,
            // fontWeight: FontWeight.w400,
            color: Colors.orange,
          ),
          button: TextStyle(
              // OpenSans is similar to NotoSans but the uppercases look a bit better IMO

              ),
          caption: TextStyle(
            fontSize: 12.0,
            fontWeight: FontWeight.normal,
            color: Colors.deepPurple[300],
          ),
          headline1: TextStyle(),
          headline2: TextStyle(),
          headline4: TextStyle(),
          headline5: TextStyle(),
          headline6: TextStyle(),
          subtitle1: TextStyle(),
          bodyText1: TextStyle(),
          bodyText2: TextStyle(),
          subtitle2: TextStyle(),
          overline: TextStyle(),
        ),
      ),
      home: LoginScreen(),
      navigatorObservers: [TransitionRouteObserver()],
      initialRoute: LoginScreen.routeName,
      routes: {
        LoginScreen.routeName: (context) => LoginScreen(),
        DashboardScreen.routeName: (context) => DashboardScreen(),
        Harvest.routeName: (context) => Harvest(),
      },
    );
  }
}
