import 'package:balikavi/controllers/MainController.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:settings_ui/settings_ui.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      child:Obx(()=> SettingsList(
        darkTheme: SettingsThemeData().copyWith(settingsListBackground: Colors.grey.shade900),
        applicationType: ApplicationType.both,
        sections: [
          SettingsSection(
            title: Text('Genel ayarlar'),
            tiles: <SettingsTile>[
              SettingsTile.navigation(
                leading: Icon(Icons.language),
                title: Text('Konum izni'),
                value: Text(MainController.instance.locationPerm.value ? "Konum izni verildi" : "Konum izni verilmedi. İzin vemrek için tıkla."),
                onPressed: MainController.instance.locationPerm.value == false ? (_)async{
                  await MainController.instance.determinePosition();
                } : null,
              ),
            ],
          ),
        ],
      )),
    );
  }
}
