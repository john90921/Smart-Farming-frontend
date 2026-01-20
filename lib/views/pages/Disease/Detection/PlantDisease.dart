import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fv2/dio/DetectDioHandler.dart';
import 'package:fv2/models/Plant.dart';
import 'package:fv2/models/Post.dart';
import 'package:fv2/utils/message_helper.dart';
import 'package:fv2/views/pages/Disease/Detection/DiseaseDetailPage.dart';
import 'package:fv2/views/pages/Disease/Detection/DragonFruitDiseases.dart';
import 'package:fv2/views/pages/Disease/Detection/Solution.dart';
import 'package:fv2/views/pages/PostFormPage.dart';
import 'package:loader_overlay/loader_overlay.dart';

class PlantDisease extends StatefulWidget {
  const PlantDisease({
    super.key,
    this.image,
    this.imageUrl,
    required this.diseaseId,
    required this.confidence,
    this.dateTime,
  });
  final int diseaseId;
  final File? image;
  final String? imageUrl;
  final double? confidence;
  final String? dateTime;

  @override
  State<PlantDisease> createState() => _PlantDiseaseState();
}

class _PlantDiseaseState extends State<PlantDisease> {
  late Map<String, dynamic> diseaseInfo;
  final dragonFruitDiseases = DragonFruitDiseases.dragonFruitDiseases;
  @override
  void initState() {
    diseaseInfo = dragonFruitDiseases[widget.diseaseId];
    print("diseaseInfo: $diseaseInfo, diseaseId: ${widget.diseaseId}");
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Result'),
        centerTitle: true,
        leading: BackButton(
          onPressed: (){
            if (mounted) {
  Navigator.pop(context);
}
          },
        ),
        
         actions: [TextButton(
          child: const Text('Done', style: TextStyle(color: Colors.blue)),
          onPressed: () {
            if (context.mounted) {
              Navigator.pushNamedAndRemoveUntil(context, "/widgettree", (route) => false);
            }
          },
        ),]
    
      ),
      body: SafeArea(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          width: double.infinity,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                    
              if(widget.image != null)
                SizedBox(
                  //image disease
                  height: 200,
                  width: 200,
                  child:widget.image == null ? const Placeholder() : Image.file(
                    widget.image!,
                  width: 200,
                    height: 200,
                    fit: BoxFit.cover,
                  ),
                ),
                if(widget.imageUrl != null)
                SizedBox(
                  //image disease
                  height: 200,
                  width: 200,
                  child: Image.network(
            widget.imageUrl!,
            loadingBuilder: (context, child, progress) {
              if (progress == null) return child;
              return const CircularProgressIndicator();
            },
            errorBuilder: (context, error, stackTrace) {
              return const Icon(Icons.broken_image);
            },
                    ),
                
                ),
                
                // Container(
                //   // container confidence score and plant name
                //   decoration: BoxDecoration(
                //     color: const Color.fromARGB(255, 255, 255, 255),
                //     borderRadius: BorderRadius.circular(8.0),
                //   ),
                //   child: Padding(
                //     padding: const EdgeInsets.all(8.0),
                //     child: ListTile(
                //       trailing: Text(
                //         "30/5/2025 10:00 am",
                //       ), // Confidence score
                //       title: Text(
                //         "Created Time", // Plant name
                //         style: TextStyle(
                //           fontSize: 15,
                //           fontWeight: FontWeight.bold,
                //         ),
                //       ),
                //       // subtitle: Text("Plant : ${widget.name}"),
                //     ),
                //   ),
                
                // ),
                
                const SizedBox(height: 20),
                Container(
                  // container confidence score and plant name
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 255, 255, 255),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListTile(
                      trailing: Text(
                        "${((widget.confidence ?? 0) * 100).toStringAsFixed(2)} % confidence",
                      ), // Confidence score
                      title: Text(
                        "Disease : \n  ${diseaseInfo['name']}", // Plant name
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      // subtitle: Text("Plant : ${widget.name}"),
                    ),
                  ),
                ),
                
                SizedBox(height: 20),
                  Container(
                  // container confidence score and plant name
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 255, 255, 255),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListTile( // Confidence score
                      title: Text(
                        "Symptoms", // Plant name
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle:Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                        SizedBox(height: 10),
                        Text(diseaseInfo['symptoms'][0]),
                        Divider(),
                        Text(diseaseInfo['symptoms'][1]),
                        Divider(),
                        Text(diseaseInfo['symptoms'][2]),
                      ],),
                      // subtitle: Text("Plant : ${widget.name}"),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                  Container(
                  // container confidence score and plant name
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 255, 255, 255),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListTile( // Confidence score
                      title: Text(
                        "Solution", // Plant name
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle:Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                        SizedBox(height: 10),
                        Text(diseaseInfo['solutions'][0]),
                        Divider(),
                        Text(diseaseInfo['solutions'][1]),
                        Divider(),
                        Text(diseaseInfo['solutions'][2]),
                      ],),
                      // subtitle: Text("Plant : ${widget.name}"),
                    ),
                  ),
                ),
                    //                 if ((widget.disease == "Unknown Disease" || widget.disease == "Unknown")) ...[
                    //                   ElevatedButton(
                    //                     onPressed: () async {
                    //                       final dio = DetectDioHandler.instance.dio;
                    //                       String name = ;
                    //                       String disease = widget.disease;
                    //                       double confidence = widget.confidence;
                    //                       DiseaseModel? diseaseModel;
                    //                       bool success = false;
                    //                           context.loaderOverlay.show();
                    //                       try {
                    
                    //                         final solutionResponse = await dio.post(
                    //                           '/getremedy',
                    //                           queryParameters: {
                    //                             'crop': name,
                    //                             'disease': disease,
                    //                             'confidence': confidence,
                    //                           },
                    //                         );
                    
                    //                         diseaseModel = DiseaseModel.fromJson(
                    //                           solutionResponse.data,
                    //                         );
                    
                        
                    //                         print("Disease Model: ${diseaseModel.toJson()}");
                    //                         success = true;
                    //                       } on DioException catch (dioErr) {
                    //                         print("DioException: ${dioErr.type} ${dioErr.message}");
                    //                         if (dioErr.response != null) {
                    //                           print(
                    //                             "Dio response: ${dioErr.response?.statusCode} ${dioErr.response?.data}",
                    //                           );
                    //                         }
                    //                       } catch (e, st) {
                    //                         print("Error during AP1I POST request: $e\n$st");
                    //                       }
                    //                       context.loaderOverlay.hide();
                    //                       if (success && mounted) {
                    //                             Navigator.push(
                    //                     context,
                    //                     MaterialPageRoute(
                    //                       builder: (context) => DiseaseDetailPage(
                    //                        disease: diseaseModel!,
                       
                    //                       ),
                    //                     ),
                    //                   );
                    //                       }
                    //                       else{
                    //                           if (mounted) {
                    //  showMessage(context: context, message: "Error fetching disease information. Please try again.", isError: true);
                    // }
                    //                       }
                    //                       print("Ask for more information about the disease");
                    //                     },
                    //                     child: Text("Get More Information"),
                    //                   ),
                    //                 ],
              
              ],
            ),
          ),
        ),
      ),
    );
  }
}
