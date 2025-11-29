import 'package:flutter/material.dart';
import 'package:test_12/Services/API.dart';
import 'package:test_12/Models/WeatherAPI.dart';
import 'package:test_12/Widgets/WeatherCard.dart';

class WeatherPage extends StatefulWidget {
  final List<Map<String, dynamic>> favoriteCities;
  final Map<String, String> cityNotes;
  final Function(WeatherApi) onAddFavorite;
  final Function(String) onRemoveFavorite;
  final Function(String, String) onUpdateNote;

  const WeatherPage({
    super.key,
    required this.favoriteCities,
    required this.cityNotes,
    required this.onAddFavorite,
    required this.onRemoveFavorite,
    required this.onUpdateNote,
  });

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  bool isLoading = false;
  WeatherApi? weather;
  final _formKey = GlobalKey<FormState>();
  final searchController = TextEditingController();
  final noteController = TextEditingController();
  bool isFavorite = false;

  Future<void> _fetchWeather(String city) async {
    setState(() {
      isLoading = true;
    });

    try {
      final weatherData = await WeatherService.getWeather(city);
      setState(() {
        weather = weatherData;
        isFavorite = widget.favoriteCities.any(
          (fav) => fav['name'] == weatherData.name,
        );
        noteController.text = widget.cityNotes[weatherData.name] ?? "";
      });
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: $e')));
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void _toggleFavorite() {
    if (weather != null) {
      setState(() {
        isFavorite = !isFavorite;
      });

      if (isFavorite) {
        widget.onAddFavorite(weather!);
      } else {
        widget.onRemoveFavorite(weather!.name);
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            isFavorite ? 'Added to favorites!' : 'Removed from favorites!',
          ),
        ),
      );
    }
  }

  void _updateNote() {
    if (weather != null) {
      widget.onUpdateNote(weather!.name, noteController.text);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Note updated!')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          "Weather Page",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.cloud_queue, color: Colors.amber),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                _buildSearchForm(),
                const SizedBox(height: 30),
                if (isLoading)
                  const CircularProgressIndicator()
                else if (weather != null)
                  Column(
                    children: [
                      WeatherCard(
                        weather: weather!,
                        isFavorite: isFavorite,
                        onFavoritePressed: _toggleFavorite,
                      ),
                      _buildNoteSection(),
                    ],
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSearchForm() {
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(30, 30, 30, 0),
        child: Column(
          children: [
            TextFormField(
              controller: searchController,
              validator: (value) => value == null || value.isEmpty
                  ? 'City name is required'
                  : null,
              decoration: InputDecoration(
                labelText: "search",
                labelStyle: const TextStyle(color: Colors.black),
                hintText: "search for a city",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
                suffixIcon: const Icon(Icons.search),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: isLoading
                  ? null
                  : () {
                      if (_formKey.currentState!.validate()) {
                        _fetchWeather(searchController.text);
                      }
                    },
              child: isLoading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text("Get Weather Location"),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNoteSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Add a note for ${weather!.name}:",
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: noteController,
            maxLines: 3,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: "Enter your notes about this city...",
            ),
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: _updateNote,
            child: const Text("Save Note"),
          ),
        ],
      ),
    );
  }
}
