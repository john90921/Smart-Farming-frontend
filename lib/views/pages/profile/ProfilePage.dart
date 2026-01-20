import 'package:flutter/material.dart';
import 'package:fv2/models/Filter.dart';
import 'package:fv2/models/User.dart';
import 'package:fv2/providers/PostProvider.dart';
import 'package:fv2/providers/UserProvider.dart';
import 'package:fv2/views/pages/components/ConfirmDialog.dart';
import 'package:fv2/views/pages/components/loading/showCircularDialog.dart';
import 'package:fv2/views/pages/profile/ProfileEditPage.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  // final String name;
  // final String imageUrl;
  // final String description;

  const ProfilePage({
    super.key,
    // required this.name,
    // required this.imageUrl,
    // required this.description,
  });

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!mounted) return;
      await Provider.of<UserProvider>(context, listen: false).setUserInfo();
    });
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // User user = Provider.of<Userprovider>(context,listen: false).getUser;
    return Scaffold(
      appBar: AppBar(title: const Text('Profile'), centerTitle: true),
      body: SafeArea(
        child: Consumer<UserProvider>(
          builder: (context, userProvider, child) {
            User user = userProvider.getUser;
            return Padding(
              padding: const EdgeInsets.all(16),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    user.profile_Image != "" && user.profile_Image != null
                        ? CircleAvatar(
                            radius: 60,
                            backgroundImage: NetworkImage(user.profile_Image!),
                          )
                        : const CircleAvatar(
                            radius: 60,
                            backgroundImage: AssetImage('assets/profile1.jpeg'),
                          ),
                    const SizedBox(height: 16),
                        
                    // Name
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Name: ${user.name}",
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                        
                        const SizedBox(height: 8),
                        Text("Role: ${user.role}", style: const TextStyle(fontSize: 15)),
                        // Description
                        Text(
                          "ID: ${user.profile_id}",
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontSize: 15),
                        ),
                        Text(
                          "Email: ${user.email}",
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontSize: 15),
                        ),
                        Text(
                          "Phone Number : ${user.phone ?? ''}",
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontSize: 15),
                        ),
                        const SizedBox(height: 16),
                      ],
                    ),
                    // Edit Profile Button
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ProfileEditPage(
                              profileId: user.profile_id,
                              name: user.name,
                              imageUrl: user.profile_Image,
                              phone: user.phone,
                              email: user.email,
                            ),
                          ),
                        );
                      },
                      child: const Text('Edit Profile'),
                    ),
                    const SizedBox(height: 16),
                    // Logout Button
                    ListTile(
                      style: ListTileStyle.drawer,
                      leading: const Icon(Icons.history),
                      title: const Text('Post History'),
                      trailing: const Icon(Icons.arrow_forward_ios),
                      onTap: () async  {
                        // Provider.of<PostProvider>(context, listen: false).setPostListEmpty();
                        final userId = Provider.of<UserProvider>(
                          context,
                          listen: false,
                        ).getUser.id;
                        Provider.of<PostProvider>(
                          context,
                          listen: false,
                        ).setCurrentFilter(
                          Filter.owner(
                            userId: userId,
                            date: "year",
                            sortBy: "latest",
                            searhInput: null,
                          ),
                        );
                        await Provider.of<PostProvider>(
                          context,
                          listen: false,
                        ).getTodayPostsDataTesting();
                        Navigator.pushNamed(context, '/postHistory');
                      },
                    ),
                    ListTile(
                      style: ListTileStyle.drawer,
                      leading: const Icon(Icons.logout),
                      title: const Text('Logout'),
                      trailing: const Icon(Icons.arrow_forward_ios),
                      onTap: () async {
             bool? confirm = await confirmDialog(context, 'Are you sure you want to logout?');
             if (confirm != true) {
               return;
            }
              showCircularDialog(context);

              bool logoutStatus = await Provider.of<UserProvider>(
                context,
                listen: false,
              ).logout(context);
              Navigator.pop(context); // close loading dialog
              if (!mounted) return; 
              if (logoutStatus) {
                if (context.mounted) {
                  Navigator.of(context).pushReplacementNamed('/login');
                }
              } else {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Logout failed")),
                  );
                }
              }
            
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
