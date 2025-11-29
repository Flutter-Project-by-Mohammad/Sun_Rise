import 'package:flutter/material.dart';
import '../Widgets/FavoriteCityCard.dart';

class FavoritePage extends StatefulWidget {
  final List<Map<String, dynamic>> favoriteCities;
  final Map<String, String> cityNotes;
  final Function(String) onRemoveFavorite;
  final Function(String, String) onUpdateNote;

  const FavoritePage({
    super.key,
    required this.favoriteCities,
    required this.cityNotes,
    required this.onRemoveFavorite,
    required this.onUpdateNote,
  });

  @override
  State<FavoritePage> createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  final Map<String, TextEditingController> _noteControllers = {};

  @override
  void initState() {
    super.initState();
    for (var cityData in widget.favoriteCities) {
      final city = cityData['name'];
      _noteControllers[city] = TextEditingController(
        text: widget.cityNotes[city] ?? "",
      );
    }
  }

  @override
  void dispose() {
    _noteControllers.values.forEach((controller) => controller.dispose());
    super.dispose();
  }

  void _updateNote(String city) {
    final note = _noteControllers[city]?.text ?? "";
    widget.onUpdateNote(city, note);
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Note updated for $city')));
  }

  void _removeCity(String city) {
    widget.onRemoveFavorite(city);
    _noteControllers.remove(city);
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('$city removed from favorites')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          "Favorites",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.favorite, color: Colors.red),
          ),
        ],
      ),
      body: widget.favoriteCities.isEmpty
          ? _buildEmptyState()
          : _buildFavoriteList(),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.favorite_border, size: 64, color: Colors.grey),
          const SizedBox(height: 16),
          const Text(
            "No favorites yet",
            style: TextStyle(fontSize: 18, color: Colors.grey),
          ),
          const SizedBox(height: 8),
          const Text(
            "Tap the heart icon to add city to favorites",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildFavoriteList() {
    return ListView.builder(
      itemCount: widget.favoriteCities.length,
      itemBuilder: (context, index) {
        final cityData = widget.favoriteCities[index];
        final city = cityData['name'];
        final temperature = cityData['temperature'];
        final observationTime = cityData['observation_time'];
        final weatherDescription = cityData['weather_descriptions'];
        final weatherIcon = cityData['weather_icons'];

        _noteControllers.putIfAbsent(
          city,
          () => TextEditingController(text: widget.cityNotes[city] ?? ""),
        );

        return FavoriteCityCard(
          city: city,
          temperature: temperature,
          observationTime: observationTime,
          weatherDescription: weatherDescription,
          weatherIcon: weatherIcon,
          noteController: _noteControllers[city]!,
          onUpdateNote: () => _updateNote(city),
          onRemove: () => _removeCity(city),
        );
      },
    );
  }
}
