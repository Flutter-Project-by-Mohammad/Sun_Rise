import 'package:flutter/material.dart';
import 'package:test_12/Screens/Whether.dart';
import 'package:test_12/Screens/favorit.dart';
import 'package:test_12/Models/WeatherAPI.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;
  List<Map<String, dynamic>> favoriteCities = [];
  Map<String, String> cityNotes = {};

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void addFavorite(WeatherApi weather) {
    final city = weather.name;
    if (!favoriteCities.any((fav) => fav['name'] == city)) {
      setState(() {
        favoriteCities.add({
          'name': city,
          'temperature': weather.temperature,
          'observation_time': weather.observation_time,
          'weather_descriptions': weather.weather_descriptions,
          'weather_icons': weather.weather_icons,
        });
        cityNotes[city] = "";
      });
    }
  }

  void removeFavorite(String city) {
    setState(() {
      favoriteCities.removeWhere((fav) => fav['name'] == city);
      cityNotes.remove(city);
    });
  }

  void updateNote(String city, String note) {
    setState(() {
      cityNotes[city] = note;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> _pages = [
      WeatherPage(
        favoriteCities: favoriteCities,
        onAddFavorite: addFavorite,
        onRemoveFavorite: removeFavorite,
        cityNotes: cityNotes,
        onUpdateNote: updateNote,
      ),
      FavoritePage(
        favoriteCities: favoriteCities,
        cityNotes: cityNotes,
        onRemoveFavorite: removeFavorite,
        onUpdateNote: updateNote,
      ),
    ];

    return Scaffold(
      body: _pages[_selectedIndex],
      backgroundColor: Colors.white,
      bottomNavigationBar: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
        child: Container(
          child: BottomNavigationBar(
            backgroundColor: Colors.grey.shade100,
            type: BottomNavigationBarType.fixed,
            selectedItemColor: Colors.blue,
            unselectedItemColor: Colors.grey,
            showSelectedLabels: false,
            showUnselectedLabels: false,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.cloud),
                label: "Weather",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.favorite_border),
                label: "Favorites",
              ),
            ],
            currentIndex: _selectedIndex,
            onTap: _onItemTapped,
          ),
        ),
      ),
    );
  }
}
