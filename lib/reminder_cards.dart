import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:remindee/remindee.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:duration_picker/duration_picker.dart';

class ReminderCard extends StatefulWidget {
  final String title;
  final Duration breakDuration;
  final Duration nextReminderDuration;
  final String reminderMessage;
  final Set<int> repeatDays;
  bool isEnabled;

  ReminderCard({
    Key? key,
    required this.title,
    required this.breakDuration,
    required this.nextReminderDuration,
    required this.reminderMessage,
    required this.repeatDays,
    required this.isEnabled,
  }) : super(key: key);

  factory ReminderCard.fromJson(Map<String, dynamic> json) {
    return ReminderCard(
      title: json['title'],
      nextReminderDuration: Duration(minutes: json['reminderDuration']),
      breakDuration: Duration(seconds: json['breakDuration']),
      reminderMessage: json['message'],
      repeatDays: (json['repeatDays'] as List).cast<int>().toSet(),
      isEnabled: json['isEnabled'],
      // is202020RuleSelected: json['is202020RuleSelected'],
      // reminderTime: TimeOfDay.fromDateTime(DateTime.parse(json['reminderTime'])),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'reminderDuration': nextReminderDuration.inMinutes,
      'breakDuration': breakDuration.inSeconds,
      'message': reminderMessage,
      'repeatDays': repeatDays.toList(),
      'isEnabled': isEnabled,
      // 'is202020RuleSelected': is202020RuleSelected,
      // 'reminderTime': DateTime(2000, 1, 1, reminderTime.hour, reminderTime.minute).toIso8601String(),
    };
  }

  @override
  _ReminderCardState createState() => _ReminderCardState();
}

class _ReminderCardState extends State<ReminderCard> {
  //bool _isEnabled = false;
  List<ReminderCard> reminders = [];
  @override
  void initState() {
    () async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final remindersJson = prefs.getStringList('reminders') ?? [];
      reminders.addAll(
        remindersJson.map((json) => ReminderCard.fromJson(jsonDecode(json))),
      );
      setState(() {});
    }();

