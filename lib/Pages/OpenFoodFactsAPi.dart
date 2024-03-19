import 'dart:async';

import 'package:openfoodfacts/openfoodfacts.dart';
import 'package:test1/Pages/BarcodeScan.dart';

/// request a product from the OpenFoodFacts database
Future<Product?> getProduct() async {
  var barcode = '';
  ProductQueryConfiguration config = ProductQueryConfiguration(
    '',
    version: ProductQueryVersion.v3,
  );
  ProductResultV3 product = await OpenFoodAPIClient.getProductV3(config);
  print(product.product?.productName); // Coca Cola Zero
  print(product.product?.brands); // Coca-Cola
  print(product.product?.quantity); // 330ml
  print(product.product?.nutriments?.getValue(Nutrient.salt, PerSize.oneHundredGrams)); // 0.0212
  print(product.product?.additives?.names); // [E150d, E338, E950, E951]
  print(product.product?.allergens?.names); // []

  final ProductQueryConfiguration configuration = ProductQueryConfiguration(
    barcode,
    language: OpenFoodFactsLanguage.ENGLISH,
    fields: [ProductField.ALL],
    version: ProductQueryVersion.v3,
  );
  final ProductResultV3 result =
      await OpenFoodAPIClient.getProductV3(configuration);

  if (result.status == ProductResultV3.statusSuccess) {
    return result.product;
  } else {
    throw Exception('product not found, please insert data for $barcode');
  }
}
