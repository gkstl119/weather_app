import 'package:flutter/material.dart';
import 'package:weather_app/services/weather_service.dart';

class Header extends StatefulWidget {
  Header({
    super.key,
    required this.backgroundColor,
    required this.city_name,
    required this.description,
    required this.descriptionIMG,
    required this.state_name,
    required this.temp,
    required this.onCityChange, // Callback for city change
  });

  final String city_name;
  final String state_name;
  final double temp;
  final String descriptionIMG;
  final String description; // Weather condition text
  final Color backgroundColor;
  final Function(String) onCityChange; // Callback for location search

  @override
  State<Header> createState() => _HeaderState();
}

class _HeaderState extends State<Header> {
  var _textfieldController = TextEditingController();
  bool _isLoading = false;

  void _searchCity(String value) {
    setState(() {
      _isLoading = true; // Start the spinner while fetching
    });

    // Pass the new city to the parent widget (WeatherHomePage)
    widget.onCityChange(value);

    // Clear the search field and stop the spinner
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        _textfieldController.clear();
        _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      toolbarHeight: MediaQuery.of(context).size.height / 3,
      backgroundColor: widget.backgroundColor,
      title: Padding(
        padding: const EdgeInsets.only(top: 25),
        child: Column(
          children: [
            Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Temperature
                    Text(
                      '${widget.temp.toStringAsFixed(1)}°',
                      style: const TextStyle(
                        fontSize: 50,
                        fontWeight: FontWeight.w300,
                        color: Colors.white,
                      ),
                    ),
                    // City Name
                    Text(
                      widget.city_name,
                      style: const TextStyle(
                        fontSize: 25,
                        color: Colors.white,
                      ),
                    ),
                    // State/Region Name
                    Text(
                      widget.state_name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w300,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                // Weather Icon
                Container(
                  width: 100,
                  height: 100,
                  child: Image.network(
                    widget.descriptionIMG,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Icon(
                        Icons.error_outline,
                        color: Colors.white,
                        size: 50,
                      );
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            // Weather Description (e.g., Sunny, Cloudy)
            Text(
              widget.description,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white70,
              ),
            ),
            const SizedBox(height: 10),
            // Search Bar
            _isLoading
                ? const CircularProgressIndicator() // Spinner while searching
                : TextField(
                    controller: _textfieldController,
                    onSubmitted: _searchCity,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      suffixIcon: IconButton(
                        onPressed: () {
                          _textfieldController.clear();
                          FocusScope.of(context).unfocus();
                        },
                        icon: const Icon(Icons.clear),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 5),
                      hintText: 'Search for cities',
                      hintStyle: const TextStyle(
                        color: Color.fromARGB(133, 255, 255, 255),
                      ),
                      filled: true,
                      fillColor: const Color.fromARGB(18, 255, 255, 255),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      disabledBorder: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
