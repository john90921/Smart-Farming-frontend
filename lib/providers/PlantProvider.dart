import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fv2/api/ApiHelper.dart';
import 'package:fv2/models/Plant.dart';
import 'package:fv2/services/PlantService.dart';
import 'package:fv2/views/pages/components/loading/hideLoading.dart';
import 'package:fv2/views/pages/components/loading/showCircularDialog.dart';


class PlantProvider extends ChangeNotifier {

  List<Plant> _plants = [];
  List<Plant> _recentPlants = [];
  bool _disposed = false;
  List<Plant> get plants => _plants;
  List<Plant> get recentPlants => _recentPlants;
  Plantservice _plantservice = Plantservice();
  void setPlants(List<Plant> plants) {
    _plants = plants;
    notifyListeners();
  }

   @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }

  @override
  void notifyListeners() {
    if (!_disposed) {
      super.notifyListeners();
    }
  }

  deletePlant(int plantId, BuildContext context) async{
    showCircularDialog(context);
    
    try{
      await _plantservice.deletePlant(plantId);
        displayPlant(context);
        displayRecentPlant(context);
      if (!context.mounted) return;
         ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('success'),
          backgroundColor: Color.fromARGB(255, 36, 153, 0),
          behavior: SnackBarBehavior.floating,
        ),
      );
       // close the loading dialog
    } catch(e){
       if (!context.mounted) return;
         ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error deleting plant'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
    finally{
      if (!context.mounted) return;
      hideLoading(context);
    }


  }

  displayRecentPlant(BuildContext context) async{
    try{
      List<Plant> recentPlants = await _plantservice.loadRecentPlant();
      _recentPlants = recentPlants;
      notifyListeners();
    } catch(e){
       if (!context.mounted) return;
         ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error'),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
        ),
      );
      print("Error loading recent : $e");
    }
  }
    displayPlant(BuildContext context) async{
    try{
      List<Plant> plants = await _plantservice.loadPlant();
      _plants = plants;
      notifyListeners();
    } catch(e){
       if (!context.mounted) return;
         ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error'),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
        ),
      );
      print("Error loading recent plants: $e");
    }
  }

  addNewPlant({
    required String name,
    required String imagePath,
    required double confidence,
    required BuildContext context,
  }) async{
      FormData formData = FormData.fromMap({
        'name': name,
        'image': await MultipartFile.fromFile(
          imagePath,
          filename: 'image.jpg',
        ),
      });
      try{
      ApiResult result = await Apihelper.post(
        ApiRequest(path: "/plant", data: formData),
      );
      if (result.status) {
        displayPlant(context);
        displayRecentPlant(context);
      } else {
        print("error ${result.message}");

      }
      } catch(e){
        print("error $e");
      }



  }
}