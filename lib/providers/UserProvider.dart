import 'dart:io';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fv2/api/ApiHelper.dart';
import 'package:fv2/models/User.dart';
import 'package:fv2/services/ImageService.dart';
import 'package:fv2/services/UserService.dart';
import 'package:fv2/token/TokenManager.dart';
import 'package:fv2/utils/message_helper.dart';
import 'package:fv2/views/pages/components/exception/loginException.dart';
import 'package:fv2/views/pages/components/loading/hideLoading.dart';
import 'package:fv2/views/pages/components/loading/showCircularDialog.dart';
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
    ImageService imageService = ImageService();

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
Future<void> selectUser(int? userID) async {
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

  Future<bool?> addUser(String name, String email, String? role,String? password,  BuildContext context) async{
 
    isLoading = true;
    error = null;
    isSuccess = false;
    
    notifyListeners();

    try{
      await _userService.addUser(name, email, role,password);
      await loadUsers();
      if (!context.mounted) return null;
         ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('User added successfully'),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return true;
    }
    on LoginException{
      if (!context.mounted) return null;
         ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('The email address is already in use by another account.'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
    catch(e){
       if (!context.mounted) return null;
         ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
    isLoading = false;
    notifyListeners();// check have error or not
    return false;
  }
  Future<bool?> editProfile({int? profileId, String? name, String? phone, File? newimage, bool? isDeletedImage}) async{
    error = null;
    isSuccess = false;
    notifyListeners();
  
    try{
      if (newimage != null){
        newimage = await imageService.compressFile(newimage);
      }
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

  Future<void> deleteUser(int? userID, BuildContext context) async{
    isLoading = true;
    error = null;
    isSuccess = false;
    notifyListeners();
    showCircularDialog(context);
    try{
      await _userService.DeleteUser(userID);
      await loadUsers();
       if (!context.mounted) return;
         ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('User deleted successfully'),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
    catch(e){
      error= e.toString();
       if (!context.mounted) return;
         ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error deleting user'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
    finally{
      if (!context.mounted) return;
      hideLoading(context);
    }
    
    isLoading = false;
    notifyListeners();
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

  Future<void> searchUser(int? id,BuildContext context) async{
    isLoading = true;
    error = null;
    isSuccess = false;
    notifyListeners();
    try{
      users = await _userService.searchUser(id);
      print("searched users length: ${users.length}");
      if(users.isEmpty){
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('No user found'),
            backgroundColor: Colors.orange,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
    catch (e){
      error = e.toString();
      print("error searching users: $error");
    }
    if(error == null){
      isSuccess = true;
    }
    isLoading = false;
    notifyListeners();
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
