import 'package:flutter/material.dart';
import 'package:hi_im_dad/constants/colors.dart';

import '../subpages/settings.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

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
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text("Change User Settings"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Settings()
                  
                  ),
                  
                  
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
