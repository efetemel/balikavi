import 'dart:convert';

import 'package:balikavi/controllers/MainController.dart';
import 'package:balikavi/controllers/WeatherController.dart';
import 'package:balikavi/models/PositionsModel.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get_storage/get_storage.dart';
import 'package:line_icons/line_icon.dart';

import '../utils/AppUtils.dart';

class SearchView extends StatelessWidget {
  SearchView({Key? key}) : super(key: key);

  var searchTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    print(MainController.instance.appSettings.value.positions!.length);
    return Scaffold(
      body: SafeArea(
        child: Container(
          width: double.infinity,
          alignment: Alignment.center,
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 30,vertical: 20),
                padding: const EdgeInsets.symmetric(horizontal: 30,vertical: 20),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    color: AppUtils.boxNightColor
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(child: TextField(
                      style: TextStyle(

                      ),
                      controller: searchTextController,
                      decoration: InputDecoration(
                        suffixIcon:IconButton(onPressed: ()async{
                          await WeatherController.instance.searchLocation(searchTextController.text);
                        }, icon: Icon(Icons.search)),
                        hintText: "Ülke, Şehir arama yap"
                    ))),
                  ]
                ),
              ),
              Container(
                width: double.infinity,
                height: 1,
                color: Colors.grey,
              ),
              Expanded(
                child: Obx(()=>ListView.builder(
                  itemCount: WeatherController.instance.searchResult.value.length,
                  itemBuilder: (_,int pos){
                    var response = WeatherController.instance.searchResult.value[pos];
                    var lat = response["geometry"]["location"]["lat"];
                    var lng = response["geometry"]["location"]["lng"];
                    return ListTile(
                      leading: LineIcon.mapMarker(),
                      title: Text(response["formatted_address"]),
                      trailing: const Text("Ekle"),
                      onTap: ()async{
                        var psModel = PositionsModel.fromJson(
                          {
                            "latitude":lat,
                            "longitude":lng
                          }
                        );
                        WeatherController.instance.addDBLatLong(psModel);
                      },
                    );
                  },
                )),
              )
            ],
          ),
        ),
      ),
    );
  }
}
