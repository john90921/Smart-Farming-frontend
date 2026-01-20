// import 'package:flutter/material.dart';
// import 'package:fv2/views/pages/Disease/Detection/Solution.dart';

// // Assume DiseaseModel, Symptom, Treatment, and TreatmentRecommendations classes are already defined

// class DiseaseDetailPage extends StatelessWidget {
//   final int diseaseIndex;

//   const DiseaseDetailPage({super.key, required this.diseaseIndex});
//   static List<Map<String, dynamic>> dragonFruitDiseases = [
//   {
//     "name": "Anthracnose",
//     "symptoms": [
//       "Small dark brown or black sunken spots on stems or fruits",
//       "Lesions enlarge and merge under humid conditions",
//       "Affected tissue becomes dry and cracked"
//     ],
//     "solutions": [
//       "Remove and destroy infected plant parts",
//       "Apply copper-based or Mancozeb fungicides",
//       "Improve air circulation and avoid overhead watering"
//     ],
//     "references": [
//       "FAO Plant Disease Database",
//       "Khethari Sustainable Disease Management for Dragon Fruit",
//       "CABI Crop Protection Compendium"
//     ]
//   },
//   {
//     "name": "Brown_Stem_Spot",
//     "symptoms": [
//       "Brown circular or irregular spots on stems",
//       "Spots may have yellow halos",
//       "Stem surface becomes rough or corky"
//     ],
//     "solutions": [
//       "Prune infected stems early",
//       "Apply copper oxychloride fungicides",
//       "Maintain field sanitation and proper spacing"
//     ],
//     "references": [
//       "Department of Agriculture Malaysia (DOA)",
//       "Tridge Agricultural Disease Reports"
//     ]
//   },
//   {
//     "name": "Gray_Blight",
//     "symptoms": [
//       "Grayish or pale lesions on stem surface",
//       "Lesions expand with black fungal fruiting bodies",
//       "Stem tissue weakens and dries out"
//     ],
//     "solutions": [
//       "Remove infected stems immediately",
//       "Apply broad-spectrum fungicides",
//       "Reduce humidity and improve drainage"
//     ],
//     "references": [
//       "Scientific Reports – Diaporthe spp. on Pitaya",
//       "CABI Plantwise Knowledge Bank"
//     ]
//   },
//   {
//     "name": "Healthy",
//     "symptoms": [
//       "Bright green stems with smooth surface",
//       "No visible spots, lesions, or discoloration",
//       "Firm stem texture and active growth"
//     ],
//     "solutions": [
//       "Maintain balanced fertilization",
//       "Ensure proper irrigation and drainage",
//       "Regular monitoring to detect early disease symptoms"
//     ],
//     "references": [
//       "FAO Good Agricultural Practices",
//       "DOA Malaysia Dragon Fruit Cultivation Guide"
//     ]
//   },
//   {
//     "name": "Soft_Rot",
//     "symptoms": [
//       "Water-soaked soft areas on stems",
//       "Rapid tissue breakdown with foul odor",
//       "Stem collapses in severe cases"
//     ],
//     "solutions": [
//       "Remove infected plants immediately",
//       "Avoid excessive watering and improve drainage",
//       "Disinfect tools and avoid stem injuries"
//     ],
//     "references": [
//       "FAO Post-Harvest Disease Manual",
//       "PlantVillage Disease Database"
//     ]
//   },
//   {
//     "name": "Stem_Canker",
//     "symptoms": [
//       "Sunken, dry brown or black canker lesions",
//       "Cracked stem surface around infected area",
//       "Reduced nutrient transport causing wilting"
//     ],
//     "solutions": [
//       "Prune and destroy affected stem sections",
//       "Apply copper fungicides to wounds",
//       "Sterilize pruning tools after each cut"
//     ],
//     "references": [
//       "CABI Crop Protection Compendium",
//       "Imp.World Dragon Fruit Disease Guide"
//     ]
//   }
// ];
 
//   @override
// Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(disease.diseaseName),
//         centerTitle: true,
//          leading: BackButton(
//           onPressed: (){
//             if (context.mounted) {
//   Navigator.pop(context);
// }
//           },
//         ),
        
//          actions: [TextButton(
//           child: const Text('Done', style: TextStyle(color: Colors.blue)),
//           onPressed: () {
//             if (context.mounted) {
//               Navigator.pushNamedAndRemoveUntil(context, "/widgettree", (route) => false);
//             }
//           },
//         ),]
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // 🧩 Basic info
//             Text(
//               "Affected Crop: ${disease.affectedCrop}",
//               style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 8),
//             Text("Confidence: ${disease.diagnosisConfidence}"),
//             const SizedBox(height: 16),

//             // 🌿 Symptoms Section
//             const Text(
//               "Symptoms",
//               style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//             ),
//             const Divider(),
//             ...disease.symptoms.map((symptom) => Card(
//                   margin: const EdgeInsets.symmetric(vertical: 6),
//                   child: ListTile(
//                     title: Text(symptom.symptomName),
//                     subtitle: Text(symptom.explanation),
//                   ),
//                 )),

//             const SizedBox(height: 16),

//             // 💊 Treatment Section
//             const Text(
//               "Treatment Recommendations",
//               style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//             ),
//             const Divider(),

//             // Organic / Biological
//             _buildTreatmentCategory(
//               "Organic / Biological",
//               disease.treatmentRecommendations.organicBiological,
//             ),

//             // Chemical
//             _buildTreatmentCategory(
//               "Chemical",
//               disease.treatmentRecommendations.chemical,
//             ),

//             // Cultural Control
//             _buildTreatmentCategory(
//               "Cultural Control",
//               disease.treatmentRecommendations.culturalControl,
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   // Helper widget to display each treatment category
//   Widget _buildTreatmentCategory(String title, List<Treatment> treatments) {
//     if (treatments.isEmpty) return const SizedBox.shrink();

//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const SizedBox(height: 8),
//         Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
//         const SizedBox(height: 8),
//         ...treatments.map((t) => Card(
//               margin: const EdgeInsets.symmetric(vertical: 6),
//               child: ListTile(
//                 title: Text(t.treatmentName),
//                 subtitle: Text(t.explanation),
//               ),
//             )),
//       ],
//     );
//   }
// }
