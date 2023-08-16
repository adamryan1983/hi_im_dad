import 'package:flutter/material.dart';
import 'package:hi_im_dad/constants/colors.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import '../subpages/about.dart';

import '../subpages/settings.dart';

class MyDrawer extends StatefulWidget {
  const MyDrawer({super.key});

  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  late String _resetDate;
  final Box _box = Hive.box('userBox');

  @override
  void initState() {
    super.initState();
    updateDate();
  }

  updateDate() {
    setState(() {
      _resetDate = DateFormat.yMMMMEEEEd().format((_box.get('lastReset')));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: AppColors.darkOrange,
        foregroundColor: AppColors.mainTextWhite,
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        color: AppColors.mainBGWhite,
        child: ListView(
          children: [
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text("Home"),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.account_box),
              title: const Text("About"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const About(),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text("Change User Settings"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const Settings(),
                  ),
                );
              },
            ),
            const Padding(padding: EdgeInsets.symmetric(vertical: 30)),
            ListTile(
              leading: const Icon(Icons.settings),
              title: Text("Score resets on: $_resetDate"),
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }
}
