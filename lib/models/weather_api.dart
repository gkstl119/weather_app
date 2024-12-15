class Weather {
  final String city;
  final double temp;
  final String text;
  final String date;
  final String state;
  final int humidity;
  final double uvIndex;
  final double wind;
  final List forecast;
  final List dailyForecast;

  Weather({
    this.city = '',
    this.date = '',
    this.forecast = const [],
    this.dailyForecast = const [],
    this.humidity = 0,
    this.state = '',
    this.temp = 0,
    this.text = '',
    this.uvIndex = 0,
    this.wind = 0,
  });

  factory Weather.fromJson(json) {
    final List dailyForecastData = json['forecast']['forecastday'];
    return Weather(
      uvIndex: json['current']['uv'],
      city: json['location']['name'],
      date: json['location']['localtime'],
      forecast: json['forecast']['forecastday'][0]['hour'],
      dailyForecast: dailyForecastData,
      humidity: json['current']['humidity'],
      state: json['location']['region'],
      temp: json['current']['temp_f'],
      text: json['current']['condition']['text'],
      wind: json['current']['wind_kph'],
    );
  }
}
