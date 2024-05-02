import 'dart:convert';

import 'package:flutter/material.dart';

class AuthModel extends ChangeNotifier {
  bool _isLogin = false;
  Map<String, dynamic> user = {}; //update user details when login
  Map<String, dynamic> appointment =
      {}; //update upcoming appointment when login
  List<Map<String, dynamic>> favDoc = []; //get latest favorite doctor
  List<dynamic> _fav = []; //get all fav doctor id in list

  bool get isLogin {
    return _isLogin;
  }

  List<dynamic> get getFav {
    return _fav;
  }

  Map<String, dynamic> get getUser {
    return user;
  }

  Map<String, dynamic> get getAppointment {
    return appointment;
  }

//this is to update latest favorite list and notify all widgets
  void setFavList(List<dynamic> list) {
    _fav = list;
    notifyListeners();
  }

//and this is to return latest favorite doctor list
  List<Map<String, dynamic>> get getFavDoc {
    favDoc.clear(); //clear all previous record before get latest list

    //list out doctor list according to favorite list
    for (var num in _fav) {
      for (var doc in user['doctor']) {
        if (num == doc['doc_id']) {
          favDoc.add(doc);
        }
      }
    }
    return favDoc;
  }

// Method to handle login success and update the user data
  void loginSuccess(Map<String, dynamic> userData, Map<String, dynamic> appointmentInfo) {
    _isLogin = true;

    // Update user and appointment details
    user = userData;
    appointment = appointmentInfo;

    // Check if user['details'] and user['details']['fav'] are not null
    if (user.containsKey('details') && user['details'] != null) {
      var details = user['details'];
      if (details.containsKey('fav') && details['fav'] != null) {
        // Decode JSON string and update favorite doctor list
        _fav = json.decode(details['fav']);
      }
    }

    // Notify listeners about the state change
    notifyListeners();
  }
}
