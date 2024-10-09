import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:office_booking/providers/user_provider.dart';
import 'package:office_booking/screens/login_page.dart';
import 'dart:ui';

import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => UserProvider(),),

      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          appBarTheme: AppBarTheme(
            backgroundColor: Color(0xff000000),
          )
        ),
        darkTheme: ThemeData.dark(),
        home: LoginPage(),
      ),
    );
  }
}
