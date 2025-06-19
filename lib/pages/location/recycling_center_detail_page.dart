import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:green_bin/providers/recycling_center_provider.dart';
import 'package:green_bin/helper/location_functions.dart';
import 'package:green_bin/widgets/loading_error.dart';
import '../../models/recycling_center.dart';
import '../../widgets/back_button.dart';

class RecyclingCenterDetailPage extends ConsumerWidget {
  static String routeName = "/recycling-center-detail";

  const RecyclingCenterDetailPage({super.key});

  Widget _buildDetailRow(BuildContext context, String title, String? value) {
    if (value == null || value.isEmpty || value == 'N/A') {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.grey[700],
              fontFamily: 'OpenSans',
            ),
          ),

          const SizedBox(height: 4),

          Text(
            value,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: Colors.black87,
              fontFamily: 'OpenSans',
            ),
          ),

          const Divider(height: 16, thickness: 0.5),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    RecyclingCenter center =
        ModalRoute.of(context)!.settings.arguments as RecyclingCenter;
    final centerDetails = ref.watch(recyclingCenterDetailsProvider(center.id));

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leadingWidth: 70,
        leading: CustBackButton(),
      ),

      body: centerDetails.when(
        data: (centerDetail) {
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Center Image/Photo
                  if (center.photoUrl != null)
                    Container(
                      height: 200,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: NetworkImage(center.photoUrl!),
                          fit: BoxFit.cover,
                        ),
                      ),
                    )
                  else
                    Container(
                      height: 200,
                      width: double.infinity,
                      color: Colors.grey[200],
                      child: const Icon(
                        Icons.recycling,
                        color: Colors.grey,
                        size: 80,
                      ),
                    ),

                  const SizedBox(height: 16),

                  Text(
                    center.name,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    formatDistance(center.distance),
                    style: Theme.of(
                      context,
                    ).textTheme.titleMedium?.copyWith(color: Colors.grey[700]),
                  ),

                  const SizedBox(height: 16),

                  _googleMapsButton(center),

                  const SizedBox(height: 24),

                  // Details Section
                  _buildDetailRow(context, 'Address', center.address),

                  if (centerDetail?.openingHours!.weekdayText != null)
                    _buildDetailRow(
                      context,
                      'Operating Hours',
                      centerDetail?.openingHours!.weekdayText.join(', '),
                    ),

                  _buildDetailRow(
                    context,
                    'Contact No.',
                    centerDetail?.formattedPhoneNumber,
                  ),

                  _buildDetailRow(context, 'Website', centerDetail?.website),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          );
        },

        loading: () => const Center(child: CircularProgressIndicator()),
        error:
            (error, stack) => LoadingError(
              error:
                  'Error loading details: ${error.toString()}\n'
                  'Please check your API key and internet connection.',
            ),
      ),
    );
  }

  SizedBox _googleMapsButton(RecyclingCenter center) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: () {
          launchGoogleMapsDirections(center, center.name);
        },
        icon: const Icon(Icons.map, color: Colors.white),
        label: const Text(
          'Google Maps',
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue, // Google Maps blue
          padding: const EdgeInsets.symmetric(vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
    );
  }
}
