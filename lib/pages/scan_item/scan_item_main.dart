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
      source: ImageSource.gallery,
    );
    if (pickedFile == null) return;

    setState(() {
      _image = File(pickedFile.path);
      _isLoading = true;
    });

    await Future.delayed(Duration.zero);

    try {
      // Run CPU-heavy preprocessing in background isolate
      final input = await compute(
        TFLiteHelper.preprocessImageFromPath,
        _image!.path,
      );

      // Run inference on main isolate (interpreter only works here)
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
                Center(child: uploadImageContainer(context)),
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

          // Loading overlay
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

  InkWell uploadImageContainer(BuildContext context) {
    return InkWell(
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
                : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.image, size: 80, color: Colors.grey[600]),
                    const SizedBox(height: 10),
                    Text(
                      'Upload Image',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.grey[700],
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Montserrat',
                      ),
                    ),
                  ],
                ),
      ),
    );
  }
}
