import 'dart:convert';
import 'dart:ui';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:weather_app/widgets/HourFrc.dart';
import 'package:weather_app/widgets/addinfo.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}
final apiKey = dotenv.env['API_KEY'];
class _WeatherScreenState extends State<WeatherScreen> {

late Future<Map<String,dynamic>> weather;
Future<Map<String, dynamic>> getCurrentWeather() async {
  try {
    final response = await http.get(
      Uri.parse('https://api.openweathermap.org/data/3.0/onecall?lat=33.6844&lon=73.0479&units=metric&appid=$apiKey'),
    );
    var data = jsonDecode(response.body);
    if (response.statusCode != 200) {
      throw 'Error : ${response.statusCode} - ${response.body}';   
    } 

      return data;
  }
  catch (e) {
    
    throw e.toString() ;
  }
}
@override
  void initState() {
     
    super.initState();
    weather=getCurrentWeather();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Weather"),
        centerTitle: true,
        actions: [
          IconButton(onPressed: () {
            setState(() {
              weather=getCurrentWeather();
            });
          }, icon: const Icon(Icons.refresh),)
        ],
      ),
      body:  FutureBuilder(
        future: weather,
        builder: (context, snapshot){
          
          if(snapshot.connectionState == ConnectionState.waiting)
          {
            return const Center(child: CircularProgressIndicator.adaptive());
          }
          if(snapshot.hasError)
          {
            return Center(child: Text(snapshot.error.toString()));
          }
          final data = snapshot.data!;
          final currentTemp = data['current']['temp'];
          final currentWeather = data['current']['weather'][0]['description'];
          final currentsky = data['current']['weather'][0]['main'];
          final chumidity = data['current']['humidity'];
          final cwindSpeed = data['current']['wind_speed'];
          final cpressure = data['current']['pressure'];
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
               SizedBox(
                  width: double.infinity,
                  child:  Card(
                    shadowColor: Colors.grey.shade800.withOpacity(0.5),
                    elevation: 10,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    color: const Color(0xFF4A5C6A),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 10,sigmaY: 10),
                        child:   Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            children: [
                              Text("$currentTemp°C",
                              style: const TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                              ),
                              ),
                               Icon(
                               currentsky == 'Clouds' || currentsky == 'Rain' ? Icons.cloud_rounded : Icons.sunny,
                              size: 64,),
                               Text("$currentWeather",
                              style: const TextStyle(
                                fontSize: 20,
                              ),)
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                 const Text("Hourly Forecast",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                  ),
                const SizedBox(height: 15),
               SizedBox(
                height: 140,
                 child: ListView.builder(
                
                  scrollDirection: Axis.horizontal,
                  itemCount: 8,
                  itemBuilder:  (context,index){
                   
                    final hourfc = data['hourly'][index];
                    final hourTimestamp = hourfc['dt'];
                      final DateTime time = DateTime.fromMillisecondsSinceEpoch(hourTimestamp * 1000);
                      final String formattedTime = DateFormat.j().format(time);
                    return HourFrc(
                      
                      time: formattedTime,
                    icon: data['hourly'][index]['weather'][0]['main'] == 'Cloud' || data['hourly'][index]['weather'][0]['main'] == 'Rain' ?  Icons.cloud_rounded : Icons.sunny,
                      temperature: hourfc['temp'].toString()
                      );
                  }
                  ),
               ),
                 const SizedBox(height: 20,),
                 const Text("Additional Information",
                 style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                 ),),
                 const SizedBox(height: 10,),
                 Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                         AdditionalInfo(icon: Icons.water_drop_outlined, label: "Humidity", value : '$chumidity%'),
                        AdditionalInfo(icon: Icons.beach_access, label: 'Pressure', value: '$cpressure hPa',),
                       AdditionalInfo(icon: Icons.air_outlined,label:'Wind Speed',value: '$cwindSpeed m/s',),
                  ],
                )
              ],
            ),
          );
        }
      ),
    );
  }
}
