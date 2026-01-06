

import 'package:flutter/material.dart';
import 'package:fv2/providers/NotificationProvider.dart';
import 'package:fv2/providers/PostProvider.dart';
import 'package:fv2/providers/UserProvider.dart';
import 'package:fv2/views/pages/CommunityPage.dart';
import 'package:fv2/views/pages/Disease/DetectionHome/DetectionHomePage.dart';
import 'package:fv2/views/pages/HomePage.dart';
import 'package:fv2/views/pages/components/loading/showCircularDialog.dart';
import 'package:fv2/views/pages/profile/ProfilePage.dart';
import 'package:loader_overlay/loader_overlay.dart';

import 'package:provider/provider.dart';

class WidgetTree extends StatefulWidget {
  // widget tree must in main route
  const WidgetTree({super.key});


  @override
  State<WidgetTree> createState() => _WidgetTreeState();
}

class _WidgetTreeState extends State<WidgetTree> {
  final List<Widget> _pages = [
    LoaderOverlay(child:  Homepage()),
    LoaderOverlay(child:  CommunityPage()),
    DetectionHomePage(),
     LoaderOverlay(child:  ProfilePage()),
     
    // ChangeNotifierProvider(
    //     create: (_) => PostProvider(),
    //     child: LoaderOverlay(child:  Homepage()),
    //   ),
    // ChangeNotifierProvider(
    //     create: (_) => PostProvider(),
    //     child: LoaderOverlay(child:  CommunityPage()),
    //   ),
  ];
  int _currentIndex = 0;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async{
      if (!mounted) return;
      await Provider.of<Userprovider>(context, listen: false).setUserInfo();
    await Provider.of<NotificationProvider>(
        context,
        listen: false,
      ).fetchUnreadCount();
    });
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('FruitGuard'),
        centerTitle: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              showCircularDialog(context);
              bool logoutStatus = await Provider.of<Userprovider>(
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
          Consumer<NotificationProvider>(
            // listen to notification provider to get unread count
            builder: (context, notificationProvider, child) {
              int unreadCount = notificationProvider.unread_count;
              return IconButton(
                // show notification icon with unread count badge
                icon: Stack(
                  children: [
                    Icon(
                      Icons.notifications,
                      color: unreadCount > 0 ? Colors.blue : Colors.white,
                    ),
                    if (unreadCount > 0)
                      Positioned(
                        right: 0,
                        top: 0,
                        child: Container(
                          padding: const EdgeInsets.all(2),
                          decoration: const BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                          constraints: const BoxConstraints(
                            minWidth: 16,
                            minHeight: 16,
                          ),
                          child: Text(
                            '$unreadCount',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                  ],
                ),
                onPressed: () {
                  Navigator.pushNamed(context, '/NotificationPage');
                },
              );
            },
          ), // show notification icon with unread count badge
          SizedBox(width: 20), // Add some spacing at the en
        ],
      ),
      body: SafeArea(
        child: IndexedStack(
          index: _currentIndex,
          children: _pages,
        )
      ),
      // ChangeNotifierProvider<PostProvider>(create: (context) => PostProvider(), child: Homepage()),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home), 
            label: 'Home'),
          BottomNavigationBarItem(
            icon: Icon(Icons.group),
            label: 'Community',
          ),
           BottomNavigationBarItem(
            icon: Icon(Icons.camera), 
            label: 'Scan'),
          BottomNavigationBarItem(
            icon: Icon(Icons.person), 
            label: 'Profile'),
         
        ],
        selectedItemColor: Colors.amber[800],
        onTap: (int index) {
          if(index != 2){
            Provider.of<PostProvider>(context, listen: false).initial();
            Provider.of<PostProvider>(context, listen: false).getTodayPostsDataTesting(); // reload posts when switch tab
          }
          setState(() => _currentIndex = index);
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.pushNamed(context, '/postFormPage');
        },
      ),
    );
  }
}
