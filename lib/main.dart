import 'package:flutter/material.dart';
import 'package:remindee/remindee.dart';
import 'package:remindee/reminder.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeService();
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const SplashScreenPage(),
      theme: ThemeData(
        fontFamily: 'Poppins',
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromRGBO(18,41,75,255),
        ).copyWith(
          secondary: const Color.fromRGBO(172,224,175, 1),
        ),
      ),
      routes: {
        '/remindee': (context) => Remindee(refIndex: 1),
      },
    ),
  );
}
class SplashScreenPage extends StatefulWidget {
  const SplashScreenPage({super.key});

  @override
  State<SplashScreenPage> createState() => _SplashScreenPageState();
}

class _SplashScreenPageState extends State<SplashScreenPage> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => Remindee()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:Theme.of(context).colorScheme.secondary,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              "assets/images/logo.jpeg",
              height: 200,
              width: 200,
            ),
            const SizedBox(
              height: 30,
            ),
          ],
        ),
      ),
    );
  }
}