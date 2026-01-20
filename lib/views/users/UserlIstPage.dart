import 'package:flutter/material.dart';
import 'package:fv2/models/User.dart';
import 'package:fv2/providers/UserProvider.dart';
import 'package:fv2/views/pages/components/ConfirmDialog.dart';
import 'package:fv2/views/users/UserEditPage.dart';
import 'package:provider/provider.dart';

class Userlistpage extends StatefulWidget {
  const Userlistpage({super.key});

  @override
  State<Userlistpage> createState() => _UserlistpageState();
}

class _UserlistpageState extends State<Userlistpage> {
  TextEditingController searchController = TextEditingController();
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      // wait for widgets to be built then fetch
      Provider.of<UserProvider>(context, listen: false).loadUsers();
    });
  }

  @override
  Widget build(BuildContext context) {
    UserProvider userProvider = Provider.of<UserProvider>(context, listen:false);
    final user = userProvider.getUser;
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text("User Management"),
          centerTitle: true,
          leading: BackButton(
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: SafeArea(
          child: Container(
            padding: EdgeInsets.all(16.0),
            width: double.infinity,
            child:
             SingleChildScrollView(
              child: Column(
                children: [
                  TextField(
                    controller: searchController,
                    decoration: InputDecoration(
                      hintText: 'Search by id',
                      suffixIcon: IconButton(
                        icon: Icon(Icons.search),
                        onPressed: () async{
                         int? searchUserID = int.tryParse(searchController.text);
                          await Provider.of<UserProvider>(context, listen: false).searchUser(searchUserID, context);                          
                          // call API here
                        },
                      ),
                    ),
                    onChanged: (value) {
                      if (value.isEmpty) {
                        Provider.of<UserProvider>(context, listen: false).loadUsers();
                      }
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Users List"), //title
                        Spacer(),
                        IconButton(
                          onPressed: () {
                            Navigator.pushNamed(context, "/UserAddPage");
                          },
                          icon: Icon(Icons.add),
                        ), //button to add new user
                      ],
                    ),
                  ),
                  Divider(),
                  Selector<UserProvider, bool>(
                    // loading indicator
                    selector: (_, userProvider) => userProvider.isLoading,
                    builder: (context, isLoading, child) {
                      return isLoading
                          ? CircularProgressIndicator()
                          : SizedBox.shrink();
                    },
                  ),
                  Selector<UserProvider, List<User?>>(
                    selector: (_, userProvider) => userProvider.users,
                    builder: (context, users, child) {
                      return ListView.builder(
                        shrinkWrap: true, // let it fit inside parent
                        physics: const NeverScrollableScrollPhysics(),
                        // disable scroll// let it fit inside parent
                        itemCount: users.length,
                        itemBuilder: (_, index) {
                          return ListTile(
                            leading: users[index]?.profile_Image != null ? CircleAvatar(
                              backgroundImage:
                               NetworkImage(
                
                                    users[index]!.profile_Image!,
                                
                              ),
                            ):Icon( Icons.person, color: const Color.fromARGB(255, 113, 133, 136)),
                            title: Text(
                              "ID: ${users[index]?.id}\nName: ${users[index]?.name} \n Role: ${users[index]?.role}",
                            ),
                            subtitle: Text("Gmail: ${users[index]?.email}"),
                            trailing: PopupMenuButton<String>(
                              onSelected: (String value) {
                                // Handle menu item selection
                                if (value == 'edit') {
                                  print("Edit user");
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          UserEditPage(user: users[index]),
                                    ),
                                  );
                                  // Navigate to edit user page
                                } else if (value == 'delete') {
                                  confirmDialog(context,'Are you sure you want to delete this user?').then(
                                    (value) {
                    
                                      if (value == true) {
                                      Provider.of<UserProvider>(context,listen: false).deleteUser(users[index]!.id!, context);
                                    }

                                    }
                                  );
                                  // Show confirmation dialog and delete user
                                }
                              },
                              itemBuilder: (BuildContext context) =>
                                  <PopupMenuEntry<String>>[
                                     if(user.role == 'admin')
                                    const PopupMenuItem<String>(
                                      value: 'edit',
                                      child: Text('Edit User'),
                                    ),
                                   
                                    const PopupMenuItem<String>(
                                      value: 'delete',
                                      child: Text('Delete User'),
                                    ),
                                  ],
                            ),
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          
          ),
        ),
      ),
    );
  }
}
