import 'dart:convert';
import 'dart:ui';
import 'package:arusha_weather/secret.dart';
import 'package:flutter/cupertino.dart';
import 'package:arusha_weather/additional_info_item.dart';
import 'package:arusha_weather/hourly_forcast_item.dart';
import 'package:cupertino_progress_bar/cupertino_progress_bar.dart';
import 'package:intl/intl.dart';

import 'package:http/http.dart' as http;

class ArushaWeatherApp extends StatefulWidget {
  const ArushaWeatherApp({super.key});

  @override
  State<ArushaWeatherApp> createState() => _ArushaWeatherApp();
}

class _ArushaWeatherApp extends State<ArushaWeatherApp> {
  late Future<Map<String, dynamic>> weather;

  @override
  void initState(){
    super.initState();
    weather = getCurrentWeather();
  }

  Future <Map<String, dynamic>> getCurrentWeather() async{
    try{
      String cityName = 'Arusha';
      final res = await http.get(
        Uri.parse(
          'https://api.openweathermap.org/data/2.5/forecast?q=$cityName,tz&APPID=$openWeatherAPIKey'
        ),
      );
      
      final data = jsonDecode(res.body);
      if (data['cod'] != "200"){
        throw 'Unexpected error occured';
      }

      return data;

      }catch(e){
        throw e.toString();
      }
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(  
     child: Column(
       children: [
        const Text(
          "Weather App",
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold
          ),
          
          ),
         FutureBuilder(
              future: getCurrentWeather(), 
              builder: (context, snapshot){
                if (snapshot.connectionState == ConnectionState.waiting){
                  return const Center(
                    child: CupertinoProgressBar(),
                  );
                }
                if (snapshot.hasError){
                  return Center(
                    child: Text(
                      snapshot.error.toString(),
                      style:  const TextStyle(
                        color: CupertinoColors.systemRed,
                        fontSize: 24,
                        fontWeight: FontWeight.bold
                      ),
                      ),
                    );
                }
         
                final data = snapshot.data!;
                final currentWeatherData = data['list'][0];
                final currentTemp = currentWeatherData['main']['temp'];
                final currentSky = currentWeatherData['weather'][0]['main'];
                final currentPressure = currentWeatherData['main']['pressure'];
                final currentWindSpeed = currentWeatherData['wind']['speed'];
                final currentHumidity = currentWeatherData['main']['humidity'];
         
               
                return  Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                          SizedBox(
                  width: double.infinity,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(
                        16,
                      ),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(
                          sigmaX: 10,
                         sigmaY: 10,
                        ),
                        child:   Padding(
                          padding:  const EdgeInsets.all(16),
                          child: Column(
                            children: [
                              Text(
                                "${(currentTemp - 273.15).toStringAsFixed(2)}\u00B0 C",
                                style:  const TextStyle(
                                    fontSize: 30, 
                                    fontWeight: FontWeight.bold
                                ),
                              ),
                               const SizedBox(
                                height: 16,
                              ),
                                Icon(
                                currentSky == 'Clouds' || currentSky == 'Rain'
                                ?CupertinoIcons.cloud
                                :CupertinoIcons.sunrise,
                                size: 64,
                              ),
                                Text(
                                currentSky,
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                   const SizedBox(
                  height: 20,
                ),
                 const Text(
                  "Weather Forcasting",
                  style: TextStyle(fontSize: 24, 
                  fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                SizedBox(
                  height: 140,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: 39,
                    itemBuilder: (context, index){
                      final hourlyForcast = data['list'][index + 1];
                      final hourlySky = hourlyForcast['weather'][0]['main'];
                      final hourlyTime = hourlyForcast['dt_txt'].toString();
                      final hourlyTemp = hourlyForcast['main']['temp'];
                      final time = DateTime.parse(hourlyTime);
         
                      return HourlyForcastItem(
                        time: DateFormat.jm().format(time), 
                        icon: hourlySky == 'Clouds' || hourlySky == 'Rain'
                        ? CupertinoIcons.cloud
                        : CupertinoIcons.sunrise, 
                        temperature: '${(hourlyTemp - 273.15).toStringAsFixed(2)}\u00B0 C',
                        );
                    },
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                const Text(
                  "Additional Forcasting",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold
                  ),
                  ),
                  const SizedBox(
                  height: 20,
                ),
                 Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    AdditionalInfoItem(
                        icon: CupertinoIcons.drop, 
                        label: "Humidity", 
                        value: "$currentHumidity%",
                        ),
                    AdditionalInfoItem(
                        icon: CupertinoIcons.waveform,
                        label: "Wind Speed",
                        value: "$currentWindSpeed km/h",
                        ),
                    AdditionalInfoItem(
                        icon: CupertinoIcons.thermometer,
                        label: "Pressure",
                        value: "$currentPressure hPa",
                        ),
                      ],
                        ),
                      ],
                    ),
                   ),
                 );
                },
              ),
       ],
     ),
      );
  }
}
