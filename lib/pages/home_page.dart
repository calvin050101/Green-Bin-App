import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            "GreenBin",
            style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w600,
              fontSize: 32,
            ),
          ),
        ),
        backgroundColor: Colors.transparent,
      ),

      body: Column(
        children: [
          const SizedBox(height: 20),

          topContainer(context),

          const SizedBox(height: 40),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: pointsProgressContainer(context),
          ),
          const SizedBox(height: 20),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: funFactContainer(context),
          ),
        ],
      ),
    );
  }

  Container funFactContainer(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Color(0xFFD6D6D6), width: 2),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Did you know?",
              style: TextStyle(
                color: Theme.of(context).colorScheme.surface,
                fontWeight: FontWeight.w600,
                fontSize: 16,
                fontFamily: 'OpenSans',
              ),
            ),
            SizedBox(height: 10),
            Row(
              children: [
                Icon(
                  Icons.check_circle,
                  color: Theme.of(context).colorScheme.primary,
                  size: 50,
                ),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Recycling 1 ton of paper is equivalent to saving 17 trees, '
                    'and saves up to 3 cubic yards.',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.surface,
                      fontFamily: 'OpenSans',
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Container pointsProgressContainer(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Color(0xFFD6D6D6), width: 2),
      ),

      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "You have saved 8.5 kg CO₂ by recycling.",
              style: TextStyle(
                color: Theme.of(context).colorScheme.surface,
                fontWeight: FontWeight.w600,
                fontSize: 16,
                fontFamily: 'OpenSans',
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
              child: LinearProgressIndicator(
                value: 150 / 180,
                minHeight: 10,
                borderRadius: BorderRadius.circular(5),
                backgroundColor: Theme.of(context).colorScheme.surface,
                valueColor: AlwaysStoppedAnimation<Color>(
                  Theme.of(context).colorScheme.primary,
                ),
              ),
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "150/180 Points",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.surface,
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    fontFamily: 'OpenSans',
                  ),
                ),

                Text(
                  "Recycler Level 3",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                    fontFamily: 'OpenSans',
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  SizedBox topContainer(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Stack(
        children: [
          // Background Image with Opacity
          Positioned.fill(
            child: Opacity(
              opacity: 0.25,
              child: Image.asset(
                'lib/assets/images/green-bin-banner.png',
                fit: BoxFit.cover,
              ),
            ),
          ),

          // Main Content
          Padding(
            padding: const EdgeInsets.only(top: 20, bottom: 20),
            child: Center(
              child: Column(
                children: [
                  Text(
                    "Sort Smarter. Recycle Better.",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.surface,
                      fontWeight: FontWeight.w700,
                      fontSize: 20,
                      fontFamily: 'Poppins',
                    ),
                  ),
                  Text(
                    "Let GreenBin guide you to a cleaner tomorrow.",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.surface,
                      fontSize: 16,
                      fontFamily: 'Poppins',
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: topContainerButton(
                          context,
                          Theme.of(context).colorScheme.primary,
                          'Scan and Sort',
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: topContainerButton(
                          context,
                          Theme.of(context).colorScheme.secondary,
                          'Waste Guide',
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  TextButton topContainerButton(
    BuildContext context,
    Color btnColor,
    String btnText,
  ) {
    return TextButton(
      style: TextButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: btnColor,
        padding: EdgeInsets.symmetric(horizontal: 16),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
      ),
      onPressed: () {},
      child: Text(
        btnText,
        style: TextStyle(
          fontFamily: 'OpenSans',
          fontWeight: FontWeight.w600,
          fontSize: 16,
        ),
      ),
    );
  }
}
