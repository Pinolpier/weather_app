import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefs extends ChangeNotifier {
  SharedPreferences prefs;
  List<Function> toDo;
  SharedPrefs() {
    SharedPreferences.getInstance().then((value) {
      prefs = value;
      notifyListeners();
    });
    toDo = [];
  }
  void setInt(String key, int i) {
    if (prefs == null) {
      toDo.add((key, i) {
        this.setInt(key, i);
      });
    } else {
      prefs?.setInt(key, i);
      if (toDo != null && toDo.isNotEmpty) {
        List<Function> copy = toDo;
        toDo = null;
        for (Function i in copy) {
          i.call();
        }
      }
    }
  }

  void setBool(String key, bool i) {
    if (prefs == null) {
      toDo.add((key, i) {
        this.setBool(key, i);
      });
    } else {
      prefs?.setBool(key, i);
      if (toDo != null && toDo.isNotEmpty) {
        List<Function> copy = toDo;
        toDo = null;
        for (Function i in copy) {
          i.call();
        }
      }
    }
  }

  void setString(String key, String i) {
    if (prefs == null) {
      toDo.add((key, i) {
        this.setString(key, i);
      });
    } else {
      prefs?.setString(key, i);
      if (toDo != null && toDo.isNotEmpty) {
        List<Function> copy = toDo;
        toDo = null;
        for (Function i in copy) {
          i.call();
        }
      }
    }
  }

  bool getBool(String key) {
    return prefs?.getBool(key) ?? true;
  }

  int getInt(String key) {
    return prefs?.getInt(key);
  }

  String getString(String key) {
    return prefs?.getString(key);
  }

  bool isAvailable() {
    return prefs != null;
  }

  void remove(String key) {
    prefs.remove(key);
  }
}
