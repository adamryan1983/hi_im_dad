import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hi_im_dad/subpages/settings.dart';
import 'subpages/setup_page.dart';
import 'subpages/splash_screen.dart';
import 'widgets/drawer.dart';
import 'constants/colors.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter/cupertino.dart';

void main() async {
  await Hive.initFlutter();
  await Hive.openBox('userBox');

  // box.put('name', 'Dadamo');
  // box.put('duration', 7);
  // box.put('rating', 0.0);
  runApp(const MyApp());
}

class AppTheme {
  //
  AppTheme._();

  static final ThemeData lightTheme = ThemeData(
    fontFamily: 'Manrope',
    scaffoldBackgroundColor: Colors.white,
    appBarTheme: const AppBarTheme(
      color: AppColors.lightOrange,
      iconTheme: IconThemeData(
        color: Colors.white,
      ),
    ),
    colorScheme: const ColorScheme.light(
      primary: AppColors.mainTextWhite,
      onPrimary: AppColors.mainTextBlack,
      secondary: AppColors.armyGreen,
    ),
    cardTheme: const CardTheme(
      color: Colors.blue,
    ),
    iconTheme: const IconThemeData(
      color: AppColors.darkGreen,
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Hi, I\'m Dad!',
      theme: ThemeData(
        fontFamily: 'LilitaOne',
        colorScheme: const ColorScheme.light(
          background: AppColors.lightBG,
          primary: AppColors.armyGreen,
        ),
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (_) => const SplashScreen(),
        '/homescreen': (_) => const MyHomePage(title: 'Hi I\'m Dad!'),
        '/settings': (_) => const Settings(),
        '/setup': (_) => const SetupPage(),
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late double _rating;

  // IconData? _selectedIcon;
  final Box _box = Hive.box('userBox');

  @override
  void initState() {
    super.initState();
    //get current date

    if (_box
        .get('lastReset', defaultValue: DateTime.now())
        .isBefore(DateTime.now())) {
      resetUserRating();
      final dayAmt = _box.get('duration', defaultValue: 7);
      _box.put('lastReset', DateTime.now().add(Duration(days: dayAmt)));
    }
    _rating = 2.5;
  }

  //sets the rating from the slider
  void _setRating(rating) {
    setState(() {
      _rating = rating;
    });
  }

  //applies rating to users db rating
  void updateUserrating(double newRating) {
    setState(() {
      _box.put('rating', _box.get('rating', defaultValue: 0)! + newRating);
    });
  }

  //resets the users rating to 0
  void resetUserRating() {
    setState(() {
      _box.put('rating', 0.0);
    });
  }

  void setName(String name) {
    setState(() {
      _box.put('name', name);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //middle icon
        iconTheme: const IconThemeData(color: AppColors.lightOrange),

        //start of bar
        leading: Builder(
          builder: (context) => // Ensure Scaffold is in context
              IconButton(
                  icon: const Icon(Icons.menu),
                  onPressed: () => Scaffold.of(context).openDrawer()),
        ),

        //end of bar
        actions: [
          const Text(
            '🔥',
            style: TextStyle(
              color: AppColors.mainTextWhite,
              fontSize: 24,
            ),
          ),
          const Padding(padding: EdgeInsets.symmetric(horizontal: 3)),
          Text(
            _box.get('rating', defaultValue: 0).toString(),
            // write object to hive
            style: const TextStyle(
              color: AppColors.mainTextWhite,
              fontSize: 24,
            ),
          ),
          const Padding(padding: EdgeInsets.symmetric(horizontal: 12))
        ],

        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.primary,
        centerTitle: true,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(
          widget.title,
          style: const TextStyle(
            color: AppColors.mainTextWhite,
            fontSize: 32,
            fontFamily: 'BungeeSpice',
          ),
        ),
      ),
      drawer: const MyDrawer(),
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height / 1.2,
        child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              const Text(
                'Welcome:',
                style: TextStyle(
                  fontSize: 24,
                  fontFamily: 'BungeeSpice',
                ),
              ),
              ValueListenableBuilder(
                valueListenable: _box.listenable(),
                builder: (context, Box box, _) {
                  return Text(
                    box.get('name', defaultValue: 'N/A')!,
                    style: Theme.of(context).textTheme.headlineMedium,
                  );
                },
              ),
              Image.asset(
                'assets/images/logo.png',
                width: 300,
                height: 300,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Text(
                  //   _box.get('name', defaultValue: 'N/A')!,
                  //   style: Theme.of(context).textTheme.headlineMedium,
                  // ),
                  // RatingBar.builder(
                  //     initialRating: 3,
                  //     itemCount: 5,
                  //     itemBuilder: (context, index) {
                  //       switch (index) {
                  //         case 0:
                  //           return const Icon(
                  //             Icons.sentiment_very_dissatisfied,
                  //             color: Colors.red,
                  //           );
                  //         case 1:
                  //           return const Icon(
                  //             Icons.sentiment_dissatisfied,
                  //             color: Colors.redAccent,
                  //           );
                  //         case 2:
                  //           return const Icon(
                  //             Icons.sentiment_neutral,
                  //             color: Colors.amber,
                  //           );
                  //         case 3:
                  //           return const Icon(
                  //             Icons.sentiment_satisfied,
                  //             color: Colors.lightGreen,
                  //           );
                  //         case 4:
                  //           return const Icon(
                  //             Icons.sentiment_very_satisfied,
                  //             color: Colors.green,
                  //           );
                  //         default:
                  //           return Container();
                  //       }
                  //     },
                  //     onRatingUpdate: (rating) {
                  //       _setRating(rating);
                  //     }),
                  RatingBar(
                    initialRating: 3,
                    direction: Axis.horizontal,
                    allowHalfRating: true,
                    itemCount: 5,
                    ratingWidget: RatingWidget(
                      full: _image('assets/images/lawner.png'),
                      half: _image('assets/images/lawner_half.png'),
                      empty: _image('assets/images/lawner_border.png'),
                    ),
                    itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                    onRatingUpdate: (rating) {
                      _setRating(rating);
                    },
                  ),
                  Text(_rating.toString()),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Platform.isIOS
                          ? SizedBox(
                              width: 120,
                              height: 40,
                              child: CupertinoButton(
                                color: AppColors.armyGreen,
                                padding: const EdgeInsets.all(0),
                                onPressed: () {
                                  updateUserrating(_rating);
                                },
                                child: const Text('Add Rating'),
                              ),
                            )
                          : ElevatedButton(
                              onPressed: () {
                                updateUserrating(_rating);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    AppColors.armyGreen, // background
                                foregroundColor:
                                    AppColors.lightBG, // foreground
                              ),
                              child: const Text(
                                'Add Rating',
                                style: TextStyle(fontSize: 15),
                              ),
                            ),
                      Platform.isIOS
                          ? SizedBox(
                              width: 120,
                              height: 40,
                              child: CupertinoButton(
                                padding: const EdgeInsets.all(0),
                                color: Colors.red[800],
                                onPressed: () {
                                  resetUserRating();
                                },
                                
                                child: const Text('Reset Rating'),
                                
                              ),
                            )
                          : ElevatedButton(
                              onPressed: () {
                                resetUserRating();
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red, // background
                                foregroundColor: AppColors.lightBG,
                              ), //
                              child: const Text('Reset Rating'),
                            ),
                    ],
                  ),
                ],
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 30),
                child: Text(
                    'This is a fun app to ask your family for a rating of your best dad jokes. \n'
                    'Your family can rate them on a scale of 1-5. \n'
                    'Choose between different durations to track the ultimate dad score. \n'
                    'It will reset the score each period. You can also reset the rating to 0 manually. \n\n'
                    'Have fun!'),
              ),
            ]),
      ),
    );
  }

  //icon widget
  Widget _image(String asset) {
    return Image.asset(
      asset,
      height: 30.0,
      width: 30.0,
      color: Colors.amber,
    );
  }
}
