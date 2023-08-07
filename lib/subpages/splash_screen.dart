import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../constants/colors.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Add a delay to simulate a long-loading task
    Future.delayed(const Duration(seconds: 3), () {
      // Navigate to the home screen after the splash screen is displayed
      Navigator.pushReplacementNamed(context, '/homescreen');
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Hive.openBox('userBox'),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.error != null) {
            print(snapshot.error);
            return const Scaffold(
              body: Center(
                child: Text('Something went wrong :/'),
              ),
            );
          } else {
            return const Scaffold(
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Hi, I\'m Dad!',
                      style: TextStyle(
                          fontSize: 45,
                          color: AppColors.darkOrange,
                          fontFamily: 'BungeeSpice'),
                    ),
                    SizedBox(
                      height: 300,
                      child: Image(
                        image: AssetImage('assets/images/splash_image.png'),
                      ),
                    ),
                    // CircularProgressIndicator(
                    //   valueColor: AlwaysStoppedAnimation<Color>(AppColors.darkOrange),
                    // ),
                  ],
                ),
              ),
            );
          }
        } else {
          return const Scaffold(
            body: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text('Loading...'),
                CircularProgressIndicator(),
              ],
            ),
          );
        }
      },
    );
  }
}
