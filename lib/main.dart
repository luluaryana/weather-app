import 'package:arusha_weather/arusha_weather_cupertino.dart';
import 'package:flutter/cupertino.dart';

void main() {
  runApp(message);
}

const message = MyCupertinoApp();

class MyCupertinoApp extends StatelessWidget{
  const MyCupertinoApp({super.key});

  @override
  Widget build(BuildContext context){
    return const CupertinoApp(
      debugShowCheckedModeBanner: false,
        title: "Weather App",
        home: ArushaWeatherApp(),
    ); 
  }
} 
