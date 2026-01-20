import 'package:flutter/material.dart';
import 'package:fv2/providers/PlantProvider.dart';
import 'package:fv2/views/pages/Disease/Detection/DragonFruitDiseases.dart';
import 'package:fv2/views/pages/components/detection/DetectionRecord.dart';
import 'package:provider/provider.dart';

class DetectionPecordsPage extends StatefulWidget {
  const DetectionPecordsPage({super.key});

  @override
  State<DetectionPecordsPage> createState() => _DetectionPecordsPageState();
}

class _DetectionPecordsPageState extends State<DetectionPecordsPage> {
  final dragonFruitDiseases = DragonFruitDiseases.dragonFruitDiseases;
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // wait for widgets to be built then fetch
      Provider.of<PlantProvider>(context, listen: false).displayPlant(context);
    });
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Detection Records'),
          centerTitle: true,
          leading: BackButton(
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body:  SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
             
              SizedBox(height: 20,),
                Selector<PlantProvider, List>(
                              selector: (_, plantProvider) => plantProvider.plants,
                              builder: (context, recentPlants, child) {
                                if (recentPlants.isEmpty) {
                                  return Text("No recent detection records.");
                                }
                                return ListView.separated(
                                  separatorBuilder: (context, index) => const SizedBox(height: 10),
                                  shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
                                  scrollDirection: Axis.vertical,
                                  itemCount: recentPlants.length,
                                  itemBuilder: (context, index) {
                                    return DetectionRecord(
                                    Id: recentPlants[index].id,
                                    disease: dragonFruitDiseases[recentPlants[index].diseaseId]['name'],
                                    dateTime: recentPlants[index].created_at,
                                    image: recentPlants[index].image,
                                    icon: Icons.delete,
                                    confidence: recentPlants[index].confidence,
                                    diseaseId: recentPlants[index].diseaseId,
                                  );
                                  },
                                );
                              },
                            ),
                          
              
            ],
          ),
        ),
      ),
    );
  }
}