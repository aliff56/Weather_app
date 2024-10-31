import 'package:flutter/material.dart';
import 'package:weather_app/weather_screen.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: 'assets/api.env');
  runApp(const MyWeatherApp());
}
class MyWeatherApp extends StatelessWidget {
  const MyWeatherApp({super.key});

  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(useMaterial3: true),
      home: const WeatherScreen(),
    );
  }
}
