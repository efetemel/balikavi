import 'package:balikavi/controllers/MainController.dart';
import 'package:balikavi/controllers/WeatherController.dart';
import 'package:balikavi/models/PositionsModel.dart';
import 'package:balikavi/utils/AppUtils.dart';
import 'package:balikavi/views/SearchView.dart';
import 'package:balikavi/views/WeatherView.dart';
import 'package:balikavi/widgets/WeatherCard.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:line_icons/line_icon.dart';

class LocationView extends StatelessWidget {
  const LocationView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Konumlarım"),
        leading: AppUtils.getMenu(),
        actions: [
          IconButton(onPressed: (){
            Get.to(()=>SearchView());
          }, icon: Icon(Icons.add))
        ],
      ),
      body: Container(
        width: double.infinity,
        alignment: Alignment.center,
        child: Obx(()=>ListView.builder(
          itemCount: MainController.instance.appSettings.value.positions!.length,
          itemBuilder: (_,int pos){
            var placesData = MainController.instance.placesData.value.reversed.toList()[pos];
            var position = MainController.instance.appSettings.value.positions!.reversed.toList()[pos];
            return ListTile(
              title: Text("${placesData.subLocality!} / ${placesData.administrativeArea!}"),
              leading: LineIcon.mapMarker(),
              onTap: (){
                Get.defaultDialog(
                  title: "Konum işlemleri",
                  middleText: "Seçili konumu silmek istiyor musunuz?",
                  confirm: ElevatedButton(onPressed: ()async{
                    await WeatherController.instance.dellDbLatLong(pos,position,placesData);
                    Get.back(closeOverlays: true);
                  }, child: Text("Sil")),
                  cancel: ElevatedButton(onPressed: (){Get.back();}, child: Text("İptal")),
                );
              },
            );
          },
        )),
      ),
    );
  }
}
