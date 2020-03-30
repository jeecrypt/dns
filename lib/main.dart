
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:wakelock/wakelock.dart';
import 'pages/GetKeyPage.dart';
import 'route.gr.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    Wakelock.enable();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      builder: ExtendedNavigator<Router>(router: Router()),
      title: 'DNS',
      theme: ThemeData(
        platform: TargetPlatform.iOS,
        primaryColor: Colors.orange
      ),
      // home: GetKeyPage(title: 'Ввод данных'),
    );
  }
}

