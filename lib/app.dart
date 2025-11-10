import 'package:flutter/material.dart';
import 'calculator.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeMode _themeMode = ThemeMode.dark;

  void toggleTheme() {
    setState(() {
      _themeMode = _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: const Size(360, 690),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (_ , child) {
          return  MaterialApp(
            debugShowCheckedModeBanner: false,

            theme: ThemeData(
              primaryColor: Colors.deepPurple,
              primarySwatch: Colors.blue,
              appBarTheme: const AppBarTheme(backgroundColor: Colors.deepPurple),
              scaffoldBackgroundColor: Colors.grey[200],
              elevatedButtonTheme: ElevatedButtonThemeData(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              textTheme: const TextTheme(
                headlineLarge: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),

            darkTheme: ThemeData.dark().copyWith(
              primaryColor: Colors.purple,
              appBarTheme: const AppBarTheme(backgroundColor: Colors.red),
              scaffoldBackgroundColor: Colors.black,
            ),

            themeMode: _themeMode,

            title: 'Calculator',
            home: Calculator(toggleTheme: toggleTheme, isDarkMode: _themeMode == ThemeMode.dark),

            initialRoute: 'Calculator',
            routes: {
              'Calculator':(context) => Calculator(toggleTheme: toggleTheme, isDarkMode: _themeMode == ThemeMode.dark),
            },
          );
        }
    );
  }
}