import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fv2/views/pages/Disease/Detection/PhotoScanConfirm.dart';
import 'package:fv2/views/pages/Disease/DetectionHome/DetectionRecordsPage.dart';
import 'package:fv2/views/pages/components/detection/DetectionRecord.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loader_overlay/loader_overlay.dart';

class DetectionHomePage extends StatelessWidget {
  const DetectionHomePage({super.key});
 Future pickImage(ImageSource source, BuildContext context) async {
    // Use image_picker package to pick image from gallery or camera
    try {
    context.loaderOverlay.show();
      final image = await ImagePicker().pickImage(source: source);
      context.loaderOverlay.hide();
      if (image == null) return;
      final imageTemporary = File(image.path);
     Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PhotoScanConfirm(newImage: imageTemporary),
        ),
      );
   
    } on PlatformException catch (e) {
      print("Failed to pick image: $e");
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
              Container(
              width: double.infinity,
              padding: const EdgeInsets.all(25.0),
              decoration: BoxDecoration(
                color: Color(0xFF2563EB),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Scan Plant disease',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
      
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "Take or upload a photo to identify plant diseases instantly",
                    style: TextStyle(color: Colors.white),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white, // button bg
                            foregroundColor: Colors.blue, // icon & text color
                          ),
                          onPressed: () {
      
                           Navigator.pushNamed(context, '/photoGuide');
                          },
                          icon: const Icon(Icons.camera_alt_outlined),
                          label: const Text("Camera"),
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white, // button bg
                            foregroundColor: Colors.blue, // icon & text color
                          ),
                          onPressed: () async{
                           await pickImage(ImageSource.gallery,context);
                          },
                          icon: const Icon(Icons.image_outlined),
                          label: const Text("Gallery"),
                        ),
                      ),
                  
                    ],
                  ),
                
                ],
              ),
            ),
            const SizedBox(height: 20),
              Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Recent Detection Records",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => DetectionPecordsPage(),
                                      ),
                                    );

                                  },
                                  child: const Text("View All"),
                                ),
                              
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            DetectionRecord(icon:Icons.arrow_forward_ios)
                          ],
                        )
                      ),
                    )  
                    
          ],
        ),
      ),
    );
  }
}