import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:openfoodfacts/openfoodfacts.dart';

class ScanCode extends StatefulWidget {
  const ScanCode({Key? key});

  @override
  State<ScanCode> createState() => _ScanCodeState();
}

class _ScanCodeState extends State<ScanCode> {
  MobileScannerController cameraController = MobileScannerController();
  bool isFlashlightOn = false;

  @override
  void dispose() {
    cameraController.dispose();
    super.dispose();
  }

  Future<void> toggleFlashlight() async {
    // final TorchState torchState = await cameraController.toggleTorch();
    // setState(() {
    //   isFlashlightOn = torchState == TorchState.on;
    // });
  }

  Future<void> switchCamera() async {
    await cameraController.switchCamera();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scanner'),
        actions: [
          IconButton(
            icon: Icon(
              isFlashlightOn ? Icons.flash_on : Icons.flash_off,
              color: Colors.white,
            ),
            onPressed: toggleFlashlight,
          ),
          IconButton(
            icon: Icon(
              Icons.switch_camera,
              color: Colors.white,
            ),
            onPressed: switchCamera,
          ),
        ],
      ),
      body: MobileScanner(
        controller: cameraController,
        onDetect: (capture) async {
          final List<Barcode> barcodes = capture.barcodes;
          final Uint8List? image = capture.image;

          for (final barcode in barcodes) {
            final String? barcodeValue = barcode.rawValue;
            if (barcodeValue != null) {
              print('Barcode value: $barcodeValue');

              try {
                final ProductQueryConfiguration config = ProductQueryConfiguration(barcodeValue, version: ProductQueryVersion.v3);
                final ProductResultV3 result = await OpenFoodAPIClient.getProductV3(config);

                if (result.status == 1 && result.product != null) {
                  final product = result.product!;
                  final productName = product.productName;
                  final ingredientsText = product.ingredientsText;
                  final nutriments = product.nutriments;

                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text(productName ?? 'Product'),
                        content: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (ingredientsText != null)
                              Text('Ingredients: $ingredientsText'),
                            if (nutriments != null)
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                // children: [
                                //   Text('Nutritional Value:'),
                                //   if (nutriments.energy_100g != null)
                                //     Text('Energy: ${nutriments.energy_100g}'),
                                //   if (nutriments.fat_100g != null)
                                //     Text('Fat: ${nutriments.fat_100g}'),
                                //   if (nutriments.carbohydrates_100g != null)
                                //     Text(
                                //         'Carbohydrates: ${nutriments.carbohydrates_100g}'),
                                //   if (nutriments.proteins_100g != null)
                                //     Text('Proteins: ${nutriments.proteins_100g}'),
                                // ],
                              ),
                            if (image != null)
                              Image(image: MemoryImage(image)),
                          ],
                        ),
                      );
                    },
                  );

                  Future.delayed(const Duration(seconds: 5), () {
                    Navigator.pop(context);
                  });
                } else {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text('Product not found'),
                        content: Text(
                            'No product information found for barcode: $barcodeValue. Please try a different barcode or search for the product manually.'),
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
                      content: Text(
                          'An error occurred while fetching product information: $e. Please try again later or search for the product manually.'),
                    );
                  },
                );
              }
            }
          }
        },
      ),
    );
  }
}