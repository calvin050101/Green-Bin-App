import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:green_bin/helper/waste_type_functions.dart';
import 'package:green_bin/models/waste_type_model.dart';
import 'package:green_bin/pages/scan_item/complete_scan_page.dart';
import 'package:green_bin/services/waste_type_service.dart';
import 'package:green_bin/widgets/custom_button.dart';

import '../../widgets/back_button.dart';
import '../../widgets/card/waste_type_option_card.dart';
import '../../widgets/form/cust_form_field.dart';

class ConfirmWasteTypePage extends ConsumerStatefulWidget {
  static String routeName = "/confirm-waste-type";

  final File image;
  final String predictedLabel;
  final double confidence;

  const ConfirmWasteTypePage({
    super.key,
    required this.image,
    required this.predictedLabel,
    required this.confidence,
  });

  @override
  ConsumerState<ConfirmWasteTypePage> createState() =>
      _ConfirmWasteTypePageState();
}

class _ConfirmWasteTypePageState extends ConsumerState<ConfirmWasteTypePage> {
  WasteTypeModel? _selectedWasteType;
  final TextEditingController _weightController = TextEditingController();

  @override
  void dispose() {
    _selectedWasteType = null;
    _weightController.dispose();
    super.dispose();
  }

  void autoSelectWasteType(List<WasteTypeModel> wasteTypes) {
    if (_selectedWasteType != null) {
      return;
    }

    final match = wasteTypes.firstWhere(
      (w) => w.label.toLowerCase() == widget.predictedLabel.toLowerCase(),
      orElse:
          () =>
              WasteTypeModel(id: "", label: "", pointsPerKg: 0, carbonPerKg: 0),
    );

    if (match.id.isEmpty) return;

    // only update state once to avoid rebuild loops
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        setState(() {
          _selectedWasteType = match;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "Predicted waste type auto-selected: ${match.label}",
              style: TextStyle(color: Colors.white, fontFamily: "OpenSans"),
            ),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final asyncWasteTypes = ref.watch(wasteTypesStreamProvider);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leadingWidth: 70,
        leading: CustBackButton(),
      ),
      body: asyncWasteTypes.when(
        data: (wasteTypes) {
          autoSelectWasteType(wasteTypes);

          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Confirm Waste Type',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 32,
                    fontFamily: 'Poppins',
                  ),
                ),
                const SizedBox(height: 40),

                Center(child: wasteImageContainer(context)),
                const SizedBox(height: 20),

                predictedWasteTypeContainer(
                  widget.predictedLabel,
                  widget.confidence,
                ),
                const SizedBox(height: 30),

                const Text(
                  'Or select the correct waste type below',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                    fontFamily: 'OpenSans',
                  ),
                ),
                const SizedBox(height: 15),

                // Waste Type Option Cards
                if (wasteTypes.isEmpty)
                  const Center(child: Text("No waste types found")),

                wasteTypeOptionsTile(wasteTypes),
                const SizedBox(height: 30),

                // Weight Input Field
                CustFormField(
                  controller: _weightController,
                  keyboardType: TextInputType.number,
                  hintText: 'Enter Weight (kg)',
                ),
                const SizedBox(height: 30),

                CustomButton(
                  buttonText: "Confirm",
                  onPressed: () {
                    uploadRecyclingActivity(context);
                  },
                ),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text("Error: $err")),
      ),
    );
  }

  void uploadRecyclingActivity(BuildContext context) {
    if (_selectedWasteType == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Please select a waste type",
            style: TextStyle(
              fontSize: 16,
              color: Colors.black,
              fontFamily: 'OpenSans',
            ),
          ),
          backgroundColor: Colors.green,
        ),
      );
      return;
    }

    // Validate weight
    final weight = double.tryParse(_weightController.text);
    if (weight == null || weight <= 0 || weight > 10) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Please enter a valid weight (0–10kg)",
            style: TextStyle(
              fontSize: 16,
              color: Colors.black,
              fontFamily: 'OpenSans',
            ),
          ),
          backgroundColor: Colors.green,
        ),
      );
      return;
    }

    // Continue to CompleteScanPage
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder:
            (context) => CompleteScanPage(
              confirmedWasteType: _selectedWasteType!,
              image: widget.image,
              weight: weight,
            ),
      ),
    );
  }

  ExpansionTile wasteTypeOptionsTile(List<WasteTypeModel> wasteTypes) =>
      ExpansionTile(
        title: const Text(
          "Select Waste Type",
          style: TextStyle(
            fontSize: 16,
            color: Colors.black,
            fontFamily: 'OpenSans',
          ),
        ),
        children:
            wasteTypes
                .map(
                  (waste) => WasteTypeOptionCard(
                    wasteType: waste,
                    icon: getWasteTypeIcon(waste.label),
                    isSelected: _selectedWasteType?.id == waste.id,
                    onTap: () {
                      setState(() {
                        _selectedWasteType = waste;
                      });
                    },
                  ),
                )
                .toList(),
      );

  /// Show scanned image
  Container wasteImageContainer(BuildContext context) => Container(
    width: MediaQuery.of(context).size.width * 0.7,
    height: MediaQuery.of(context).size.width * 0.5,
    decoration: BoxDecoration(
      color: Colors.grey[200],
      borderRadius: BorderRadius.circular(15),
      border: Border.all(color: Colors.grey[300]!, width: 2),
      image: DecorationImage(image: FileImage(widget.image), fit: BoxFit.cover),
    ),
  );

  /// Show predicted label + confidence
  Container predictedWasteTypeContainer(
    String predictedWasteType,
    double predictedConfidence,
  ) => Container(
    width: double.infinity,
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: const Color(0xFF4CAF50),
      borderRadius: BorderRadius.circular(10),
    ),
    child: Column(
      children: [
        const Text(
          'Predicted Waste Type:',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
            fontFamily: 'OpenSans',
          ),
        ),
        const SizedBox(height: 10),
        Text(
          '$predictedWasteType - ${(predictedConfidence * 100).toStringAsFixed(2)}%',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
            fontFamily: 'OpenSans',
          ),
        ),
      ],
    ),
  );
}
