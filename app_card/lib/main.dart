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
  final idController = TextEditingController(text: "Your ID");
  final programController = TextEditingController(text: "Your Program");
  final departmentController = TextEditingController(text: "Your Department");
  final uniController = TextEditingController(text: "Your University");
  final locationController = TextEditingController(text: "Your Location");

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

  // Pick image (works on web and mobile)
  Future<void> pickAvatar() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        allowMultiple: false,
      );

      if (result != null && result.files.isNotEmpty) {
        Uint8List? bytes = result.files.single.bytes;
        if (bytes != null) {
          setState(() {
            avatarBytes = bytes;
          });
        }
      }
    } catch (e) {
      print("Error picking file: $e");
    }
  }

  void generateCard() {
    setState(() {
      isGenerated = true;
    });
  }

  void editCard() {
    setState(() {
      isGenerated = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final cardWidth = 300.0;
    final avatarWidth = 80.0;

    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: const Text("IUT ID Card Generator"),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                // Buttons for random font/color
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
                                  topLeft: Radius.circular(12),
                                  topRight: Radius.circular(12),
                                ),
                              ),
                              padding: const EdgeInsets.only(top: 16, bottom: 50),
                              child: Column(
                                children: [
                                  avatarBytes == null
                                      ? const Icon(Icons.school, size: 30, color: Colors.white)
                                      : const SizedBox(height: 30),
                                  const SizedBox(height: 8),
                                  isGenerated
                                      ? Text(
                                          uniController.text,
                                          style: fontStyle.copyWith(
                                            color: Colors.white, 
                                            fontSize: 13,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          textAlign: TextAlign.center,
                                        )
                                      : TextField(
                                          controller: uniController,
                                          enabled: !isGenerated,
                                          style: fontStyle.copyWith(
                                            color: Colors.white, 
                                            fontSize: 13,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          textAlign: TextAlign.center,
                                          decoration: const InputDecoration(
                                            border: InputBorder.none,
                                            hintText: "University Name",
                                            hintStyle: TextStyle(color: Colors.white),
                                            contentPadding: EdgeInsets.symmetric(horizontal: 8),
                                          ),
                                        ),
                                ],
                              ),
                            ),
                            Positioned(
                              bottom: -avatarWidth/2,
                              child: GestureDetector(
                                onTap: isGenerated ? null : pickAvatar,
                                child: Container(
                                  width: avatarWidth,
                                  height: avatarWidth,
                                  decoration: BoxDecoration(
                                    border: Border.all(color: cardColor, width: 3),
                                    borderRadius: BorderRadius.circular(avatarWidth/2),
                                    color: Colors.white,
                                  ),
                                  child: ClipOval(
                                    child: avatarBytes != null
                                        ? Image.memory(
                                            avatarBytes!,
                                            width: avatarWidth,
                                            height: avatarWidth,
                                            fit: BoxFit.cover,
                                          )
                                        : Container(
                                            color: Colors.grey[100],
                                            child: Icon(
                                              Icons.add_a_photo,
                                              size: 30,
                                              color: Colors.grey[600],
                                            ),
                                          ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 45),
                        // Fields on card
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              buildField("Student ID", idController),
                              buildField("Name", nameController),
                              buildField("Program", programController),
                              buildField("Department", departmentController),
                              buildField("Location", locationController),
                            ],
                          ),
                        ),
                        // Generate/Edit button
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                          child: SizedBox(
                            width: double.infinity,
                            child: isGenerated
                                ? ElevatedButton(
                                    onPressed: editCard,
                                    child: const Text("Edit Card"),
                                  )
                                : ElevatedButton(
                                    onPressed: generateCard,
                                    child: const Text("Generate ID Card"),
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20), // Extra space at bottom
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: isGenerated
          ? Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Text(
                controller.text,
                style: fontStyle.copyWith(color: Colors.black87, fontSize: 14),
              ),
            )
          : TextField(
              controller: controller,
              enabled: !isGenerated,
              style: fontStyle.copyWith(color: Colors.black87, fontSize: 14),
              decoration: InputDecoration(
                labelText: label,
                border: const OutlineInputBorder(),
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                isDense: true,
              ),
            ),
    );
  }
}