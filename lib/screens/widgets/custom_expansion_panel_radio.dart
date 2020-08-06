import 'package:flutter/material.dart';

import 'package:weather_app/models/wheather/daily.dart';
import 'package:weather_app/screens/widgets/forecast_widget.dart';

class CustomExpansionPanel extends StatefulWidget {
  final Daily day;
  final String weekday;
  final List<ForecastWidget> forecastWidgetList;
  const CustomExpansionPanel({
    Key key,
    this.day,
    this.weekday,
    this.forecastWidgetList,
  }) : super(key: key);
  _CustomExpansionPanelState createState() => _CustomExpansionPanelState();
}

class _CustomExpansionPanelState extends State<CustomExpansionPanel> {
  bool isExpanded;
  @override
  void initState() {
    super.initState();
    isExpanded = false;
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> children = [
      InkWell(
        onTap: () {
          setState(() {
            isExpanded = !isExpanded;
          });
        },
        child: Container(
          height: 80,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Image.asset(
                "assets/weather_icons/${widget.day.describedWheather.iconId}.png",
                width: 50,
                height: 50,
              ),
              SizedBox(
                width: 10,
              ),
              Text(widget.weekday,
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
              Expanded(child: Container()),
              Container(
                width: 155,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text("${widget.day.temp.min}°C",
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold)),
                    SizedBox(
                      width: 25,
                    ),
                    Container(
                        width: 75,
                        child: Text("${widget.day.temp.max}°C",
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.bold))),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
      AnimatedContainer(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        height: isExpanded ? 140 : 0,
        child: ListView.separated(
            itemCount: widget.forecastWidgetList.length,
            itemBuilder: (context, index) => widget.forecastWidgetList[index],
            scrollDirection: Axis.horizontal,
            separatorBuilder: (context, index) => const Divider(
                  indent: 5,
                  endIndent: 5,
                )),
      )
    ];
    return Column(
      children: children,
    );
  }
}
