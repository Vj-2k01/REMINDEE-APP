import 'package:flutter/material.dart';
import 'package:app_usage/app_usage.dart';
import 'package:remindee/get_app_logo.dart';
import 'package:remindee/app_analysis_page.dart';
import 'package:remindee/line_graph.dart';
import 'package:remindee/remindee.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:intl/intl.dart';

void main() => runApp(const AppList());

class AppList extends StatefulWidget {
  const AppList({super.key});

  @override
  AppListState createState() => AppListState();
}

class AppListState extends State<AppList> {
  List<AppUsageInfoWithLogo> _infosWithLogo = [];

  void getUsageStatsWithLogo() async {
    try {
      DateTime endDate = DateTime.now();
      DateTime startDate = endDate.subtract(const Duration(hours: 24));
      List<AppUsageInfoWithLogo> infoList =
          await AppUsageWithLogo.getAppUsageWithLogo(startDate, endDate);

      setState(() {
        getUsageStatsWithLogo;
        infoList.sort((a, b) => b.usage.compareTo(a.usage));
        _infosWithLogo = infoList;
      });

      for (var info in infoList) {
        print(info.toString());
      }
    } on AppUsageException catch (exception) {
      print(exception);
    }
  }

  Future<Map<String, int>> getUsageDataForApp(String packageName) async {
    DateTime endTime = DateTime.now();

    int daySubtracter = endTime.hour;
    int minSubtracter = endTime.minute;
    int secSubtracter = endTime.second;
    DateTime startTime = endTime.subtract(
      Duration(
        hours: daySubtracter,
        minutes: minSubtracter,
        seconds: secSubtracter,
      ),
    );

    // Perform your app usage calculations here
    // ...

    SharedPreferences prefs = await SharedPreferences.getInstance();
    Map<String, int> usageData = {};

    // Fetch the usage data for the previous 6 days
    DateFormat dateFormat = DateFormat('E');
    for (int i = 6; i >= 0; i--) {
      DateTime date = startTime.subtract(Duration(days: i));
      String key = dateFormat
          .format(date); // Format date to get day of the week (Sun - Sat)
      int usageTime = prefs.getInt("${key}_$packageName") ?? 0;
      usageData[key] = usageTime;
    }

    // Get the app usage for the current day
    List<AppUsageInfo> usageList =
        await AppUsage().getAppUsage(startTime, endTime);
    int currentDayUsageTime = 0;
    for (var usage in usageList) {
      if (usage.packageName == packageName) {
        currentDayUsageTime += usage.usage.inHours;
      }
    }

    // Store the current day usage time in SharedPreferences
    String currentDayKey = dateFormat.format(
        endTime); // Format current day to get day of the week (Sun - Sat)
    prefs.setInt("${currentDayKey}_$packageName", currentDayUsageTime);

    // Add the current day usage time to the usageData map
    usageData[currentDayKey] = currentDayUsageTime;

    return usageData;
  }

  @override
  void initState() {
    getUsageStatsWithLogo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<AppUsageInfoWithLogo> filteredList =
        _infosWithLogo.where((info) => info.usage.inMinutes > 0).toList();
    return Scaffold(
      body: Column(
        children: [
          const SizedBox(
            height: 40,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20),
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
                  'Dashboard',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontSize: 30,
                  ),
                ),
              ],
            ),
          ),
          LineGraph(),
          filteredList.isEmpty
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : Expanded(
                  child: ListView.builder(
                    itemCount: filteredList.length,
                    itemBuilder: (context, index) {
                      AppUsageInfoWithLogo info = filteredList.elementAt(index);
                      int usage = info.usage.inMinutes;

                      String timeUsage = '$usage mins';
                      usage >= 60
                          ? timeUsage = '${info.usage.inHours} hrs'
                          : timeUsage;
                      return ListTile(
                        leading: Image(
                          image: info.logo,
                          width: 48,
                          height: 48,
                        ),
                        title: Text(info.appName),
                        subtitle: Text(timeUsage),
                        trailing: Icon(
                          Icons.timer_outlined,
                          color: Colors.blueGrey[900],
                        ),
                        onTap: () async {
                          final usageData =
                              await getUsageDataForApp(info.packageName);
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => AppUsageGraph(
                                  info.appName, usageData, info.logo)));
                        },
                      );
                    },
                  ),
                ),
        ],
      ),
    );
  }
}
