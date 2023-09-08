import 'dart:async';
import 'dart:convert';
import 'package:call_log/call_log.dart';
import 'package:connectivity/connectivity.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:get/get.dart';
import 'package:vizzve_micro_seva/config/config.dart';
import 'package:vizzve_micro_seva/constants/constant.dart';
import 'package:vizzve_micro_seva/helper/preferences/local_data_source.dart';
import 'package:vizzve_micro_seva/helper/preferences/local_data_source_impl.dart';
import 'package:vizzve_micro_seva/models/call_log.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart' show kIsWeb;

class DashboardController extends GetxController {
  var tabIndex = 0;
  LocalDataSource _localDataSource =  new LocalDataSourceImpl();
  StreamSubscription<ConnectivityResult> ?subscription;
  bool isInternetOn = true;

  void changeTabIndex(int index) {
    tabIndex = index;
    update();
  }

  Future<bool> logout() async {
    if(!kIsWeb) {
      await GoogleSignIn().signOut();
    }
    await _localDataSource.deleteAllData();
    await _localDataSource.writeSecureData('isPermission', PrefKeyConst.isUserDevicePermission);
    return true;
  }

  Future<void> checkCallLogStatus() async {
    var status = await _localDataSource.readSecureData('callLog');
    if(status == PrefKeyConst.isUserCallLog){
      print("Call log already save");
    } else {
      await updateCallLog();
    }
  }

  int countEntries = 0;
  Future<void> updateCallLog() async {
    var data = await _localDataSource.readSecureData("userToken");
    var token = "JWT $data";
    var header = {
      'Authorization': token,
      'Content-type': 'application/json',
    };
    Iterable<CallLogEntry> entries = await CallLog.get();
    List<CallLogModel> users = [];
    for (int i = 0; i < entries.length; i++) {
      CallLogModel _callLog = CallLogModel();
      _callLog.number = (entries.elementAt(i).number.isBlank)! ? "" : entries.elementAt(i).number;
      _callLog.name = (entries.elementAt(i).name.isBlank)! ? "" : entries.elementAt(i).name;
      _callLog.cachedMatchedNumber = entries.elementAt(i).cachedMatchedNumber;
      _callLog.cachedNumberLabel = entries.elementAt(i).cachedNumberLabel;
      _callLog.cachedNumberType = entries.elementAt(i).cachedNumberType;
      _callLog.callType = entries.elementAt(i).callType.toString();
      _callLog.duration = entries.elementAt(i).duration;
      _callLog.formattedNumber = entries.elementAt(i).formattedNumber;
      _callLog.phoneAccountId = entries.elementAt(i).phoneAccountId;
      _callLog.simDisplayName = entries.elementAt(i).simDisplayName;
      _callLog.timestamp = entries.elementAt(i).timestamp;
      users.add(_callLog);
      countEntries++;
    }
    var callLogData = {
      "call_log": users
    };
    if(countEntries == entries.length) {
      var url = Uri.parse(Config.url + Config.saveCallLogs);
      var result = await http.post(
          url, body: jsonEncode(callLogData), headers: header);
      if (result.statusCode == 200) {
        _localDataSource.writeSecureData("callLog", PrefKeyConst.isUserCallLog);
      } else {
        _localDataSource.writeSecureData("callLog", "call_log_not_save");
      }
    }
  }

  @override
  void onInit() {
    subscription = Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      switch (result) {
        case ConnectivityResult.wifi:
        case ConnectivityResult.mobile:
          isInternetOn = true;
          update();
          break;
        case ConnectivityResult.none:
          isInternetOn = false;
          update();
          break;
        default:
          isInternetOn = true;
          update();
          break;
      }
    });
    if(!kIsWeb) {
      checkCallLogStatus();
    }
    super.onInit();
  }

  @override
  void onClose() {
    subscription?.cancel();
    super.onClose();
  }
}
