import 'package:flutter/material.dart';

class FavoriteFoodsScreen extends StatefulWidget {
  const FavoriteFoodsScreen({super.key});

  @override
  State<FavoriteFoodsScreen> createState() => _FavoriteFoodsScreenState();
}

class _FavoriteFoodsScreenState extends State<FavoriteFoodsScreen> {
  final List<String> _favoriteFoods = [];
  final TextEditingController _foodController = TextEditingController();

  void _addFavoriteFood() {
    final newFood = _foodController.text.trim();
    if (newFood.isNotEmpty) {
      setState(() {
        _favoriteFoods.add(newFood);
      });
      _foodController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorite Foods'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _foodController,
              decoration: const InputDecoration(
                labelText: 'Add a favorite food',
                border: OutlineInputBorder(),
              ),
              onSubmitted: (_) => _addFavoriteFood(),
            ),
            const SizedBox(height: 16.0),
            Expanded(
              child: ListView.builder(
                itemCount: _favoriteFoods.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(_favoriteFoods[index]),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}