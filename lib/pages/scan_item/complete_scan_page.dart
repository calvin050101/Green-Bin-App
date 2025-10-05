import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:green_bin/models/waste_type_model.dart';
import 'package:green_bin/widgets/custom_button.dart';
import 'package:green_bin/widgets/form/error_message_text.dart';

import '../../services/waste_records_service.dart';

class CompleteScanPage extends ConsumerStatefulWidget {
  static String routeName = "/complete-scan";
  final WasteTypeModel confirmedWasteType;
  final double weight;
  final File image;

  const CompleteScanPage({
    super.key,
    required this.confirmedWasteType,
    required this.weight,
    required this.image,
  });

  @override
  ConsumerState<CompleteScanPage> createState() => _CompleteScanPageState();
}

class _CompleteScanPageState extends ConsumerState<CompleteScanPage> {
  bool _recordAdded = false;
  String? _errorMessage;
  late WasteTypeModel _confirmedWasteType;
  late double _weight;
  late File _image;

  @override
  void initState() {
    super.initState();
    _confirmedWasteType = widget.confirmedWasteType;
    _weight = widget.weight;
    _image = widget.image;
    _addRecordToUserHistory();
  }

  Future<void> _addRecordToUserHistory() async {
    try {
      final wasteRecordsService = ref.read(wasteRecordsServiceProvider);
      await wasteRecordsService.addWasteRecord(
        wasteType: _confirmedWasteType,
        weight: _weight,
      );
      setState(() {
        _recordAdded = true;
      });
    } catch (e) {
      setState(() {
        _errorMessage = "Failed to add record: ${e.toString()}";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final totalPoints = (_confirmedWasteType.pointsPerKg * _weight).ceil();
    final totalCarbon = _confirmedWasteType.carbonPerKg * _weight;

    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.transparent),

      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                _recordAdded
                    ? Icons.check_circle_outline
                    : Icons.pending_outlined,
                color: _recordAdded ? Colors.green : Colors.orange,
                size: 100,
              ),
              const SizedBox(height: 20),

              _wasteImageContainer(context),

              const SizedBox(height: 30),

              if (_errorMessage != null)
                ErrorMessageText(errorMessage: _errorMessage)
              else if (!_recordAdded)
                const CircularProgressIndicator()
              else
                Text(
                  'Thank you for recycling!',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.lightGreen[900],
                  ),
                  textAlign: TextAlign.center,
                ),

              const SizedBox(height: 20),

              _buildInfoRow('Waste Type:', _confirmedWasteType.label),
              _buildInfoRow('Points:', '$totalPoints points'),
              _buildInfoRow(
                'Carbon Footprint Saved:',
                '${totalCarbon.toStringAsFixed(2)} kg CO₂',
              ),

              const SizedBox(height: 40),

              CustomButton(
                buttonText: 'OK',
                onPressed: () {
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    '/',
                    (Route<dynamic> route) => false,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Container _wasteImageContainer(BuildContext context) => Container(
    width: MediaQuery.of(context).size.width * 0.7,
    height: MediaQuery.of(context).size.width * 0.5,
    decoration: BoxDecoration(
      color: Colors.grey[200],
      borderRadius: BorderRadius.circular(15),
      border: Border.all(color: Colors.grey[400]!),
      image: DecorationImage(image: FileImage(_image), fit: BoxFit.cover),
    ),
  );

  Widget _buildInfoRow(String label, String value) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 5.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 16,
            fontFamily: 'OpenSans',
            color: Colors.grey[700],
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(width: 10),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontFamily: 'OpenSans',
            color: Colors.black87,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    ),
  );
}
