import 'package:flutter/material.dart';
import 'package:remindee/remindee.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class AppUsageGraph extends StatelessWidget {
  final String appName;
  final Map<String, int> usageData;
  final ImageProvider logo;
  const AppUsageGraph(this.appName, this.usageData, this.logo, {super.key});

  @override
  Widget build(BuildContext context) {
    final data = usageData.entries
        .map((entry) => GraphData(entry.key, entry.value))
        .toList();
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
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
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Remindee(
                                  refIndex: 2,
                                )));
                  },
                ),
                const SizedBox(
                  width: 30,
                ),
                Text(
                  appName,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontSize: 30,
                  ),
                ),
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(left: 20, top: 40, bottom: 20),
            child: Text(
              "App Usage",
              style: TextStyle(fontSize: 20),
            ),
          ),
          Center(
            child: Image(
              image: logo,
              width: 48,
              height: 48,
            ),
          ),
          SizedBox(
            width: 400,
            height: 200,
            child: SfCartesianChart(
              primaryXAxis: CategoryAxis(
                majorGridLines: const MajorGridLines(color: Colors.transparent),
                labelRotation: 360,
                // labelPlacement: LabelPlacement.onTicks,
                edgeLabelPlacement: EdgeLabelPlacement.shift,
              ),
              primaryYAxis: NumericAxis(
                labelFormat: '{value}hr',
                majorTickLines: const MajorTickLines(color: Colors.transparent),
                axisLine: const AxisLine(width: 0, color: Colors.transparent),
              ),
              series: <LineSeries<GraphData, String>>[
                LineSeries<GraphData, String>(
                    dataSource: data,
                    xValueMapper: (GraphData usage, _) => usage.weekDay,
                    yValueMapper: (GraphData usage, _) =>
                        usage.timeInForeground,
                    name: 'Usage',
                    markerSettings: MarkerSettings(
                        isVisible: true,
                        width: 3,
                        height: 3,
                        color: Theme.of(context).colorScheme.primary)),
              ],
              tooltipBehavior: TooltipBehavior(
                  // Add tooltip behavior to enable tooltips
                  enable: true,
                  color: Theme.of(context).colorScheme.secondary),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          const Center(
            child: Text(
              'Today',
              style: TextStyle(fontSize: 18),
            ),
          ),
          Center(
            child: Text(
              '${data.last.timeInForeground} hrs',
              style: const TextStyle(fontSize: 18),
            ),
          ),
        ],
      ),
    );
  }
}

class GraphData {
  final String weekDay;
  final int timeInForeground;

  GraphData(this.weekDay, this.timeInForeground);
}
