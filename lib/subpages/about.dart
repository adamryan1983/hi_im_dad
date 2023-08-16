import 'package:flutter/material.dart';
import '../constants/colors.dart';

class About extends StatelessWidget {
  const About({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.armyGreen,
          foregroundColor: AppColors.mainTextWhite,
          title: const Text('Settings'),
        ),
        body: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height / 1.3,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                Container(
                  margin: const EdgeInsets.only(top: 10, right: 10),
                  child: const Text('Version 1.0.0'),
                ),
              ]),
              const Text('About',
                  style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold)),
              const Text('Hi, I\'m Dad!',
                  style: TextStyle(
                    color: AppColors.mainTextWhite,
                    fontSize: 32,
                    fontFamily: 'BungeeSpice',
                  )),
              const SizedBox(
                height: 200,
                child: Image(
                  image: AssetImage('assets/images/splash_image.png'),
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width / 1.2,
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'This app was created as a fun way to keep track of the quality of your jokes when you dad-joke someone.',
                      style: TextStyle(fontSize: 15),
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      'Simply ask them to rate your joke from 0-5 lawnmower score.',
                      style: TextStyle(fontSize: 15),
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      'You can set a timer for how long it takes for your score to reset, and you can also set your name so that the app can greet you by name.',
                      style: TextStyle(fontSize: 15),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width / 1.2,
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Made by:'),
                    Text('Adam Ryan',
                      style: TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
