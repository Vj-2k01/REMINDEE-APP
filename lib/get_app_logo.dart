import 'package:app_usage/app_usage.dart';
import 'package:flutter/material.dart';
import 'package:installed_apps/app_info.dart';
import 'package:installed_apps/installed_apps.dart';

class AppUsageWithLogo {
  static Future<List<AppUsageInfoWithLogo>> getAppUsageWithLogo(DateTime startDate, DateTime endDate) async {
    List<AppUsageInfo> appUsageInfos = await AppUsage().getAppUsage(startDate, endDate);
    List<AppInfo> appInfos = await InstalledApps.getInstalledApps(true, true);

    List<AppUsageInfoWithLogo> appUsageInfosWithLogo = [];

   for (var appUsageInfo in appUsageInfos) {
    //   var appInfo = appInfos.firstWhere(
    //     (info) => info.packageName == appUsageInfo.packageName,
    //    // orElse: () => null,
    //   );
    var appInfo = appInfos.firstWhere(
  (info) => info.packageName == appUsageInfo.packageName,
  orElse: () => AppInfo(
    appUsageInfo.appName,
    null, // or provide default icon
    appUsageInfo.packageName,
    null, // or provide default versionName
    null, // or provide default versionCode
  ),
);
 if (appInfo == null || appInfo.icon == null) {
        continue; // skip the iteration if either appInfo or icon is null
      }
      
      appUsageInfosWithLogo.add(
        AppUsageInfoWithLogo(
          appName: appUsageInfo.appName,
          packageName: appUsageInfo.packageName,
          usage: appUsageInfo.usage,
          logo: MemoryImage(appInfo.icon!),
        ),
      );
    }
    return appUsageInfosWithLogo;
  }
}

class AppUsageInfoWithLogo {
  final String appName;
  final String packageName;
  final Duration usage;
  final ImageProvider<Object> logo;

  AppUsageInfoWithLogo({
    required this.appName,
    required this.packageName,
    required this.usage,
    required this.logo,
  });

  get usageList => null;
}
