import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as parser;

void main() => runApp(const FoodSearch());

class FoodSearch extends StatefulWidget {
  const FoodSearch({Key? key});

  @override
  _FoodSearchState createState() => _FoodSearchState();
}

class _FoodSearchState extends State<FoodSearch> {
  bool isDark = false;
  final TextEditingController _searchController = TextEditingController();

  Future<List<Map<String, dynamic>>> searchProducts(String query) async {
    final url = 'https://world.openfoodfacts.org/cgi/search.pl?search_terms=$query&search_simple=1&action=process&json=1';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final products = _parseProducts(data);
      return products;
    } else {
      throw Exception('Failed to fetch search results: ${response.statusCode}');
    }
  }

  List<Map<String, dynamic>> _parseProducts(dynamic data) {
    final List<Map<String, dynamic>> products = [];
    final productsData = data['products'];

    for (final productData in productsData) {
      products.add({
        'product_name': productData['product_name'],
        'brands': productData['brands'],
        'url': 'https://world.openfoodfacts.org/product/${productData['id']}',
      });
    }

    return products;
  }

  Future<Map<String, dynamic>> getProductDetails(String url) async {
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final document = parser.parse(response.body);
      final imageElement = document.querySelector('.product-summary .js-image-zone img');
      final ingredientsElement = document.querySelector('.product-summary .js-ingredients-list');
      final nutrimentsElement = document.querySelector('.product-summary .js-nutriments');

      final imageUrl = imageElement?.attributes['src'];
      final ingredients = ingredientsElement?.text;
      final nutriments = nutrimentsElement?.text;

      return {
        'image_url': imageUrl,
        'ingredients_text': ingredients,
        'nutriments': nutriments,
      };
    } else {
      throw Exception('Failed to fetch product details: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: isDark ? Brightness.dark : Brightness.light,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('OpenFoodFacts Search'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextField(
                  controller: _searchController,
                  decoration: const InputDecoration(
                    labelText: 'Search for a product',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () async {
                  try {
                    final products = await searchProducts(_searchController.text);
                    if (products.isNotEmpty) {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: const Text('Search Results'),
                            content: ListView.builder(
                              itemCount: products.length,
                              itemBuilder: (context, index) {
                                final product = products[index];
                                return ListTile(
                                  title: Text(product['product_name'] ?? 'Unknown'),
                                  subtitle: Text(product['brands'] ?? 'Unknown'),
                                  onTap: () {
                                    showProductDetails(product['url']);
                                  },
                                );
                              },
                            ),
                          );
                        },
                      );
                    } else {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return const AlertDialog(
                            title: Text('No Results'),
                            content: Text('No products found for the given search query.'),
                          );
                        },
                      );
                    }
                  } catch (e) {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: const Text('API Request Error'),
                          content: Text('An error occurred while fetching search results: $e'),
                        );
                      },
                    );
                  }
                },
                child: const Text('Search'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void showProductDetails(String url) async {
    try {
      final details = await getProductDetails(url);
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(details['product_name'] ?? 'Unknown'),
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (details['image_url'] != null)
                  Image.network(details['image_url']),
                if (details['ingredients_text'] != null)
                  Text('Ingredients: ${details['ingredients_text']}'),
                if (details['nutriments'] != null)
                  Text('Nutritional Value: ${details['nutriments']}'),
              ],
            ),
          );
        },
      );
    } catch (e) {
      showDialog(
        context: context,
        builder: (context) {
          return const AlertDialog(
            title: Text('Error'),
            content: Text('An error occurred while fetching product details.'),
          );
        },
      );
    }
  }
}