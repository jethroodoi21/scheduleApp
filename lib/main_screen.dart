import 'package:flutter/material.dart';
import 'package:schedule_app/day_card.dart';

class MainScreen extends StatefulWidget {
  const MainScreen(this.weekName, {super.key});
  final weekName;
  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  String getCurrentDayInWords() {
    DateTime now = DateTime.now();
    String day = '';

    switch (now.weekday) {
      case DateTime.monday:
        day = 'Monday';
        break;
      case DateTime.tuesday:
        day = 'Tuesday';
        break;
      case DateTime.wednesday:
        day = 'Wednesday';
        break;
      case DateTime.thursday:
        day = 'Thursday';
        break;
      case DateTime.friday:
        day = 'Friday';
        break;
      case DateTime.saturday:
        day = 'Saturday';
        break;
      case DateTime.sunday:
        day = 'Sunday';
        break;
      default:
        day = '';
    }

    return day;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text(
              'Schedule App - ${widget.weekName.toString().replaceAll('_', ' ')}'),
        ),
        body: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(children: [
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.start,
            //   children: [
            //     Padding(
            //       padding: const EdgeInsets.all(5.0),
            //       child: Text(
            //         '${getCurrentDayInWords()}',
            //         style: TextStyle(fontSize: 25, fontStyle: FontStyle.italic),
            //       ),
            //     )
            //   ],
            // ),
            SizedBox(
              height: 20,
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(children: [
                DayCard('Mon', widget.weekName),
                DayCard('Tue', widget.weekName),
                DayCard('Wed', widget.weekName),
                DayCard('Thu', widget.weekName),
                DayCard('Fri', widget.weekName)
              ]),
            )
          ]),
        ),
      ),
    );
  }
}
