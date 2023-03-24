import 'package:get/get.dart';
import 'package:socket_io_client/socket_io_client.dart';

class SocketController extends GetxController{
  static SocketController instance = Get.find();


  static var socket = IO.io('https://burly-clover-cabin.glitch.me/',
      OptionBuilder()
          .disableAutoConnect()
          .setTransports(['websocket'])
          .setExtraHeaders({'foo': 'bar'})
          .setQuery({"token":"waoww"}).build()).obs;

}