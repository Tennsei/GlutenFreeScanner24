import 'dart:convert';
import 'dart:math';
import 'package:test1/Pages/OpenFoodFactsAPi.dart';
import 'package:http/http.dart' as http;
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:openfoodfacts/openfoodfacts.dart';

Future<http.Response> getImageData(String barcode) {
  final url = 'https://images.openfoodfacts.org/images/products/$barcode';
  return http.get(Uri.parse(url));
}

class Data {
  final String searchQuery = "https://world.openfoodfacts.org/api/v2/search?";
  final String searchQueryByBarcode =
      "https://world.openfoodfacts.org/api/v2/product/";

  final String nameQuery = "product_name=";
  Future<List<dynamic>> getSearchQueryByName(String query) async {
    http.Response response =
        await http.get(Uri.parse(searchQuery + nameQuery + query));
    Map<String, dynamic> data = json.decode(response.body);
    return data['products'];
  }

  final String codeQuery = "code=";
  Future<Map<String, dynamic>> getSearchQueryByCode(int barcode) async {
    http.Response response =
        await http.get(Uri.parse(searchQuery + codeQuery + barcode.toString()));
    Map<String, dynamic> data = json.decode(response.body);
    return data;
  }

  Future<Map<String, dynamic>> getSearchQueryByBarcode(String barcode) async {
    http.Response response =
        await http.get(Uri.parse(searchQueryByBarcode + barcode.toString()));
    Map<String, dynamic> data = json.decode(response.body);
    return data;
  }

  // searching for a product by name using the OpenFoodFacts API
  Future<List<Product>> getSearchQueryByNameOpenFoodFacts(String name) async {
    ProductSearchQueryConfiguration configuration =
        ProductSearchQueryConfiguration(parametersList: <Parameter>[
      SearchTerms(terms: List<String>.filled(1, name)),
      const SortBy(option: SortOption.POPULARITY)
    ], version: ProductQueryVersion.v3);

    SearchResult result = await OpenFoodAPIClient.searchProducts(
        null, configuration,
        uriHelper: uriHelperFoodProd);
    List<Product>? results = result.products;

    // returning the top 20 product results
    List<Product> top20 = results!.sublist(0, 20);
    for (int i = 0; i < 20; i++) {
      top20[i] = results[i];
    }
    return top20;
  }

  // searching for a product by barcode using the OpenFoodFacts API
  Future<Product> getSearchQueryByBarcodeOpenFoodFacts(String barcode) async {
    ProductSearchQueryConfiguration configuration =
        ProductSearchQueryConfiguration(
            parametersList: [BarcodeParameter(barcode)],
            version: ProductQueryVersion.v3);
    SearchResult result = await OpenFoodAPIClient.searchProducts(
        null, configuration,
        uriHelper: uriHelperFoodProd);

    return result.products![0];
  }

  // getting nutriscore on a scale of 1-100
  static int getNutriscore(String nutriscore) {
    switch (nutriscore) {
      case 'a':
        return 85 + Random().nextInt(14);
      case 'b':
        return 65 + Random().nextInt(18);
      case 'c':
        return 45 + Random().nextInt(18);
      case 'd':
        return 20 + Random().nextInt(18);
      case 'e':
        return 2 + Random().nextInt(18);
      default:
        return 0;
    }
  }
}

