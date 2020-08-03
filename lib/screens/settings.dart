import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weather_app/models/city/autocomplete_location.dart';
import 'package:weather_app/models/wheather/complete_weather.dart';
import 'package:weather_app/services/SharedPrefs.dart';
import 'package:weather_app/services/autocomplete_locations_service.dart';

class SettingsScreen extends StatefulWidget {
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _currentLocation; //TODO here I need sharedPrefs synchronously
  @override
  Widget build(BuildContext context) {
    return Consumer<SharedPrefs>(builder: (context, prefs, child) {
      _currentLocation =
          prefs.isAvailable() ? prefs.getBool("useOwnLocation") : true;
      // if (!_currentLocation) {
      //   String i = prefs.getString("choosenLocation");
      //   _currentLocation = (i == null || i.isEmpty);
      // }
      TextEditingController typeAheadController = TextEditingController(
          text:
              prefs.isAvailable() ? prefs.getString("choosenLocation") : null);
      return Consumer<CompleteWeatherFuture>(builder: (context, future, child) {
        return FutureBuilder(
            future: future.future,
            builder: (BuildContext context,
                AsyncSnapshot<CompleteWeather> snapshot) {
              if (snapshot.hasData) {
                return Scaffold(
                    appBar: AppBar(
                        title: Text("Settings"), backgroundColor: Colors.cyan),
                    body: Container(
                      color: Colors.lightGreenAccent,
                      child: Column(
                        children: <Widget>[
                          SwitchListTile(
                            title: const Text("Use current location?"),
                            value: _currentLocation,
                            onChanged: (bool value) async {
                              if (value) {
                                //Tell the weather service to use current location
                                future.reload(0);
                                prefs.remove("choosenLocation");
                              }
                              // prefs.setBool("useOwnLocation", value);
                              prefs.setBool("useOwnLocation", value);
                              setState(() {
                                // ERROR is not saving value to SharedPrefs, so it defaults to true
                                // _currentLocation = value;
                              });
                            },
                          ),
                          _currentLocation
                              ? SizedBox()
                              : Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    TypeAheadField(
                                        getImmediateSuggestions: true,
                                        textFieldConfiguration:
                                            TextFieldConfiguration(
                                                controller: typeAheadController,
                                                decoration: InputDecoration(
                                                    labelText: "Location")),
                                        suggestionsCallback: (pattern) {
                                          return complete(pattern);
                                        },
                                        itemBuilder: (context, suggestion) {
                                          if (suggestion.runtimeType !=
                                              WeatherServiceLocation) {
                                            //TODO Throw error, this should probably never happen!
                                            print(
                                                "Suggestion in AutoComplete List item Builder is of type ${suggestion.runtimeType}");
                                            return ListTile(
                                              title: Text("Error"),
                                            );
                                          }
                                          return ListTile(
                                            title:
                                                Text(suggestion.toUiString()),
                                          );
                                        },
                                        transitionBuilder: (context,
                                            suggestionsBox, controller) {
                                          return suggestionsBox;
                                        },
                                        onSuggestionSelected: (suggestion) {
                                          print(
                                              "Suggestion is of type ${suggestion.runtimeType} and");
                                          print("id is ${suggestion.id} and");
                                          print(
                                              "name is ${suggestion.name} and");
                                          // print(
                                          //     "name() is ${suggestion.name()}");
                                          typeAheadController.text =
                                              suggestion.name;
                                          prefs.setString("choosenLocation",
                                              suggestion.name);
                                          prefs.setBool(
                                              "useOwnLocation", false);
                                          future.reload(suggestion.id);
                                        })
                                  ],
                                )
                        ],
                      ),
                    ));
              } else if (snapshot.hasError) {
                //TODO show error message
                return null;
              } else {
                return SizedBox(
                  child: CircularProgressIndicator(),
                  width: 50,
                  height: 50,
                );
              }
            });
      });
    });
  }
}
