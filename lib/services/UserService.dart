import 'dart:io';

import 'package:fv2/dio/DioHandler.dart';
import 'package:dio/dio.dart';
import 'package:fv2/models/User.dart';


class UserService {
    Dio dio = DioHandler.instance.dio;
//  Future<List<User>> getUsers() async {
//    final response = await dio.get('/user'); 
//    List<dynamic> UserDataJson = response.data['data'] as List<dynamic>;
//   if(UserDataJson.isNotEmpty){
//     return List<User>.from(
//       (UserDataJson).map(
//         (user) => User.fromMap(user as Map<String, dynamic>
//       )
//     ));
//   }else{
//     return [];
//   }
//  }


 Future<List<User>> getUsers() async {
   final response = await dio.get('/user'); 
   List<dynamic> UserDataJson = response.data['data'] as List<dynamic>;
  if(UserDataJson.isNotEmpty){
    return List<User>.from(
      (UserDataJson).map(
        (user) => User.fromMap(user as Map<String, dynamic>
      )
    ));
  }else{
    return [];
  }
 }
 Future<void> addUser(String? name,String? email,String? role) async{
   await dio.post('/user',data:{"name":name,"email":email,"role":role}); 
 }
  Future<void> EditUser(int? userID, String? name,String? email,String? role) async{
   await dio.put('/user/$userID',data:{"name":name,"email":email,"role":role}); 
 }
 Future<void> EditProfile(int? profileId, String? name,String? phone,File? newimage, bool? isDeletedImage)
  async{
    FormData formData = FormData.fromMap({
      '_method': 'PUT',
      'name': name,
      'phone': phone,
      if(newimage != null)
      'profile_image': await MultipartFile.fromFile(newimage.path,filename: newimage.path.split('/').last),
      'remove_image': isDeletedImage == true ? 'true' : 'false',
    });
    await dio.post('/profile/$profileId',data:formData); 
  }
}