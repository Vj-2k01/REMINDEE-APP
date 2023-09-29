import 'package:app_usage/app_usage.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:syncfusion_flutter_charts/charts.dart';

class DataPoint {
  final DateTime date;
  final int usageTime;

  DataPoint(this.date, this.usageTime);
}

List<DataPoint> _dataPoints = [];

class LineGraph extends StatefulWidget {
  const LineGraph({super.key});

  @override
  _LineGraphState createState() => _LineGraphState();
}

class _LineGraphState extends State<LineGraph> {
  @override
  void initState() {
    super.initState();
    getUsageStats();
    getPreviousDaysUsageData();
  }

  Future<void> getUsageStats() async {
    // Calculate current day's app usage
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

    // Get the app usage for the day
    List<AppUsageInfo> infoList =
        await AppUsage().getAppUsage(startTime, endTime);

    // Calculate the total usage for the day
    Duration totalUsage = Duration.zero;
    for (var info in infoList) {
      totalUsage += info.usage;
    }

    // Store the usage time in shared preferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String currentDayKey = '${endTime.year}-${endTime.month}-${endTime.day}';
    print(currentDayKey);

    prefs.setInt(currentDayKey, totalUsage.inHours);

    setState(() {
      // prefs.setInt('2023-5-1', 9);
      // prefs.setInt('2023-5-2', 3);
      // prefs.setInt('2023-5-3', 5);
      // prefs.setInt('2023-5-4', 5);
      // prefs.setInt('2023-5-5', 4);
      //  prefs.setInt('2023-5-10', 6);
    }); // Update UI with new data
  }

  void getPreviousDaysUsageData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    DateTime today = DateTime.now();

    _dataPoints.clear(); // Clear the existing data points

    // Fetch the usage data for the previous 6 days
    for (int i = 6; i >= 0; i--) {
      DateTime date = today.subtract(Duration(days: i));
      String key = '${date.year}-${date.month}-${date.day}';

      // Retrieve the usage time for the day from shared preferences
      int usageTime = prefs.getInt(key) ?? 0;

      // Add the data point to the list
      _dataPoints.add(DataPoint(date, usageTime));
      print(
          'Date: ${date.year}-${date.month}-${date.day}, Usage Time: $usageTime');
    }

    setState(
        () {}); // Trigger a state update to refresh the graph with the new data points
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: 220,
        width: 400,
        // padding: EdgeInsets.all(10.0),
        child: _dataPoints.isNotEmpty
            ? SfCartesianChart(
                primaryXAxis: CategoryAxis(
                  majorGridLines:
                      const MajorGridLines(color: Colors.transparent),
                  labelRotation: 45,
                  labelPlacement: LabelPlacement.betweenTicks,
                  //edgeLabelPlacement: EdgeLabelPlacement.shift,
                ),
                primaryYAxis: NumericAxis(
                  labelFormat: '{value}hr',
                  majorTickLines:
                      const MajorTickLines(color: Colors.transparent),
                  axisLine: const AxisLine(width: 0, color: Colors.transparent),
                ),
                series: <ChartSeries>[
                  LineSeries<DataPoint, String>(
                    dataSource: _dataPoints,
                    xValueMapper: (DataPoint data, _) =>
                        getWeekdayAbbreviation(data.date.weekday),
                    yValueMapper: (DataPoint data, _) => data.usageTime,
                    markerSettings: MarkerSettings(
                        isVisible: true,
                        width: 3,
                        height: 3,
                        color: Theme.of(context).colorScheme.primary),
                  ),
                ],
                tooltipBehavior: TooltipBehavior(
                    // Add tooltip behavior to enable tooltips
                    enable: true,
                    color: Theme.of(context).colorScheme.secondary),
              )
            : const Text('No data available'),
      ),
    );
  }
}

String getWeekdayAbbreviation(int weekday) {
  switch (weekday) {
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

void main() {
  runApp(const LineGraph());
}
