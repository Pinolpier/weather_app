import 'package:flutter/material.dart';
import 'package:weather_app/screens/widgets/custom_expansion_panel_radio.dart';

class ForecastListWidget extends StatefulWidget {
  final List<CustomExpansionPanel> list;
  const ForecastListWidget({
    Key key,
    this.list,
  }) : super(key: key);
  _ForecastListWidgetState createState() => _ForecastListWidgetState();
}

class _ForecastListWidgetState extends State<ForecastListWidget> {
  @override
  Widget build(BuildContext context) {
    return ListView.separated(
        itemBuilder: (context, index) => widget.list[index],
        separatorBuilder: (context, index) => const Divider(
              indent: 15,
              endIndent: 15,
              height: 5,
              thickness: 1,
              color: Colors.black,
            ),
        itemCount: widget.list.length,
        scrollDirection: Axis.vertical);
  }
}
