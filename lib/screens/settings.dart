import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/models/city/autocomplete_location.dart';
import 'package:weather_app/models/wheather/complete_weather.dart';
import 'package:weather_app/services/SharedPrefs.dart';
import 'package:weather_app/services/autocomplete_locations_service.dart';

class SettingsScreen extends StatefulWidget {
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _currentLocation;
  @override
  Widget build(BuildContext context) {
    return Consumer<SharedPrefs>(builder: (context, prefs, child) {
      _currentLocation =
          prefs.isAvailable() ? prefs.getBool("useOwnLocation") : true;
      TextEditingController typeAheadController = TextEditingController(
          text:
              prefs.isAvailable() ? prefs.getString("choosenLocation") : null);
      return Consumer<CompleteWeatherService>(
          builder: (context, weatherService, child) {
        return Scaffold(
            appBar:
                AppBar(title: Text("Settings"), backgroundColor: Colors.green),
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
                        weatherService.fetchWeather(0);
                        prefs.remove("choosenLocation");
                        prefs.setInt("cityId", 0);
                      }
                      prefs.setBool("useOwnLocation", value);
                      setState(() {});
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
                                textFieldConfiguration: TextFieldConfiguration(
                                    controller: typeAheadController,
                                    decoration:
                                        InputDecoration(labelText: "Location")),
                                suggestionsCallback: (pattern) {
                                  return complete(pattern);
                                },
                                itemBuilder: (context, suggestion) {
                                  if (suggestion.runtimeType !=
                                      WeatherServiceLocation) {
                                    return ListTile(
                                      title: Text("Error"),
                                    );
                                  }
                                  return ListTile(
                                    title: Text(suggestion.toUiString()),
                                  );
                                },
                                transitionBuilder:
                                    (context, suggestionsBox, controller) {
                                  return suggestionsBox;
                                },
                                onSuggestionSelected: (suggestion) {
                                  typeAheadController.text = suggestion.name;
                                  prefs.setString(
                                      "choosenLocation", suggestion.name);
                                  prefs.setBool("useOwnLocation", false);
                                  prefs.setInt("cityId", suggestion.id);
                                  weatherService.fetchWeather(suggestion.id);
                                })
                          ],
                        )
                ],
              ),
            ));
      });
    });
  }
}
