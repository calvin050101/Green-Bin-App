import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:green_bin/providers/recycling_center_provider.dart';
import 'package:green_bin/helper/location_functions.dart';
import 'package:green_bin/widgets/form/loading_error.dart';
import '../../models/recycling_center.dart';
import '../../widgets/back_button.dart';

class RecyclingCenterDetailPage extends ConsumerWidget {
  static String routeName = "/recycling-center-detail";

  const RecyclingCenterDetailPage({super.key});

  Widget _buildDetailRow(
    BuildContext context,
    String title,
    String? value, {
    List<Widget>? children,
  }) {
    final hasValue = value != null && value.isNotEmpty && value != 'N/A';
    final hasChildren = children != null && children.isNotEmpty;

    if (!hasValue && !hasChildren) {
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
          if (hasValue)
            Text(
              value,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Colors.black87,
                fontFamily: 'OpenSans',
              ),
            ),
          if (hasChildren) ...children,
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
                    SizedBox(
                      height: 200,
                      width: double.infinity,
                      child: CachedNetworkImage(
                        imageUrl: center.photoUrl!,
                        fit: BoxFit.cover,
                        placeholder:
                            (context, url) => Container(
                              color: Colors.grey[300],
                              child: const Center(
                                child: CircularProgressIndicator(),
                              ),
                            ),
                        errorWidget:
                            (context, url, error) => Container(
                              color: Colors.grey[200],
                              child: const Icon(
                                Icons.broken_image,
                                color: Colors.grey,
                                size: 80,
                              ),
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

                  if (centerDetail?.openingHours != null &&
                      centerDetail?.openingHours!.weekdayText != null)
                    _buildDetailRow(
                      context,
                      'Operating Hours',
                      null,
                      children:
                          centerDetail!.openingHours!.weekdayText
                              .map(
                                (day) => Text(
                                  day,
                                  style: Theme.of(
                                    context,
                                  ).textTheme.bodyLarge?.copyWith(
                                    color: Colors.black87,
                                    fontFamily: 'OpenSans',
                                  ),
                                ),
                              )
                              .toList(),
                    ),

                  if (centerDetail?.formattedPhoneNumber != null)
                    _buildDetailRow(
                      context,
                      'Contact No.',
                      centerDetail?.formattedPhoneNumber,
                    ),

                  if (centerDetail?.website != null)
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
