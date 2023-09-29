import 'dart:convert';

import 'package:duration_picker/duration_picker.dart';
import 'package:flutter/material.dart';
import 'reminder_cards.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:remindee/remindee.dart';

void main() {
  runApp(
    const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ReminderListPage(),
    ),
  );
}

class ReminderListPage extends StatefulWidget {
  const ReminderListPage({Key? key}) : super(key: key);

  @override
  _ReminderListPageState createState() => _ReminderListPageState();
}

class _ReminderListPageState extends State<ReminderListPage> {
  List<ReminderCard> _reminders = [];
  late SharedPreferences _prefs;
  final List<bool> _selectedReminders = [];
  @override
  void initState() {
    super.initState();
    _loadReminders();
  }

  void _loadReminders() async {
    _prefs = await SharedPreferences.getInstance();
    final remindersJson = _prefs.getStringList('reminders') ?? [];
    List<ReminderCard> temp = [];
    setState(() {
      // _reminders.clear();
      temp.addAll(
        remindersJson.map((json) => ReminderCard.fromJson(jsonDecode(json))),
      );
      _reminders = temp;
    });
  }

  void _saveReminders() async {
    final remindersJson =
        _reminders.map((reminder) => jsonEncode(reminder.toJson())).toList();
    await _prefs.setStringList('reminders', remindersJson);
  }

  void _addReminder(ReminderCard reminder) {
    setState(() {
      _reminders.add(reminder);
      _saveReminders();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
   
      body: Column(
        children: [
          const SizedBox(
            height: 40,
          ),
          Padding(
            padding: EdgeInsets.only(left: 20),
            child: Row(
              children: [
                IconButton(
                  icon: Icon(
                    Icons.arrow_back,
                    color: Theme.of(context).colorScheme.primary,
                    size: 30,
                  ),
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Remindee()));
                  },
                ),
                const SizedBox(
                  width: 30,
                ),
                Text(
                  'Reminders',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontSize: 30,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _reminders.length,
              itemBuilder: (BuildContext context, int index) {
                return ReminderCard(
                  title: _reminders[index].title,
                  nextReminderDuration: _reminders[index].nextReminderDuration,
                  breakDuration: _reminders[index].breakDuration,
                  reminderMessage: _reminders[index].reminderMessage,
                  repeatDays: _reminders[index].repeatDays,
                  isEnabled: _reminders[index].isEnabled,
                );
                
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => AlertDialogManager(_addReminder)));
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class AlertDialogManager extends StatefulWidget {
  final Function(ReminderCard) onReminderAdded;
  const AlertDialogManager(this.onReminderAdded, {Key? key}) : super(key: key);

  @override
  State<AlertDialogManager> createState() => _AlertDialogManagerState();
}

class _AlertDialogManagerState extends State<AlertDialogManager> {
  final _formKey = GlobalKey<FormState>();
  String _title = '';
  String _reminderMessage = '';
  Duration _reminderDuration = const Duration(minutes: 0);
  Duration _breakDuration = const Duration(seconds: 0);
  final Set<int> _repeatDays = {};
  final Set<int> _selectedRepeatDays = {};
  bool _is202020RuleSelected = false;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add Reminder'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Select a rule:',
                style: TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                ),
                value: _is202020RuleSelected ? '20-20-20 Rule' : 'Custom Rule',
                items: <String>['Custom Rule', '20-20-20 Rule']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (value) {
                  value == '20-20-20 Rule'
                      ? setState(() {
                          _is202020RuleSelected = true;
                          _reminderDuration = const Duration(minutes: 20);
                          _breakDuration = const Duration(seconds: 20);
                          _title = '20-20-20 Rule';
                          _reminderMessage =
                              "Look away from your screen and stare at an object 20 feet away for 20 seconds";
                        })
                      : setState(() {
                          _is202020RuleSelected = false;
                        });
                },
              ),
              const SizedBox(height: 16),
              _is202020RuleSelected
                  ? const Text(
                      'The 20-20-20 rule says that after every 20 minutes, '
                      'look away from your screen and stare at an object 20 feet away '
                      'for 20 seconds.',
                      style: TextStyle(fontSize: 18),
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextFormField(
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Title',
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a title';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            _title = value!;
                          },
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Message',
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a message';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            _reminderMessage = value!;
                          },
                        ),
                        const Text(
                          'Break Duration:',
                          style: TextStyle(fontSize: 18),
                        ),
                        const SizedBox(height: 8),
                      
                        DurationPicker(
                          baseUnit: BaseUnit.second,
                          duration: _breakDuration,
                          onChange: (val) {
                            setState(() => _breakDuration = val);
                          },
                          snapToMins: 1.0,
                        ),

                        const SizedBox(height: 16),
                        const Text(
                          'Reminder Time:',
                          style: TextStyle(fontSize: 18),
                        ),
                        const SizedBox(height: 8),
                      
                        DurationPicker(
                          duration: _reminderDuration,
                          onChange: (val) {
                            setState(() => _reminderDuration = val);
                          },
                          snapToMins: 5.0,
                        ),
                      ],
                    ),
              const SizedBox(height: 20),

              const Text(
                'Repeat on:',
                style: TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 8),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    Column(
                      children: [
                        _buildRepeatDayCheckbox('Mon', 1),
                        const Text("Mon"),
                      ],
                    ),
                    Column(
                      children: [
                        _buildRepeatDayCheckbox('Tue', 2),
                        const Text("Tue"),
                      ],
                    ),
                    Column(
                      children: [
                        _buildRepeatDayCheckbox('Wed', 3),
                        const Text("Tue"),
                      ],
                    ),
                    Column(
                      children: [
                        _buildRepeatDayCheckbox('Thu', 4),
                        const Text("Wed"),
                      ],
                    ),
                    Column(
                      children: [
                        _buildRepeatDayCheckbox('Fri', 5),
                        const Text("Fri"),
                      ],
                    ),
                    Column(
                      children: [
                        _buildRepeatDayCheckbox('Sat', 6),
                        const Text("Sat"),
                      ],
                    ),
                    Column(
                      children: [
                        _buildRepeatDayCheckbox('Sun', 7),
                        const Text("Sun"),
                      ],
                    ),
                  ],
                ),
              ),
        
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('CANCEL'),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                        final ReminderCard reminder = ReminderCard(
                          title: _title,
                          nextReminderDuration: _reminderDuration,
                          breakDuration: _breakDuration,
                          reminderMessage: _reminderMessage,
                          repeatDays: _repeatDays,
                          isEnabled: true,
                        );

                        // Add the new reminder to the list of reminders.

                        setState(() {
                          // Navigator.push(
                          //     context,
                          //     MaterialPageRoute(
                          //         builder: (context) => ReminderListPage()));

                          widget.onReminderAdded(reminder);
                        });
                        //          await Navigator.push(
                        //   context,
                        //   MaterialPageRoute(builder: (context) => Remindee(refIndex: 1,)),
                        // );
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (BuildContext context) => Remindee(
                                      refIndex: 1,
                                    )));
                        // Close the dialog.
                      }
                    },
                    child: const Text('CREATE'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRepeatDayCheckbox(String label, int day) {
    return Checkbox(
      value: _selectedRepeatDays.contains(day),
      onChanged: (value) {
        setState(() {
          if (value == true) {
            _selectedRepeatDays.add(day);
          } else {
            _selectedRepeatDays.remove(day);
          }
        });
      },
    );
  }
}