    super.initState();
  }

  Future<void> _updateReminderEnabled(String title, bool isEnabled) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //final remindersJson = prefs.getStringList('reminders') ?? [];
    final index = reminders.indexWhere((reminder) => reminder.title == title);
    print(reminders);
    print(index);
    if (index >= 0) {
      // Update the isEnabled value for the reminder
      reminders[index].isEnabled = isEnabled;
      // Convert the list of reminders back to a JSON-encoded string
      final remindersJson =
          reminders.map((reminder) => jsonEncode(reminder.toJson())).toList();
      //  reminders = remindersJson as List<ReminderCard>;
      // Save the updated list of reminders back to SharedPreferences
      await prefs.setStringList('reminders', remindersJson);
    }
    print("update is calling");
    print("is Enabled $isEnabled");

    prefs = await SharedPreferences.getInstance();
    final remindersJson = prefs.getStringList('reminders') ?? [];
    print(remindersJson);
    List<ReminderCard> temp = [];
    temp.addAll(
      remindersJson.map((json) => ReminderCard.fromJson(jsonDecode(json))),
    );
    reminders = temp;
    setState(() {
      print(reminders[0].isEnabled);

      // reminders.clear();
      // List<ReminderCard> temp = [];
      // temp.addAll(
      //   remindersJson.map((json) => ReminderCard.fromJson(jsonDecode(json))),
      // );
      // reminders = temp;
      // print(reminders);
      // print("after adding reminder cards");
      //print(reminders[0].isEnabled);
      // print(reminders[1].isEnabled);
      // reminders = [];
      // // Find the reminder with the given title
      // final index = reminders.indexWhere((reminder) => reminder.title == title);
      // if (index >= 0) {
      //   // Update the isEnabled value for the reminder
      //   reminders[index].isEnabled = isEnabled;
      //   // Convert the list of reminders back to a JSON-encoded string
      //   final remindersJson =
      //       reminders.map((reminder) => jsonEncode(reminder.toJson())).toList();
      //   reminders = remindersJson as List<ReminderCard>;
      //   // Save the updated list of reminders back to SharedPreferences
      //   prefs.setStringList('reminders', remindersJson);
      // }
      // print("ji");
      // print(reminders);
    });
  }

  Future<void> _deleteReminder(String title) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final remindersJson = prefs.getStringList('reminders') ?? [];

    setState(() {
      reminders.clear();
      reminders.addAll(
        remindersJson.map((json) => ReminderCard.fromJson(jsonDecode(json))),
      );

      // Find the reminder with the given title
      final index = reminders.indexWhere((reminder) => reminder.title == title);
      if (index >= 0) {
        // Remove the reminder from the list
        reminders.removeAt(index);
        // Convert the list of reminders back to a JSON-encoded string
        final remindersJson =
            reminders.map((reminder) => jsonEncode(reminder.toJson())).toList();
        // Save the updated list of reminders back to SharedPreferences
        prefs.setStringList('reminders', remindersJson);
      }

      print(reminders);
      // widget.onDelete();
    });
  }

  Future<void> updateReminder(ReminderCard reminder) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final remindersJson = prefs.getStringList('reminders') ?? [];

    setState(() {
      reminders.clear();
      reminders.addAll(
        remindersJson.map((json) => ReminderCard.fromJson(jsonDecode(json))),
      );

      // Find the index of the reminder to be updated
      final index = reminders.indexWhere((r) => r.title == reminder.title);
      if (index >= 0) {
        // Update the reminder with the new values
        reminders[index] = reminder;
        // Convert the updated list of reminders back to a JSON-encoded string
        final remindersJson =
            reminders.map((r) => jsonEncode(r.toJson())).toList();
        // Save the updated list of reminders back to SharedPreferences
        prefs.setStringList('reminders', remindersJson);
      }
      setState(() {
        reminders;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    void _showEditReminderDialog() {
      final titleController = TextEditingController(text: widget.title);
      final reminderMessageController =
          TextEditingController(text: widget.reminderMessage);
      final repeatDays = widget.repeatDays;

      showDialog(
        context: context,
        builder: (BuildContext context) {
          Duration breakDuration = widget.breakDuration;
          Duration nextReminderDuration = widget.nextReminderDuration;
          return AlertDialog(
            title: const Text('Edit Reminder'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: titleController,
                    decoration: const InputDecoration(
                      labelText: 'Title',
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text('Break Duration'),
                  DurationPicker(
                    baseUnit: BaseUnit.second,
                    duration: breakDuration,
                    onChange: (val) {
                      setState(() => breakDuration = val);
                    },
                    snapToMins: 1.0,
                  ),
                  SizedBox(height: 10),
                  Text('Reminder Duration'),
                  DurationPicker(
                    duration: nextReminderDuration,
                    onChange: (val) {
                      setState(() => nextReminderDuration = val);
                    },
                    snapToMins: 1.0,
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: reminderMessageController,
                    decoration: const InputDecoration(
                      labelText: 'Reminder Message',
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text('Repeat Days'),
                  Wrap(
                    spacing: 10,
                    children: List.generate(7, (index) {
                      final day = index + 1;
                      return ChoiceChip(
                        label: Text(getWeekdayString(day)),
                        selected: repeatDays.contains(day),
                        onSelected: (selected) {
                          setState(() {
                            if (selected) {
                              repeatDays.add(day);
                            } else {
                              repeatDays.remove(day);
                            }
                          });
                        },
                      );
                    }),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                child: const Text('CANCEL'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: const Text('SAVE'),
                onPressed: () {
                  final reminder = ReminderCard(
                    title: titleController.text,
                    breakDuration: breakDuration,
                    nextReminderDuration: nextReminderDuration,
                    reminderMessage: reminderMessageController.text,
                    repeatDays: repeatDays,
                    isEnabled: widget.isEnabled,
                  );
                  print(reminders);
                  updateReminder(reminder);
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }

    void _showDeleteReminderDialog() {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Delete Reminder"),
            content:
                const Text("Are you sure you want to delete this reminder?"),
            actions: [
              TextButton(
                child: const Text("Cancel"),
                onPressed: () => Navigator.of(context).pop(),
              ),
              TextButton(
                child: const Text("Delete"),
                onPressed: () {
                  Navigator.of(context).pop();

                  _deleteReminder(widget.title);
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) => Remindee(
                                refIndex: 1,
                              )));
                  // // ignore: use_build_context_synchronously
                  // await Navigator.push(
                  //   context,
                  //   MaterialPageRoute(builder: (context) => Remindee(refIndex: 1,)),
                  // );
                  // setState(() {
                  //   Navigator.of(context).pop();
                  //   // setState(() {

                  //   // });
                  //  });
                  //widget.onDelete();
                },
              ),
            ],
          );
        },
      );
    }

    final now = DateTime.now();
    final nextReminderTime = now.add(widget.nextReminderDuration);

    final interval = nextReminderTime.difference(now).inMinutes;

    return GestureDetector(
      onLongPress: () {
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text("Reminder Options"),
                content: const Text("What would you like to do?"),
                actions: [
                  TextButton(
                    child: const Text("Edit"),
                    onPressed: () {
                      Navigator.of(context).pop();
                      _showEditReminderDialog();
                    },
                  ),
                  TextButton(
                    child: const Text("Delete"),
                    onPressed: () {
                      Navigator.of(context).pop();
                      _showDeleteReminderDialog();
                    },
                  ),
                ],
              );
            });
      },
      child: Container(
        height: 130,
        margin: const EdgeInsets.only(left: 20, right: 30, top: 30),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          color: widget.isEnabled
              ? Theme.of(context).colorScheme.secondary
              : Theme.of(context).colorScheme.primary,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Next Interval: ${(widget.nextReminderDuration).inMinutes} mins',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Break Duration: ${(widget.breakDuration).inSeconds} sec',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
                Switch(
                  value: widget.isEnabled,
                  onChanged: (value) {
                    setState(() {
                      () async {
                        await _updateReminderEnabled(widget.title, value);
                      }();
                      widget.isEnabled = value;
                    });
                  },
                  activeColor: Colors.white,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String getWeekdayString(int day) {
    switch (day) {
      case 1:
        return 'Mon';
      case 2:
        return 'Tue';
      case 3:
        return 'Wed';
      case 4:
        return 'Thu';
      case 5:
        return 'Fri';
      case 6:
        return 'Sat';
      case 7:
        return 'Sun';
      default:
        return '';
    }
  }
}
