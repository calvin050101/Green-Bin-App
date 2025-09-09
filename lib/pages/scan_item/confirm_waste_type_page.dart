import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:green_bin/helper/waste_type_functions.dart';
import 'package:green_bin/models/waste_type_model.dart';
import 'package:green_bin/pages/scan_item/complete_scan_page.dart';
import 'package:green_bin/providers/waste_type_provider.dart';
import 'package:green_bin/widgets/custom_button.dart';

import '../../widgets/back_button.dart';
import '../../widgets/card/waste_type_option_card.dart';

class ConfirmWasteTypePage extends ConsumerStatefulWidget {
  static String routeName = "/confirm-waste-type";

  const ConfirmWasteTypePage({super.key});

  @override
  ConsumerState<ConfirmWasteTypePage> createState() =>
      _ConfirmWasteTypePageState();
}

class _ConfirmWasteTypePageState extends ConsumerState<ConfirmWasteTypePage> {
  WasteTypeModel? _selectedWasteType;
  String predictedWasteType = "Paper";
  double predictedConfidence = 0.9;

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
                  predictedWasteType,
                  predictedConfidence,
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

                if (wasteTypes.isEmpty)
                  const Center(child: Text("No waste types found")),

                ...wasteTypes.map(
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
                ),
                const SizedBox(height: 30),

                CustomButton(
                  buttonText: "Confirm",
                  onPressed: () {
                    if (_selectedWasteType == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Please select a waste type"),
                        ),
                      );
                      return;
                    }
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder:
                            (context) => CompleteScanPage(
                              confirmedWasteType: _selectedWasteType!,
                            ),
                      ),
                    );
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

  Container wasteImageContainer(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.7,
      height: MediaQuery.of(context).size.width * 0.5,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.grey[300]!, width: 2),
        image: const DecorationImage(
          image: AssetImage('lib/assets/images/cardboard-box.jpg'),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Container predictedWasteTypeContainer(
    String predictedWasteType,
    double predictedConfidence,
  ) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF4CAF50),
        borderRadius: BorderRadius.circular(10),
      ),
      child: const Column(
        children: [
          Text(
            'Predicted Waste Type:',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
              fontFamily: 'OpenSans',
            ),
          ),
          SizedBox(width: 10),

          Text(
            'Paper - 90%',
            style: TextStyle(
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
}
