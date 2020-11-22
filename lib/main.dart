import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:wiprapp/services/notes_service.dart';
import 'package:wiprapp/views/login/login.dart';

import 'services/event_service.dart';
import 'services/user_services.dart';

void setupLocator() {
  GetIt.I.registerLazySingleton(() => NotesService());
  GetIt.I.registerLazySingleton(() => EventsService());
  GetIt.I.registerLazySingleton(() => UsersService());
}

void main() {
  setupLocator();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  static const primaryColor =  Color(0xFF9b2434);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'WiPR',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primaryColor: primaryColor,
        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Login()
    );
  }
}

// class MyHomePage extends StatefulWidget {
//   MyHomePage({Key key, this.title}) : super(key: key);

//   final String title;

//   @override
//   _MyHomePageState createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {
//   @override
//   Widget build(BuildContext context) {
//     return new SplashScreen(
//       seconds: 14,
//       navigateAfterSeconds: new Login(),
//       title: new Text('Welcome In SplashScreen',
//       style: new TextStyle(
//         fontWeight: FontWeight.bold,
//         fontSize: 20.0
//       ),),
//       image: new Image.network('https://i.imgur.com/TyCSG9A.png'),
//       backgroundColor: Colors.white,
//       styleTextUnderTheLoader: new TextStyle(),
//       photoSize: 100.0,
//       onClick: ()=>print("Flutter Egypt"),
//       loaderColor: Colors.red
//     );
//   }
// }
