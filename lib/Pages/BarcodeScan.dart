import 'dart:typed_data';
import 'package:get/get.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:flutter/material.dart';
import 'package:openfoodfacts/openfoodfacts.dart';

import 'package:test1/Pages/OpenFoodFactsAPi.dart';

class ScanCode extends StatefulWidget {
  const ScanCode({super.key});

  @override
  State<ScanCode> createState() => _ScanCodeState();
}

class _ScanCodeState extends State<ScanCode> {
  @override
  Widget build(BuildContext context) {
    MobileScannerController cameraController = MobileScannerController();
    OpenFoodAPIConfiguration.userAgent = UserAgent(name: 'GF Scanner');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Scanner'),
        actions: [
          IconButton(
            color: Colors.white,
            icon: ValueListenableBuilder(
              valueListenable: cameraController.torchState,
              builder: (context, state, child) {
                switch (state as TorchState) {
                  case TorchState.off:
                    return const Icon(Icons.flash_off, color: Colors.grey);
                  case TorchState.on:
                    return const Icon(Icons.flash_on, color: Colors.yellow);
                }
              },
            ),
            iconSize: 32.0,
            onPressed: () => cameraController.toggleTorch(),
          ),
          IconButton(
            color: Colors.white,
            icon: ValueListenableBuilder(
              valueListenable: cameraController.cameraFacingState,
              builder: (context, state, child) {
                switch (state as CameraFacing) {
                  case CameraFacing.front:
                    return const Icon(Icons.camera_front);
                  case CameraFacing.back:
                    return const Icon(Icons.camera_rear);
                }
              },
            ),
            iconSize: 32.0,
            onPressed: () => cameraController.switchCamera(),
          ),
        ],
      ),
      body: MobileScanner(
        controller: MobileScannerController(
          detectionSpeed: DetectionSpeed.noDuplicates,
          facing: CameraFacing.back,
          torchEnabled: false,
        ),
        onDetect: (capture) async {
          final List<Barcode> barcodes = capture.barcodes;
          final Uint8List? image = capture.image;

          for (final barcode in barcodes) {
            final String? barcodeValue = barcode.rawValue;
            if (barcodeValue != null) {
              print('Barcode value: $barcodeValue');

              final ProductQueryConfiguration configuration =
                  ProductQueryConfiguration(
                barcodeValue,
                version: ProductQueryVersion.v3,
                language: OpenFoodFactsLanguage.ENGLISH,

              );

              try {
                final ProductResultV3 result =
                    await OpenFoodAPIClient.getProductV3(configuration);

                print('API response status: ${result.status}');
                print('API response product: ${result.product}');
                print('API response error: ${result.errors}');
                print('API response error message: ${result.errors}');

                if (result.status == 1 && result.product != null) {
                  final product = result.product!;
                  final productName =
                      product.getBestProductName(OpenFoodFactsLanguage.ENGLISH);
                  // final energy = product.nutriments?.getEnergyValue();
                  // final fat = product.nutriments?.getFat100g();
                  // final carbohydrates =
                  //     product.nutriments?.getCarbohydrates100g();
                  // final proteins = product.nutriments?.getProteins100g();

                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text(productName ?? 'Product'),
                        content: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // if (energy != null) Text('Energy: $energy kJ'),
                            // if (fat != null) Text('Fat: $fat g'),
                            // if (carbohydrates != null)
                            //   Text('Carbohydrates: $carbohydrates g'),
                            // if (proteins != null) Text('Proteins: $proteins g'),
                            if (image != null) Image(image: MemoryImage(image)),
                          ],
                        ),
                      );
                    },
                  );

                  Future.delayed(const Duration(seconds: 5), () {
                    Navigator.pop(context);
                  });
                } else {
                  // Fallback logic
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
                print('API request error: $e');
                // Fallback logic
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
