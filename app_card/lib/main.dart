import 'package:flutter/material.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'IUT ID Card',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final cardWidth = 300.0;
            final avatarWidth = 90.0;
            final avatarLeft = (cardWidth / 2) - (avatarWidth / 2);

            return Card(
              color: Colors.white,
              elevation: 8,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: SizedBox(
                width: cardWidth,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // 🔹 Stack for header + avatar
                    Stack(
                      clipBehavior: Clip.none,
                      alignment: Alignment.topCenter,
                      children: [
                        // Header (logo + university name)
                        Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.green[900],
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(16),
                              topRight: Radius.circular(16),
                            ),
                          ),
                          padding: const EdgeInsets.only(top: 16, bottom: 60),
                          child: Column(
                            children: [
                              Image.asset("assets/images/iut_logo.png", height: 30),
                              const SizedBox(height: 8),
                              const Text(
                                "ISLAMIC UNIVERSITY OF TECHNOLOGY",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),

                        // Avatar (overlapping)
                        Positioned(
                          bottom: -50,
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.green[900]!, width: 6), // thin border
                              borderRadius: BorderRadius.circular(45), // circular border for avatar
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(45),
                              child: Image.asset(
                                "assets/images/avatar.png",
                                height: 100,
                                width: avatarWidth,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 50), // space below avatar

                    // Middle white body aligned with avatar
                    Padding(
                      padding: EdgeInsets.only(left: avatarLeft, right: 16, bottom: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          InfoRow(
                            icon: Icons.key,
                            label: "Student ID",
                            value: "210041126",
                            isStacked: true,
                          ),
                          InfoRow(
                            icon: Icons.person,
                            label: "Student Name",
                            value: "Anik",
                            isBold: true,
                            isStacked: true,
                          ),
                          InfoRow(
                            icon: Icons.school,
                            label: "Program",
                            value: "B.Sc. in CSE",
                          ),
                          InfoRow(
                            icon: Icons.account_tree,
                            label: "Department",
                            value: "CSE",
                          ),
                          InfoRow(
                            icon: Icons.location_on,
                            label: "Bangladesh",
                            value: "",
                          ),
                        ],
                      ),
                    ),

                    // Bottom Footer
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.green[900],
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(12),
                          bottomRight: Radius.circular(12),
                        ),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: const Text(
                        "A subsidiary organ of OIC",
                        style: TextStyle(
                          color: Colors.white,
                          fontStyle: FontStyle.italic,
                          fontSize: 12,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final bool isBold;
  final bool isStacked;

  const InfoRow({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    this.isBold = false,
    this.isStacked = false,
  });

  @override
  Widget build(BuildContext context) {
    if (isStacked) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 6),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: Colors.black87),
        const SizedBox(width: 6),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 14,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 2),
            Padding(
              padding: const EdgeInsets.only(left: 0), // align with icon
              child: Text(
                value,
                style: TextStyle(
                  fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
                  fontSize: 14,
                  color: Colors.black87,
                ),
              ),
            ),
          ],
        ),
      ],
    ),
  );
}
 else {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 18, color: Colors.black87),
            const SizedBox(width: 6),
            Expanded(
              child: RichText(
                text: TextSpan(
                  style: const TextStyle(color: Colors.black87, fontSize: 14),
                  children: [
                    TextSpan(
                      text: "$label ",
                      style: const TextStyle(fontWeight: FontWeight.w500),
                    ),
                    TextSpan(
                      text: value,
                      style: TextStyle(
                        fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    }
  }
}
