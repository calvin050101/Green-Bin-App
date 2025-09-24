import 'dart:io';

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

    try {
      final result = await _classifyImage(_image!);
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

  Future<Map<String, dynamic>> _classifyImage(File image) async {
    try {
      return await TFLiteHelper.runInference(image);
    } catch (e) {
      throw Exception("Classification failed: $e");
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
      body: Padding(
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
            const SizedBox(height: 20),

            // Prediction or loading state
            if (_isLoading)
              const Center(child: CircularProgressIndicator())
            else if (_predictedLabel.isNotEmpty)
              Center(
                child: Text(
                  "Prediction: $_predictedLabel "
                      "(${(_confidence * 100).toStringAsFixed(2)}%)",
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),

            const SizedBox(height: 50),

            CustomButton(
              buttonText: "Process Image",
              onPressed: () {
                if (_image == null || _isLoading) return;
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ConfirmWasteTypePage(
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
      floatingActionButton: FloatingActionButton(
        onPressed: _pickImage,
        child: const Icon(Icons.add_a_photo),
      ),
    );
  }

  Container uploadImageContainer(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.8,
      height: MediaQuery.of(context).size.width * 0.6,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[300]!, width: 2),
      ),
      child: _image != null
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
    );
  }
}
