import 'dart:io';

import 'package:fv2/dio/DioHandler.dart';
import 'package:dio/dio.dart';
import 'package:fv2/models/User.dart';
import 'package:fv2/views/pages/components/exception/loginException.dart';


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
  Future<List<User>> searchUser(int? id ) async {
   final response = await dio.get('/user/search/$id'); 
  final exists = response.data['status'] as bool;
  print('Exists: $exists');
  if(exists){
    print('User found');
    List<dynamic> UserDataJson = response.data['data'] as List<dynamic>;

    return List<User>.from(
      (UserDataJson).map(
        (user) => User.fromMap(user as Map<String, dynamic>
      )
    ));
  }else{
    print('User not found');
    return [];
  }
 }
 Future<void> addUser(String? name,String? email,String? role,String? password) async{
  final response = await dio.post('/user',data:{"name":name,"email":email,"role":role,"password":password}); 
  Map<String, dynamic> data = response.data as Map<String, dynamic>;
  if(data.containsKey('exists') && data['exists'] == true){
    throw LoginException('User with this email already exists');
  }
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
   Future<void> DeleteUser(int? userID) async{
   await dio.delete('/user/$userID'); 
 }
}