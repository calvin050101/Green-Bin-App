import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:green_bin/pages/scan_item/confirm_waste_type_page.dart';
import 'package:image_picker/image_picker.dart';

import '../../helper/tflite_helper.dart';
import '../../widgets/back_button.dart';
import '../../widgets/custom_button.dart';

class ScanItemMainPage extends StatefulWidget {
  static String routeName = "/scan-item";

  const ScanItemMainPage({super.key});

  @override
  State<ScanItemMainPage> createState() => _ScanItemMainPageState();
}

class _ScanItemMainPageState extends State<ScanItemMainPage> {
  File? _image;
  String _predictedLabel = '';
  double _confidence = 0.0;
  bool _isLoading = false;

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.camera,
    );
    if (pickedFile == null) return;

    setState(() {
      _image = File(pickedFile.path);
      _isLoading = true;
    });

    await Future.delayed(Duration.zero);

    try {
      final input = await compute(
        TFLiteHelper.preprocessImageFromPath,
        _image!.path,
      );

      final result = await TFLiteHelper.runInferenceFromInput(input);

      setState(() {
        _predictedLabel = result["label"];
        _confidence = result["confidence"];
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _predictedLabel = "Error: $e";
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leadingWidth: 70,
        leading: CustBackButton(),
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Scan Item',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 32,
                    fontFamily: 'Poppins',
                  ),
                ),
                const SizedBox(height: 40),

                Center(child: captureImageContainer(context)),
                const SizedBox(height: 50),

                CustomButton(
                  buttonText: "Confirm Image",
                  onPressed: () {
                    if (_image == null || _isLoading) return;
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (_) => ConfirmWasteTypePage(
                              image: _image!,
                              predictedLabel: _predictedLabel,
                              confidence: _confidence,
                            ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),

          if (_isLoading)
            Container(
              color: Colors.black.withValues(alpha: 0.4),
              child: const Center(
                child: CircularProgressIndicator(color: Colors.white),
              ),
            ),
        ],
      ),
    );
  }

  InkWell captureImageContainer(BuildContext context) => InkWell(
    onTap: _pickImage,
    child: Container(
      width: MediaQuery.of(context).size.width * 0.8,
      height: MediaQuery.of(context).size.width * 0.6,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[300]!, width: 2),
      ),
      child:
          _image != null
              ? Image.file(_image!, fit: BoxFit.cover)
              : defaultImageContainer(),
    ),
  );

  Column defaultImageContainer() => Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Icon(Icons.camera_alt, size: 80, color: Colors.grey[600]),
      const SizedBox(height: 10),
      const Text(
        'Tap to open camera\nand capture the item clearly',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 18,
          color: Colors.black87,
          fontWeight: FontWeight.w500,
          fontFamily: 'Montserrat',
        ),
      ),
    ],
  );
}
