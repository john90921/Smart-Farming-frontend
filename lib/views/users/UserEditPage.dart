import 'package:flutter/material.dart';
import 'package:fv2/models/User.dart';
import 'package:fv2/providers/UserProvider.dart';
import 'package:fv2/utils/message_helper.dart';
import 'package:fv2/views/pages/components/loading/showCircularDialog.dart';
import 'package:provider/provider.dart';

class UserEditPage extends StatefulWidget {
  const UserEditPage({super.key, required this.user});

  final User? user;

  @override
  State<UserEditPage> createState() => _UserEditPageState();
}

class _UserEditPageState extends State<UserEditPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  String? selectedRole;
  final List<String> roles = ['worker', 'manager'];
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    _emailController.text = widget.user?.email ?? '';
    _nameController.text = widget.user?.name ?? '';
    selectedRole = widget.user?.role;
    // TODO: implement initState
    super.initState();

  }

  @override
  void dispose() {
    _emailController.dispose();
    _nameController.dispose();
    super.dispose();
  }
   void submitForm() async{
    if (_formKey.currentState!.validate()) {
      final email = _emailController.text;
      final name = _nameController.text;
      final role = selectedRole;

      final provider = Provider.of<UserProvider>(context, listen: false);
     bool? status =  await  provider.editUser(widget.user?.id, name, email, role);
     _formKey.currentState!.reset();
      if(status == true){
        showMessage(context: context, message: "User edited successfully", isError: false);
      }
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Register"),
        leading: const BackButton(),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Center(
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(

                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                    const SizedBox(height: 20),
                Selector<UserProvider, bool>(
                  selector: (_, userProvider) => userProvider.isLoading,
                  builder: (context, isLoading, child) {
                    return isLoading ? CircularProgressIndicator() : SizedBox.shrink();
                    
                  },
                ),
                  const Text(
                    "Register",
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 40),

                  // Name Field
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: "Name",
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Name is required';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),

                  // Email Field
                  TextFormField(
                    controller: _emailController,
                    decoration: const InputDecoration(
                      labelText: "Email",
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Email is required';
                      }
                      final emailRegExp = RegExp(r'^[^@]+@[^@]+\.[^@]+');
                      if (!emailRegExp.hasMatch(value)) {
                        return 'Enter a valid email';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),

                  // Password Field
                  DropdownButton<String>(
                    value: selectedRole,
                    hint: Text('Select Role'),
                    items: roles.map((String role) {
                      return DropdownMenuItem<String>(
                        value: role,
                        child: Text(role),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedRole = newValue;
                      });
                    },
                  ),

                  const SizedBox(height: 30),

                  // Register Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: submitForm,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: const Text("Register"),
                    ),
                  ),

              
                // Selector<UserProvider, bool>(
                //   selector: (_, userProvider) => userProvider.isSuccess,
                //   builder: (context, isSuccess, child) {
                //     if(isSuccess){
                //       showMessage(context: context, message: "User added successfully", isError: false);
                //     }
                //     return SizedBox.shrink();
                //   },
                // ),
                Selector<UserProvider, String?>(
                  selector: (_, userProvider) => userProvider.error,
                  builder: (context, error, child) {
                    if(error != null){
                      showMessage(context: context, message: error, isError: true);
                    }
                    return SizedBox.shrink();
                    
                  },
                ),
                //  Selector<UserProvider, bool?>(
                //   selector: (_, userProvider) => userProvider.isLoading,
                //   builder: (context, isLoading, child) {
                //     if(isLoading == true){
                //       showCircularDialog(context);
                //     } else {
                //       Navigator.of(context, rootNavigator: true).pop();
                //     }
                //     return SizedBox.shrink();
                    
                //   },
                // ),

                  // Back to Login
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
