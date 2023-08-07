import 'package:flutter/material.dart';
import 'package:hi_im_dad/subpages/settings.dart';
import 'subpages/splash_screen.dart';
import 'widgets/drawer.dart';
import 'constants/colors.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:hive_flutter/hive_flutter.dart';

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
        '/settings': (_) => Settings(),
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
  late final _ratingController;
  late double _rating;

  bool _isVertical = false;

  IconData? _selectedIcon;
  final Box _box = Hive.box('userBox');

  @override
  void initState() {
    super.initState();
    final Box box = Hive.box('userBox');
    final String _name = box.get('name', defaultValue: 'Dadam')!;
    // _box.put('name', _name);
    // _box = Hive.box<double>('myBox');
    _rating = _box.get('rating', defaultValue: 0.0)!;
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
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        //middle icon
        iconTheme: const IconThemeData(color: AppColors.lightOrange),

        //start of bar
        leading: Builder(builder: (context) => // Ensure Scaffold is in context
            IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () => Scaffold.of(context).openDrawer()
            ),),

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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Hi, I\'m Dad!',
              style: TextStyle(fontSize: 32, fontFamily: 'BungeeSpice'),
            ),
            const Text(
              'Welcome:',
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
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  onPressed: () {
                    updateUserrating(_rating);
                  },
                  child: const Text('Add Rating'),
                ),
                ElevatedButton(
                  onPressed: () {
                    resetUserRating();
                  },
                  child: const Text('Reset Rating'),
                ),
              ],
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
              child: TextFormField(
                decoration: const InputDecoration(
                  border: UnderlineInputBorder(),
                  labelText: 'Enter your username',
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                setName('Woop');
              },
              child: const Text('Reset Rating'),
            ),
          ],
        ),
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
