import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../constants/colors.dart';
import 'package:flutter/cupertino.dart';

class DurationTime {
  const DurationTime(this.value, this.title);
  final String title;
  final int value;
}

final List<DurationTime> _durations = <DurationTime>[
  const DurationTime(7, 'Weekly'),
  const DurationTime(14, 'Bi-Weekly'),
  const DurationTime(30, 'Monthly'),
];

enum Durations { weekly, biweekly, monthly }

Map<Durations, int> _durationsIOS = <Durations, int>{
  Durations.weekly: 7,
  Durations.biweekly: 14,
  Durations.monthly: 30,
};

// Define a custom Form widget.
class Settings extends StatefulWidget {
  const Settings({super.key});
  @override
  SettingsState createState() {
    return SettingsState();
  }
}

// Define a corresponding State class.
// This class holds data related to the form.
class SettingsState extends State<Settings> {
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final durationController = TextEditingController();
  DurationTime dropdownValue = _durations.first;
  Durations _selectedSegment = Durations.weekly;

  @override
  void initState() {
    super.initState();
    nameController.value = TextEditingValue(
        text: Hive.box('userBox').get('name', defaultValue: 'N/A')!);
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    nameController.dispose();
    super.dispose();
  }

  void setSettings(String name) {
    var namer = name;
    Hive.box('userBox').put('name', namer);
    Hive.box('userBox').put('duration', dropdownValue.value);
    Hive.box('userBox').put('isSetup', true);
    Hive.box('userBox').put(
        'lastReset', DateTime.now().add(Duration(days: dropdownValue.value)));
    Navigator.popAndPushNamed(context, '/homescreen');
    // Navigator.pushReplacementNamed(context, '/homescreen');
    nameController.clear();
  }

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    return Material(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          backgroundColor: AppColors.armyGreen,
          foregroundColor: AppColors.mainTextWhite,
          title: const Text('Settings'),
        ),
        body: Form(
          key: _formKey,
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Column(
              children: [
                const Padding(padding: EdgeInsets.symmetric(vertical: 30)),
                // Add TextFormFields and ElevatedButton here.
                const Text("Set your name: "),
                SizedBox(
                  width: 280,
                  child: Platform.isIOS
                      ? CupertinoTextFormFieldRow(
                          prefix: const Text('Name:'),
                          decoration:
                              const BoxDecoration(color: AppColors.mainBGWhite),
                          placeholder: 'Enter your name',
                          controller: nameController,

                          // The validator receives the text that the user has entered.
                          validator: (String? value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter some text';
                            } else {
                              return null;
                            }
                          },

                          // onChanged: (value) {
                          //   if (value == null || value.isEmpty) {
                          //     return 'Please enter some text';
                          //   }
                          //   return null;
                          // },
                        )
                      : TextFormField(
                          decoration: const InputDecoration(
                            hintText: 'Enter your name',
                          ),
                          controller: nameController,
                          // The validator receives the text that the user has entered.
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter some text';
                            }
                            return null;
                          },
                        ),
                ),
                const Padding(padding: EdgeInsets.symmetric(vertical: 30)),
                const Text('Select a duration for your score to reset:'),
                Text(
                  'Current duration:${dropdownValue.title}',
                  style: const TextStyle(
                    fontSize: 22.0,
                  ),
                ),
                //add dropdown here
                Platform.isIOS
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CupertinoSlidingSegmentedControl<Durations>(
                            backgroundColor: CupertinoColors.systemGrey2,
                            thumbColor: Colors.blueAccent,
                            // This represents the currently selected segmented control.
                            groupValue: _selectedSegment,
                            // Callback that sets the selected segmented control.
                            onValueChanged: (Durations? value) {
                              if (value != null) {
                                setState(
                                  () {
                                    _selectedSegment = value;
                                    dropdownValue = _durations.firstWhere(
                                        (element) =>
                                            element.value ==
                                            _durationsIOS[value]);
                                  },
                                );
                              }
                            },
                            children: const <Durations, Widget>{
                              Durations.weekly: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 20),
                                child: Text(
                                  'Weekly',
                                  style:
                                      TextStyle(color: CupertinoColors.white),
                                ),
                              ),
                              Durations.biweekly: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 20),
                                child: Text(
                                  'BiWeekly',
                                  style:
                                      TextStyle(color: CupertinoColors.white),
                                ),
                              ),
                              Durations.monthly: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 20),
                                child: Text(
                                  'Monthly',
                                  style:
                                      TextStyle(color: CupertinoColors.white),
                                ),
                              ),
                            },
                          ),
                        ],
                      )
                    : DropdownButton<DurationTime>(
                        value: dropdownValue,
                        icon: const Icon(Icons.arrow_downward),
                        elevation: 16,
                        style: const TextStyle(color: Colors.deepPurple),
                        underline: Container(
                          height: 2,
                          color: Colors.deepPurpleAccent,
                        ),
                        onChanged: (DurationTime? value) {
                          // This is called when the user selects an item.
                          setState(
                            () {
                              dropdownValue = value!;
                            },
                          );
                        },
                        items: _durations.map<DropdownMenuItem<DurationTime>>(
                          (DurationTime value) {
                            return DropdownMenuItem<DurationTime>(
                              value: value,
                              child: Text(
                                value.title,
                              ),
                            );
                          },
                        ).toList(),
                      ),
                const Padding(padding: EdgeInsets.symmetric(vertical: 20)),
                ElevatedButton(
                  onPressed: () {
                    // Validate returns true if the form is valid, or false otherwise.
                    if (_formKey.currentState!.validate()) {
                      // If the form is valid, display a snackbar. In the real world,
                      // you'd often call a server or save the information in a database.
                      setSettings(nameController.text);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Processing Data')),
                      );
                    }
                  },
                  child: const Text('Submit'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
