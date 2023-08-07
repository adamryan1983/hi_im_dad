import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

final List<Duration> _durations = <Duration>[
  const Duration(7, 'Weekly'),
  const Duration(14, 'Bi-Weekly'),
  const Duration(30, 'Monthly'),
];

// Define a custom Form widget.
class Settings extends StatefulWidget {
  Settings({super.key});
  @override
  SettingsState createState() {
    return SettingsState();
  }
}

// Define a corresponding State class.
// This class holds data related to the form.
class SettingsState extends State<Settings> {
  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  //
  // Note: This is a `GlobalKey<FormState>`,
  // not a GlobalKey<MyCustomFormState>.
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final durationController = TextEditingController();
  Duration dropdownValue = _durations.first;

  @override
  void initState() {
    super.initState();
    // Start listening to changes.
    nameController.addListener(_printLatestValue);
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    nameController.dispose();
    super.dispose();
  }

  void setSettings(String name) {
    var namer = name;
    print('name set to $namer');
    Hive.box('userBox').put('name', namer);
    Hive.box('userBox').put('duration', dropdownValue.value);
    print(dropdownValue.value);

    // Hive.box('userBox').put('duration', );
    nameController.clear();
  }

  void _printLatestValue() {
    print('Second text field: ${nameController.text}');
  }

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    return Material(
        child: Scaffold(
            appBar: AppBar(
              title: const Text('Settings'),
            ),
            body: Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                                    const Padding(padding: EdgeInsets.symmetric(vertical: 30)),
                  // Add TextFormFields and ElevatedButton here.
                  Text("Set your name: "),
                  TextFormField(
                    controller: nameController,
                    // The validator receives the text that the user has entered.
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter some text';
                      }
                      return null;
                    },
                  ),
                  const Padding(padding: EdgeInsets.symmetric(vertical: 30)),
                  const Text('Select a duration for your score to reset:'),

                  //add dropdown here
                  DropdownButton<Duration>(
                    
   
                                     value: dropdownValue,
                    icon: const Icon(Icons.arrow_downward),
                    elevation: 16,
                    style: const TextStyle(color: Colors.deepPurple),
                    underline: Container(
                      height: 2,
                      color: Colors.deepPurpleAccent,
                    ),
                    onChanged: (Duration? value) {
                      // This is called when the user selects an item.
                      setState(() {
                        dropdownValue = value!;
                      });
                    },
                    items: _durations
                        .map<DropdownMenuItem<Duration>>((Duration value) {
                      return DropdownMenuItem<Duration>(
                        value: value,
                        child: Text(value.title,)
                      );
                    }).toList(),
                  ),
                  const Padding(padding: EdgeInsets.symmetric(vertical: 20)),
                  ValueListenableBuilder(
                    valueListenable: Hive.box('userBox').listenable(),
                    builder: (context, Box box, _) {
                      return Text(
                        box.get('name', defaultValue: 'N/A')!,
                        style: Theme.of(context).textTheme.headlineMedium,
                      );
                    },
                  ),
                  ValueListenableBuilder(
                    valueListenable: Hive.box('userBox').listenable(),
                    builder: (context, Box box, _) {
                      return Text(
                        box.get('duration', defaultValue: 'N/A').toString(),
                        style: Theme.of(context).textTheme.headlineMedium,
                      );
                    },
                  ),
                                    const Padding(padding: EdgeInsets.symmetric(vertical: 30)),
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
            )));
  }
}

class Duration {
  const Duration(this.value, this.title);
  final String title;
  final int value;
}
