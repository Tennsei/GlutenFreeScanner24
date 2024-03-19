import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
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
  final SearchController _searchController = SearchController();

  Future<void> searchProduct(String query) async {
    final url = 'https://world.openfoodfacts.org/cgi/search.pl?search_terms=$query&search_simple=1&action=process&json=1';
    final response = await http.get(Uri.parse(url));
    
    if (response.statusCode == 200) {
      final data = response.body;
      final products = _parseProducts(data);
      
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
                      showDialog(
                        context: context,
                        builder: (context) {
                          return FutureBuilder<Map<String, dynamic>>(
                            future: getProductDetails(product['url']),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState == ConnectionState.waiting) {
                                return const CircularProgressIndicator();
                              } else if (snapshot.hasError) {
                                return const AlertDialog(
                                  title: Text('Error'),
                                  content: Text('An error occurred while fetching product details.'),
                                );
                              } else {
                                final details = snapshot.data!;

                                return AlertDialog(
                                  title: Text(product['product_name'] ?? 'Unknown'),
                                  content: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      if (details['image_url'] != null)
                                        Image.network(details['image_url']),
                                      if (details['ingredients_text'] != null)
                                        Text('Ingredients: ${details['ingredients_text']}'),
                                      if (details['nutriments'] != null)
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            const Text('Nutritional Value:'),
                                            if (details['nutriments']['energy_value'] != null)
                                              Text('Energy: ${details['nutriments']['energy_value']}'),
                                            if (details['nutriments']['fat_value'] != null)
                                              Text('Fat: ${details['nutriments']['fat_value']}'),
                                            if (details['nutriments']['carbohydrates_value'] != null)
                                              Text('Carbohydrates: ${details['nutriments']['carbohydrates_value']}'),
                                            if (details['nutriments']['proteins_value'] != null)
                                              Text('Proteins: ${details['nutriments']['proteins_value']}'),
                                          ],
                                        ),
                                    ],
                                  ),
                                );
                              }
                            },
                          );
                        },
                      );
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
    } else {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('API Request Error'),
            content: Text('An error occurred while fetching search results: ${response.statusCode}.'),
          );
        },
      );
    }
  }

  List<Map<String, dynamic>> _parseProducts(String data) {
    final List<Map<String, dynamic>> products = [];
    final json = parser.parse(data);
    
    
    
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
      throw Exception('An error occurred while fetching product details: ${response.statusCode}.');
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
                onPressed: () {
                  searchProduct(_searchController.text);
                },
                child: const Text('Search'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SearchController extends TextEditingController {
  @override
  TextSpan buildTextSpan({required BuildContext context, TextStyle? style, required bool withComposing}) {
    final textSpan = super.buildTextSpan(context: context, style: style, withComposing: withComposing);
    return TextSpan(style: style, children: <TextSpan>[textSpan]);
  }
}