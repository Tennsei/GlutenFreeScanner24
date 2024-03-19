import 'dart:typed_data';
import 'package:get/get.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:flutter/material.dart';
import 'package:openfoodfacts/openfoodfacts.dart';

class ScanCode extends StatefulWidget {
  const ScanCode({super.key});

  @override
  State<ScanCode> createState() => _ScanCodeState();
}

class _ScanCodeState extends State<ScanCode> {
  @override
  Widget build(BuildContext context) {
    MobileScannerController cameraController = MobileScannerController();

    OpenFoodAPIConfiguration.userAgent = UserAgent(name: 'Gluten Free Scanner');
    OpenFoodAPIConfiguration.globalLanguages = <OpenFoodFactsLanguage>[
      OpenFoodFactsLanguage.ENGLISH
    ];
    OpenFoodAPIConfiguration.globalCountry = OpenFoodFactsCountry.USA;

    

    return Scaffold(
        appBar: AppBar(
          title: const Text('Scanner'),
          actions: [
            IconButton(
              color: Colors.white,
              icon: ValueListenableBuilder(
                valueListenable: cameraController.torchState,
                builder: (context, state, child) {
                  switch (state) {
                    case TorchState.off:
                      return const Icon(Icons.flashlight_off,
                          color: Colors.grey);
                    case TorchState.on:
                      return const Icon(Icons.flashlight_on,
                          color: Colors.yellow);
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
                  switch (state) {
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
            facing: CameraFacing.front,
            torchEnabled: false,
          ),
          onDetect: (capture) async {
            final List<Barcode> barcodes = capture.barcodes;
            final Uint8List? image = capture.image;
            
            for (final barcode in barcodes) {
              debugPrint('Barcode found! ${barcode.rawValue}');
            }

            if (image != null) {
              showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                        title: Text(
                          
                        ),
                        content: Image(
                          image: MemoryImage(image),
                        ));
                  });
              Future.delayed(const Duration(seconds: 15), () {
                Navigator.pop(context);
              });
            }
          },
        ));
  }
}
