import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fv2/dio/DetectDioHandler.dart';
import 'package:fv2/providers/PlantProvider.dart';
import 'package:fv2/services/PlantService.dart';
import 'package:fv2/services/TfliteService.dart';
import 'package:fv2/utils/message_helper.dart';
import 'package:fv2/views/pages/Disease/Detection/PlantDisease.dart';
import 'package:fv2/views/pages/Disease/Detection/Solution.dart';
import 'package:fv2/views/pages/components/loading/LoadingPage.dart';
import 'package:fv2/views/pages/components/loading/showCircularDialog.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:provider/provider.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'dart:typed_data';

class PhotoScanConfirm extends StatefulWidget {
  const PhotoScanConfirm({super.key, required this.newImage});
  final File? newImage;

  @override
  State<PhotoScanConfirm> createState() => _PhotoScanConfirmState();
}

class _PhotoScanConfirmState extends State<PhotoScanConfirm> {
  late Interpreter interpreter;
  bool loading = false;
  bool error = false;
  int output_index = 0;
  double output_confidence = 0.0;
  Future<void> loadModel() async {
    interpreter = await Interpreter.fromAsset(
      'assets/dragon_fruit_model.tflite',
    );
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return LoadingPage();
    }
    if (error) {}
    return Scaffold(
      appBar: AppBar(
        title: const Text('Confirm Photo'),
        leading: BackButton(
          onPressed: () {
            Navigator.pop(context, false);
          },
        ),
        actions: [
          TextButton(
            onPressed: () => {
              if (context.mounted)
                {
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    "/widgettree",
                    (route) => false,
                  ),
                },
            },
            child: const Text('Cancel', style: TextStyle(color: Colors.blue)),
          ),
        ],
      ),
      body: SafeArea(
        child: SizedBox(
          width: double.infinity,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                if (error)
                  Padding(
                    padding: EdgeInsetsGeometry.all(2),
                    child: Text("error accur Please try again"),
                  ),
                if (widget.newImage != null)
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Image.file(
                      widget.newImage!,
                      fit: BoxFit.contain,
                      height: 450,
                    ),
                  ),
                const SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    minimumSize: const Size(200, 45),
                  ),
                  onPressed: () async {
                    print("1");
                    error = false; // to reset error variable for display error
                    setState(() {
                      loading = true; //start loadingg
                    });
                    // Handle confirm actionto
                    if (widget.newImage == null) return; // if null iamge
                    try {
                      await loadModel();
            
                      TfliteService tfliteService = TfliteService();
            
                      Float32List input = tfliteService.preprocessImage(
                        widget.newImage!,
                      );
                      final output = List.filled(6, 0.0).reshape([1, 6]);
                      interpreter.run(input.reshape([1, 224, 224, 3]), output);
                      List<double> results = List<double>.from(output[0]);
            
                      output_confidence = results[0];
                      for (int i = 1; i < results.length; i++) {
                        if (results[i] > output_confidence) {
                          output_confidence = results[i];
                          output_index = i;
                        }
                      }
                      print("Inference Results: $results");
                      print(
                        "Predicted Index: $output_index with confidence $output_confidence",
                      );
            
                      String? name;
                      String? disease;
                      double? confidence;
                      DiseaseModel? diseaseModel;
                      Plantservice plantservice = Plantservice(); //upload the record
                      
                      await plantservice.addPlant(
                        imageFile: widget.newImage!,
                        diseaseId: output_index,
                        confidence: output_confidence,
                      );
            
                   final plantProvider =   Provider.of<PlantProvider>(context, listen: false);
                      plantProvider.displayRecentPlant(context);
                    } catch (e) {
                      error = true;
                      print("Error during model inference: $e");
                      if (!context.mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('error please try again'),
                          backgroundColor: Colors.green,
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    }
                    setState(() {
                      loading = false;
                    });
                    if (!error) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LoaderOverlay(
                            child: PlantDisease(
                              diseaseId: output_index,
                              image: widget.newImage!,
                              confidence: output_confidence,
                              // diseaseModel: diseaseModel,
                            ),
                          ),
                        ),
                      );
                    }
                    //                   try {
            
                    //                     FormData formData;
            
                    //                     formData = FormData.fromMap({
                    //                       'image': await MultipartFile.fromFile(
                    //                         newImage!.path,
                    //                         filename: "name",
                    //                       ),
                    //                     });
                    //                     print("Sending image to API: ${newImage!.path}");
            
                    //                     final predictResponse = await _dio.post(
                    //                       '/predict',
                    //                       data: formData,
                    //                     );
            
                    //                     final data = predictResponse.data;
            
                    //                     print("Prediction Response Data: $data");
                    //                     name = data['plant'];
                    //                     disease = data['disease'];
                    //                     confidence = data['confidence'];
                    // status = true;
            
                    //                     // final solutionResponse = await _dio.post(
                    //                     //   '/getremedy',
                    //                     //   queryParameters: {
                    //                     //     'crop': plant,
                    //                     //     'disease': disease,
                    //                     //     'confidence': confidence,
                    //                     //   },
                    //                     // );
            
                    //                     // diseaseModel = DiseaseModel.fromJson(
                    //                     //   solutionResponse.data,
                    //                     // );
                    //                     // print("Disease Model: ${diseaseModel.toJson()}");
            
                    //                   } on DioException catch (dioErr) {
                    //                     print("DioException: ${dioErr.type} ${dioErr.message}");
                    //                     if (dioErr.response != null) {
                    //                       print(
                    //                         "Dio response: ${dioErr.response?.statusCode} ${dioErr.response?.data}",
                    //                       );
                    //                     }
                    //                   } catch (e, st) {
                    //                     print("Error during AP1I POST request: $e\n$st");
                    //                   }
            
                    //                   if(context.mounted && status){Navigator.push(
                    //                     context,
                    //                     MaterialPageRoute(
                    //                       builder: (context) => LoaderOverlay(
                    //                         child: PlantDisease(
                    //                           name: name ?? "Unknown",
                    //                           disease: disease ?? "Unknown",
                    //                           image: newImage!,
                    //                           confidence: confidence ?? 0.0,
                    //                           // diseaseModel: diseaseModel,
                    //                         ),
                    //                       ),
                    //                     ),
                    //                   );}
                    //                   else if (context.mounted) {
            
                    // showMessage(context: context, message: "Error during disease detection. Please try again.", isError: true);
            
                    //                       }
            
                    // Navigator.pop(context, true);
                  },
                  child: const Text('Confirm'),
                ),
                const SizedBox(height: 10),
                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size(200, 45),
                  ),
                  onPressed: () {
                    // Handle retake action
                    Navigator.pop(context, false);
                  },
                  child: const Text('Retake'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
