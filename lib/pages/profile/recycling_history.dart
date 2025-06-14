import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:green_bin/helper/helper_functions.dart';

import '../../models/record_model.dart';
import '../../providers/user_provider.dart';
import '../../widgets/back_button.dart';

import 'package:intl/intl.dart';

class RecyclingHistoryPage extends ConsumerWidget {
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

                records.isEmpty
                    ? Center(child: Text('No recycling records found yet.'))
                    : ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: records.length,
                      itemBuilder:
                          (context, index) => recordCard(records[index]),
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

  Card recordCard(RecordModel record) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      color: Colors.white,
      borderOnForeground: true,
      child: ListTile(
        leading: Icon(
          getWasteTypeIcon(record.wasteType),
          color: Colors.green,
          size: 30,
        ),
        title: Text(
          record.wasteType,
          style: const TextStyle(
            fontFamily: 'OpenSans',
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Text(
          DateFormat('yyyy-MM-dd hh:mm a').format(record.timestamp.toLocal()),
          style: const TextStyle(fontFamily: 'OpenSans', fontSize: 12),
        ),
      ),
    );
  }
}
