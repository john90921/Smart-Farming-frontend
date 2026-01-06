import 'package:flutter/material.dart';
import 'package:fv2/views/pages/components/detection/DetectionRecord.dart';

class DetectionPecordsPage extends StatefulWidget {
  const DetectionPecordsPage({super.key});

  @override
  State<DetectionPecordsPage> createState() => _DetectionPecordsPageState();
}

class _DetectionPecordsPageState extends State<DetectionPecordsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detection Records'),
        centerTitle: true,
        leading: BackButton(
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body:  SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Row(
                children: [
                Expanded(
                  child: ListTile(
                    leading: IconButton(
                      onPressed: (){
                      // postProvider.applySearch(searchController.text);
              
                    }, icon:Icon(Icons.search, color: Colors.blueGrey)),
                    title: TextField(
            
                      decoration: InputDecoration(
                        hintText: 'Search',
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
                IconButton(onPressed: () async {
                  
                }, icon: Icon(Icons.tune, color: Colors.blueGrey))
              ],),
              ),
              SizedBox(height: 20,),
              DetectionRecord(icon: Icons.delete,)
            ],
          ),
        ),
      ),
    );
  }
}