import 'dart:ffi';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:task/constants/ConstSize.dart';
import 'package:task/data/Api.dart';
import 'package:task/data/services/Wifi.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:network_info_plus/network_info_plus.dart';
import 'package:wifi_iot/wifi_iot.dart';
import 'WebView.dart';

class Settings extends StatefulWidget {
  const Settings({Key key}) : super(key: key);

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  String _connectionStatus = 'Unknown';
  final NetworkInfo _networkInfo = NetworkInfo();
  List<String> listOfWifi = [];
  List<String> listOfBluetooth = [];
  @override
  void initState() {
    super.initState();
    _initNetworkInfo();
    _intitBlueTooth();
  }

  TextEditingController textEditingController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    //Wifi().scanNetwork();
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("task"),
      ),
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              margin: EdgeInsets.symmetric(
                  vertical: scrnH(context) * 0.01,
                  horizontal: scrnW(context) * 0.1),
              child: TextField(
                controller: textEditingController,
                decoration: InputDecoration(
                  hintText: (Api.ApiVar.isNotEmpty)
                      ? Api.ApiVar
                      : "Enter API URL ... ",
                  hintStyle: TextStyle(
                    color: Colors.purple,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                onChanged: (value) {
                  Api.ApiVar = textEditingController.text;
                },
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (BuildContext context) {
                  return WebViewExample();
                }));
              },
              child: Container(
                width: MediaQuery.of(context).size.width * 0.3,
                height: MediaQuery.of(context).size.height * 0.058,
                margin: EdgeInsets.symmetric(
                    vertical: scrnH(context) * 0.01,
                    horizontal: scrnW(context) * 0.2),
                color: Colors.blue,
                child: Container(
                    alignment: Alignment.center, child: Text("Open link")),
              ),
            ),
            DropdownButton<String>(
              items: listOfWifi.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              hint: Text("list Of Wifi devices"),
              onChanged: (_) {},
            ),
            DropdownButton<String>(
              items: listOfBluetooth.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              hint: Text("list Of Bluetooth devices"),
              onChanged: (_) {},
            )
          ],
        ),
      ),
    );
  }

  Future<Void> _intitBlueTooth() async {
    FlutterBlue flutterBlue = FlutterBlue.instance;
    // Start scanning
    flutterBlue.startScan(timeout: Duration(seconds: 4));

// Listen to scan results
    var subscription = flutterBlue.scanResults.listen((results) {
      // do something with scan results
      for (ScanResult r in results) {
        listOfBluetooth.add('${r.device.name}:+${r.device.id}+ ${r.rssi}');
        print('${r.device.name} found! rssi: ${r.rssi}');
        setState(() {});
      }
    });

// Stop scanning
    flutterBlue.stopScan();
  }

  Future<void> _initNetworkInfo() async {
    final wifis = await WiFiForIoTPlugin.loadWifiList();
    _connectionStatus = "${wifis.map((e) => e.ssid).toList()}";
    listOfWifi = wifis.map((e) => e.ssid).toList();
    print("${wifis.map((e) => e.ssid).toList()}" + "hooooopa");
    /*  String wifiName,
        wifiBSSID,
        wifiIPv4,
        wifiIPv6,
        wifiGatewayIP,
        wifiBroadcast,
        wifiSubmask;

    try {
      if (Platform.isIOS) {
        var status = await _networkInfo.getLocationServiceAuthorization();
        if (status == LocationAuthorizationStatus.notDetermined) {
          status = await _networkInfo.requestLocationServiceAuthorization();
        }
        if (status == LocationAuthorizationStatus.authorizedAlways ||
            status == LocationAuthorizationStatus.authorizedWhenInUse) {
          wifiName = await _networkInfo.getWifiName();
        } else {
          wifiName = await _networkInfo.getWifiName();
        }
      } else {
        wifiName = await _networkInfo.getWifiName();
      }
    } on PlatformException catch (e) {
      print('Failed to get Wifi Name' + e.toString());
      wifiName = 'Failed to get Wifi Name';
    }

    try {
      if (Platform.isIOS) {
        var status = await _networkInfo.getLocationServiceAuthorization();
        if (status == LocationAuthorizationStatus.notDetermined) {
          status = await _networkInfo.requestLocationServiceAuthorization();
        }
        if (status == LocationAuthorizationStatus.authorizedAlways ||
            status == LocationAuthorizationStatus.authorizedWhenInUse) {
          wifiBSSID = await _networkInfo.getWifiBSSID();
        } else {
          wifiBSSID = await _networkInfo.getWifiBSSID();
        }
      } else {
        wifiBSSID = await _networkInfo.getWifiBSSID();
      }
    } on PlatformException catch (e) {
      print('Failed to get Wifi BSSID' + e.toString());
      wifiBSSID = 'Failed to get Wifi BSSID';
    }

    try {
      wifiIPv4 = await _networkInfo.getWifiIP();
    } on PlatformException catch (e) {
      print('Failed to get Wifi IPv4' + e.toString());
      wifiIPv4 = 'Failed to get Wifi IPv4';
    }

    try {
      wifiIPv6 = await _networkInfo.getWifiIPv6();
    } on PlatformException catch (e) {
      print('Failed to get Wifi IPv6' + e.toString());
      wifiIPv6 = 'Failed to get Wifi IPv6';
    }

    try {
      wifiSubmask = await _networkInfo.getWifiSubmask();
    } on PlatformException catch (e) {
      print('Failed to get Wifi submask address' + e.toString());
      wifiSubmask = 'Failed to get Wifi submask address';
    }

    try {
      wifiBroadcast = await _networkInfo.getWifiBroadcast();
    } on PlatformException catch (e) {
      print('Failed to get Wifi broadcast' + e.toString());
      wifiBroadcast = 'Failed to get Wifi broadcast';
    }

    try {
      wifiGatewayIP = await _networkInfo.getWifiGatewayIP();
    } on PlatformException catch (e) {
      print('Failed to get Wifi gateway address' + e.toString());
      wifiGatewayIP = 'Failed to get Wifi gateway address';
    }

    try {
      wifiSubmask = await _networkInfo.getWifiSubmask();
    } on PlatformException catch (e) {
      print('Failed to get Wifi submask' + e.toString());
      wifiSubmask = 'Failed to get Wifi submask';
    }
*/
    setState(() {
      /*  _connectionStatus = 'Wifi Name: $wifiName\n'
          'Wifi BSSID: $wifiBSSID\n'
          'Wifi IPv4: $wifiIPv4\n'
          'Wifi IPv6: $wifiIPv6\n'
          'Wifi Broadcast: $wifiBroadcast\n'
          'Wifi Gateway: $wifiGatewayIP\n'
          'Wifi Submask: $wifiSubmask\n';*/
    });
  }
  //);
}
