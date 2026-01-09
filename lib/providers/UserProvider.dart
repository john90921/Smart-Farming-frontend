import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fv2/api/ApiHelper.dart';
import 'package:fv2/models/User.dart';
import 'package:fv2/services/UserService.dart';
import 'package:fv2/token/TokenManager.dart';
import 'package:fv2/utils/message_helper.dart';
import 'package:loader_overlay/loader_overlay.dart';

class UserProvider extends ChangeNotifier {
  User _loginUser = User.initial();
  bool _disposed = false;
  bool isLoading = false;
  bool isSuccess = false;
  List<User?> users = [];
  User? selectedUser;
  String? error;
  final UserService _userService = UserService();
  int totalUser = 0;
  int _currentPage = 1;
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
  Future<bool?> addUser(String name, String email, String? role) async{
    print("$role");
    isLoading = true;
    error = null;
    isSuccess = false;
    
    notifyListeners();

    try{
      await _userService.addUser(name, email, role);
      await loadUsers();
    }
    catch(e){
      error= e.toString();
    }
    isLoading = false;
    notifyListeners();
     return error == null ? true : false; // check have error or not
  }
  Future<bool?> editProfile({int? profileId, String? name, String? phone, File? newimage, bool? isDeletedImage}) async{
    error = null;
    isSuccess = false;
    notifyListeners();

    try{
      await _userService.EditProfile(profileId,name, phone, newimage,isDeletedImage);
      await setUserInfo();
    }
    catch(e){
      error= e.toString();
    }
    
    isLoading = false;
    notifyListeners();
    return error == null;
  }
  Future<bool?> editUser(int? userID, String? name, String? email, String? role) async{
    isLoading = true;
    error = null;
    isSuccess = false;
    notifyListeners();

    try{
      await _userService.EditUser(userID,name, email, role);
      await loadUsers();
    }
    catch(e){
      error= e.toString();
    }
    
    isLoading = false;
    notifyListeners();
    return error == null ? true : false;
  }

  
 Future<void> loadUsers() async {
  
  // if(loadMore){
  //   _currentPage += 1;
  // }
  // else{
  //   _currentPage = 1;
  //   users = [];
  // }
  isLoading = true;
  error = null;
  isSuccess = false;
  notifyListeners();
  try{
    users = await _userService.getUsers();
  }
  catch (e){
    error = e.toString();
  }
  if(error == null){
    isSuccess = true;
  }
  isLoading = false;
  notifyListeners();
  }
  // Future<void> loadUsers({bool loadMore = false}) async {
  
  // if(!loadMore){
  //    _currentPage = 1;
  //   users = [];
  // }

  // error = null;
  // notifyListeners();
  // try{
  //   List<User> newUsers = await _userService.getUsers();
  //   if(newUsers.isEmpty){
  //     return;
  //   }
  //   users.addAll(newUsers);    
  //   _currentPage += 1;
  //   error = null;
  // }
  // catch (e){
  //   error = e.toString();
  // }

  // if(error == null){
  //   isSuccess = true;
  // }
  // isLoading = false;
  // notifyListeners();
  // }
  
  void setUser(User user) async {
    _loginUser = user;
  }

  User get getUser => _loginUser;

  parseUser(Map<String, dynamic> data) {
    return User.fromMap(data);
  }
  setUserInfo() async{
    try {
  ApiResult result = await Apihelper.get(
      ApiRequest(path: "/getLoginUserInfo"));
    if (result.status == true) {
      Map<String, dynamic> user = result.data as Map<String, dynamic>;
      setUser(parseUser(user));
      print("setUserInfo success: ${_loginUser.phone}");
      notifyListeners();
    }
    else{
      print("setUserInfo failed: ${result.message}");
    }
} on Exception catch (e) {
  // TODO
  print("setUserInfo error: $e");
}

  }

  void login(Map<String, dynamic> data){
    setUser(parseUser(data));
  }
  Future<bool> logout(BuildContext context) async {  
    ApiResult result = await Apihelper.post(ApiRequest(path: "/logout"));
    // if (result.status != true) {
    //   return false;
    // }

    await TokenManager.instance.clearAccessToken();
    _loginUser = User.initial();
    return true;
  }

  // Future<String?> editProfile(
  //  {required String name,
  //   required bool isRemoveImage,
  //   required bool HaveUploadedImage,
  //   required String? newImagePath,
  //   }
  // ) async {
  //   print("editProfile called");
  //   try{
  //       FormData formData;

  //     formData = FormData.fromMap({
  //       // if new image selected or delered image before, then send image field
  //       'name': name,
  //       'description': "no",
  //       '_method': 'PATCH',
  //       if (isRemoveImage == true && HaveUploadedImage == true)
  //         'remove_image': true,
  //       if (newImagePath != null)
  //         'profile_image': await MultipartFile.fromFile(
  //           newImagePath,
  //           filename: 'profile.jpg',
  //         ), //if new image selected
  //     });
  //       ApiResult result = await Apihelper.patch(
  //       ApiRequest(path: "/profile/${_loginUser.profile_id}", data: formData),
  //     );
  //   if (result.status == true) {
  //       print(result.data);
  //       Map<String, dynamic> data = result.data as Map<String, dynamic>;
  //       setUser(parseUser(data));
  //       notifyListeners();
  //       return "success edit profile";

  //   }
  //    else {
  //       print("error ${result.message}");
  //       return "error ${result.message}";
  //     }
  
  
  // }
  //  on Exception catch (e) {
  //     // TODO
  //     print("error $e");
  //   }
  //   return null;}

}
