import 'dart:async';
import 'package:flutter/material.dart';
import 'package:weather_app/models/weather_api.dart';
import 'package:weather_app/services/weather_service.dart';
import 'package:weather_app/colors/colors.dart';
import 'package:weather_app/widgets/forecast_card.dart';
import 'package:weather_app/widgets/header.dart';
import 'package:weather_app/widgets/info_card.dart';
import 'package:weather_app/widgets/daily_forecast_card.dart';
import 'package:weather_app/Pages/community_insights_page.dart';

class WeatherHomePage extends StatefulWidget {
  const WeatherHomePage({super.key});

  @override
  State<WeatherHomePage> createState() => _WeatherHomePageState();
}

class _WeatherHomePageState extends State<WeatherHomePage> {
  WeatherService weatherService = WeatherService();
  Weather weather = Weather();

  String city = 'Atlanta'; // Default city
  Color defaultColor = Colors.black;
  bool isDay = false;
  String loadingIcon = '';
  bool _isLoading = true;

  Future<void> getWeather() async {
    try {
      weather = await weatherService.getWeatherData(city);
      determineDayOrNight();
      updateIcons();
      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      print('Error fetching weather data: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  void determineDayOrNight() {
    List datetime = weather.date.split(' ');
    var hours = datetime[1].split(':');
    var currentHour = int.parse(hours[0]);

    if (currentHour >= 19 || currentHour < 6) {
      setState(() {
        isDay = false;
        defaultColor = nightappbarcolor;
      });
    } else {
      setState(() {
        isDay = true;
        defaultColor = dayappbarcolor;
      });
    }
  }

  void updateIcons() {
    final iconUrl = weather.forecast[0]['condition']['icon']
        .toString()
        .replaceAll('//', 'http://');
    setState(() {
      loadingIcon = iconUrl;
    });
  }

  void updateCity(String newCity) {
    setState(() {
      city = newCity;
      _isLoading = true;
    });
    getWeather();
  }

  @override
  void initState() {
    super.initState();
    getWeather();
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? const Center(child: CircularProgressIndicator())
        : Scaffold(
            appBar: PreferredSize(
              preferredSize: const Size.fromHeight(300),
              child: Header(
                backgroundColor: defaultColor,
                city_name: weather.city,
                description: weather.text,
                descriptionIMG: loadingIcon,
                state_name: weather.state,
                temp: weather.temp,
                onCityChange: updateCity,
              ),
            ),
            body: Column(
              children: [
                // Weather Content
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: const Alignment(-1.5, 8),
                        end: const Alignment(-1.5, -0.5),
                        colors: [Colors.white, defaultColor],
                      ),
                    ),
                    child: CustomScrollView(
                      physics: const BouncingScrollPhysics(),
                      slivers: <Widget>[
                        // Hourly Forecast
                        SliverToBoxAdapter(
                          child: Container(
                            height: 200,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: weather.forecast.length,
                              itemBuilder: (context, index) => ForecastCard(
                                hour: weather.forecast[index]['time']
                                    .toString()
                                    .split(' ')[1],
                                averageTemp: weather.forecast[index]['temp_f'],
                                description: weather.forecast[index]
                                    ['condition']['text'],
                                descriptionIMG: weather.forecast[index]
                                        ['condition']['icon']
                                    .toString()
                                    .replaceAll('//', 'http://'),
                              ),
                            ),
                          ),
                        ),
                        // Today's Weather Info
                        SliverToBoxAdapter(
                          child: InformartionsCard(
                            humidity: weather.humidity,
                            uvIndex: weather.uvIndex,
                            wind: weather.wind,
                          ),
                        ),
                        // Extended Outlook Header
                        SliverToBoxAdapter(
                          child: Container(
                            margin: const EdgeInsets.only(top: 20),
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: const Text(
                              "Extended Outlook: Next 7 Days",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        // Extended Forecast
                        SliverToBoxAdapter(
                          child: SizedBox(
                            height: 300,
                            child: ListView.builder(
                              itemCount: weather.dailyForecast.length,
                              itemBuilder: (context, index) {
                                final daily = weather.dailyForecast[index];
                                return DailyForecastCard(
                                  day: daily['date'],
                                  maxTemp: daily['day']['maxtemp_f'],
                                  minTemp: daily['day']['mintemp_f'],
                                  description: daily['day']['condition']
                                      ['text'],
                                  iconUrl: daily['day']['condition']['icon']
                                      .toString()
                                      .replaceAll('//', 'http://'),
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // Community Insights Button
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const CommunityInsightsPage(),
                        ),
                      );
                    },
                    child: const Text('Community Insights'),
                  ),
                ),
              ],
            ),
          );
  }
}
