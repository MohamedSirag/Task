import 'dart:io';

import 'package:network_info_plus/network_info_plus.dart';

class Wifi {
  Future<void> scanNetwork() async {
    await (NetworkInfo().getWifiIP()).then(
      (ip) async {
        final String subnet = ip.substring(0, ip.lastIndexOf('.'));
        const port = 22;
        for (var i = 0; i < 256; i++) {
          String ip = '$subnet.$i';
          await Socket.connect(ip, port, timeout: Duration(milliseconds: 50))
              .then((socket) async {
            await InternetAddress(socket.address.address)
                .reverse()
                .then((value) {
              print(value.host);
              print(socket.address.address);
            }).catchError((error) {
              print(socket.address.address);
              print('Error: $error');
            });
            socket.destroy();
          }).catchError((error) => null);
        }
      },
    );
    print('Done');
  }
}
