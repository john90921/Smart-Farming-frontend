import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fv2/models/Plant.dart';
import 'package:fv2/providers/PlantProvider.dart';
import 'package:fv2/views/pages/Disease/Detection/PlantDisease.dart';
import 'package:fv2/views/pages/components/ConfirmDialog.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';


class DetectionRecord extends StatelessWidget {
  const DetectionRecord({super.key, required this.Id, required this.icon, required this.disease, required this.dateTime, required this.image, required this.confidence,required this.diseaseId});
  final int Id;
  final IconData? icon;
  final String? disease;
  final DateTime dateTime;
  final String image;
  final double? confidence;
  final int diseaseId;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(8.0),
      ),
      padding: const EdgeInsets.all(5.0),
      child: ListTile(
        leading: CachedNetworkImage(
  imageUrl:image,
  placeholder: (context, url) {
    return const CircularProgressIndicator();
  },
  errorWidget: (context, url, error) {
    return const Icon(Icons.broken_image);
  },
),
        title: disease !="Healthy" ? Text('Disease : $disease') : Text('Status :$disease'),
        subtitle: Text(DateFormat('dd MMM yyyy, hh:mm a').format(dateTime)),
        trailing: IconButton(icon: Icon(icon), color: Colors.grey, onPressed: () {
         Future<bool?> status= confirmDialog(context,'Are you sure you want to delete this record?');
          status.then((value) {
            if(value == true){
             context.read<PlantProvider>().deletePlant(Id, context);
            }
          });
        }),
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => PlantDisease(
            diseaseId: diseaseId,
            confidence: confidence,
            imageUrl: image,
          )));
        },
      ),
    );
  }
}
