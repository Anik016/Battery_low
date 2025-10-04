import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:math';

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

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final nameController = TextEditingController(text: "Your Name");
  final idController = TextEditingController(text: "210041126");
  final programController = TextEditingController(text: "B.Sc. in CSE");
  final departmentController = TextEditingController(text: "CSE");
  final uniController = TextEditingController(text: "Islamic University of Technology");
  final locationController = TextEditingController(text: "Bangladesh");

  bool isGenerated = false;
  Uint8List? avatarBytes;

  Color cardColor = Colors.green[900]!;
  TextStyle fontStyle = GoogleFonts.roboto();

  final random = Random();

  // Random font generator
  void changeFont() {
    final fonts = [
      GoogleFonts.lobster(),
      GoogleFonts.poppins(),
      GoogleFonts.openSans(),
      GoogleFonts.robotoMono(),
      GoogleFonts.dancingScript(),
      GoogleFonts.montserrat(),
    ];
    setState(() {
      fontStyle = fonts[random.nextInt(fonts.length)];
    });
  }

  // Random color generator
  void changeColor() {
    setState(() {
      cardColor = Color.fromARGB(
        255,
        random.nextInt(256),
        random.nextInt(256),
        random.nextInt(256),
      );
    });
  }

  // Pick image (works on web)
  Future<void> pickAvatar() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
    );

    if (result != null && result.files.single.bytes != null) {
      setState(() {
        avatarBytes = result.files.single.bytes;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final cardWidth = 300.0;
    final avatarWidth = 90.0;
    //final avatarLeft = (cardWidth / 2) - (avatarWidth / 2);

    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: const Text("IUT ID Card Generator"),
        actions: [
          TextButton(
            onPressed: isGenerated
                ? () {
                    setState(() {
                      isGenerated = false;
                    });
                  }
                : null,
            child: const Text(
              "Edit",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            // Buttons for random font/color and image
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: changeFont,
                  child: const Text("Random Font"),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: changeColor,
                  child: const Text("Random Color"),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: pickAvatar,
                  child: const Text("Pick Image"),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Card(
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
                    // Header + avatar
                    Stack(
                      clipBehavior: Clip.none,
                      alignment: Alignment.topCenter,
                      children: [
                        Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: cardColor,
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(16),
                              topRight: Radius.circular(16),
                            ),
                          ),
                          padding: const EdgeInsets.only(top: 16, bottom: 60),
                          child: Column(
                            children: [
                              avatarBytes == null
                                  ? const Icon(Icons.school, size: 30, color: Colors.white)
                                  : const SizedBox(height: 30),
                              const SizedBox(height: 8),
                              TextField(
                                controller: uniController,
                                enabled: !isGenerated,
                                style: fontStyle.copyWith(color: Colors.white, fontSize: 13),
                                textAlign: TextAlign.center,
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "University Name",
                                  hintStyle: TextStyle(color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Positioned(
                          bottom: -50,
                          child: GestureDetector(
                            onTap: pickAvatar,
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: cardColor, width: 4),
                                borderRadius: BorderRadius.circular(45),
                              ),
                              child: ClipOval(
                                child: avatarBytes != null
                                    ? Image.memory(
                                        avatarBytes!,
                                        width: avatarWidth,
                                        height: avatarWidth,
                                        fit: BoxFit.cover,
                                      )
                                    : const Icon(
                                        Icons.add_a_photo,
                                        size: 50,
                                        color: Colors.grey,
                                      ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 50),
                    // Input fields on card
                    Padding(
                      padding: EdgeInsets.only(left: 16, right: 16, bottom: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          buildInputRow("Student ID", idController),
                          buildInputRow("Name", nameController),
                          buildInputRow("Program", programController),
                          buildInputRow("Department", departmentController),
                          buildInputRow("Location", locationController),
                        ],
                      ),
                    ),
                    // Generate button
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          isGenerated = true;
                        });
                      },
                      child: const Text("Generate ID Card"),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildInputRow(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: TextField(
        controller: controller,
        enabled: !isGenerated,
        style: fontStyle.copyWith(color: Colors.black87, fontSize: 14),
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }
}
