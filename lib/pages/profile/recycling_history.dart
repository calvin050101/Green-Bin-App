import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:green_bin/helper/list_view_functions.dart';

import '../../providers/waste_records_provider.dart';
import '../../widgets/back_button.dart';
import '../../widgets/card/recycling_record_card.dart';

class RecyclingHistoryPage extends ConsumerWidget {
  static String routeName = "/recycling-history";

  const RecyclingHistoryPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userId = FirebaseAuth.instance.currentUser?.uid;

    if (userId == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Recycling History')),
        body: const Center(child: Text('Please log in to view records.')),
      );
    }

    // Watch the stream provider for records
    final recordsAsyncValue = ref.watch(userRecordsStreamProvider(userId));

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leadingWidth: 70,
        leading: CustBackButton(),
      ),

      body: recordsAsyncValue.when(
        data: (records) {
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Text(
                    'Recycling History',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 32,
                      fontFamily: 'Poppins',
                    ),
                  ),
                ),

                listVerticalItems(
                  records,
                  (context, record) => RecyclingRecordCard(record: record),
                  'No recycling records found yet.',
                ),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
      ),
    );
  }
}
