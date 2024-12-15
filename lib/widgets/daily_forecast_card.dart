import 'package:flutter/material.dart';

class DailyForecastCard extends StatelessWidget {
  final String day;
  final double maxTemp;
  final double minTemp;
  final String description;
  final String iconUrl;

  const DailyForecastCard({
    super.key,
    required this.day,
    required this.maxTemp,
    required this.minTemp,
    required this.description,
    required this.iconUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color.fromARGB(18, 255, 255, 255),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            day,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          Row(
            children: [
              Image.network(
                iconUrl,
                height: 40,
                width: 40,
                fit: BoxFit.cover,
              ),
              const SizedBox(width: 10),
              Text(
                '$maxTemp° / $minTemp°',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          Text(
            description,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.white70,
            ),
          ),
        ],
      ),
    );
  }
}
