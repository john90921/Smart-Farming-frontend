import 'dart:io';

import 'package:dio/dio.dart';
import 'package:fv2/dio/DioHandler.dart';
import 'package:fv2/models/Plant.dart';
import 'package:fv2/services/ImageService.dart';


class Plantservice {
    Dio dio = DioHandler.instance.dio;
    ImageService imageService = ImageService();
  
  addPlant(
    {
    File? imageFile,
    int? diseaseId,
    double? confidence,
    }
  ) async{
       if (imageFile != null){
        imageFile = await imageService.compressFile(imageFile);
      }
    FormData plantFormData = FormData.fromMap(
      {
        'image': await MultipartFile.fromFile(
          imageFile!.path,
          filename: imageFile.path.split('/').last,
        ),
        'diseaseId': diseaseId,
        'confidence':confidence
      }
    );
    await dio.post('/plant',
    data: plantFormData
    ); 
  }
  Future<List<Plant>> loadRecentPlant(
  ) async{
    final result = await dio.get('/recentScan');
    List<dynamic> plantDataJson = result.data['data'] as List<dynamic>;
   if(plantDataJson.isNotEmpty){
      return List<Plant>.from(
        (plantDataJson).map(
          (plant) => Plant.fromMap(plant as Map<String, dynamic>
        )
      ));
   }else{
      return [];
   }
  }
  Future<List<Plant>> loadPlant(
  ) async{
    final result = await dio.get('/plant');
    List<dynamic> plantDataJson = result.data['data'] as List<dynamic>;
   if(plantDataJson.isNotEmpty){
      return List<Plant>.from(
        (plantDataJson).map(
          (plant) => Plant.fromMap(plant as Map<String, dynamic>
        )
      ));
   }else{
      return [];
   }
  }

  Future<void> deletePlant(int plantId) async{
    await dio.delete('/plant/$plantId');
  }


}