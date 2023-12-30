import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:schedule_app/client_card.dart';
import 'dart:io';

class DayCard extends StatefulWidget {
  const DayCard(this.day, this.weekName, {super.key});
  final day;
  final weekName;

  @override
  State<DayCard> createState() => _DayCardState();
}

class _DayCardState extends State<DayCard> {
  bool addedPerson = false;
  var clientName = '';
  var clientNumber = '';
  var meetTime = '';
  var listOfCients = [];
  var hasRun = false;

  Future<void> storePerson(String weekName, String name, String number,
      String meetTime, String day) async {
    var appDir = await getApplicationDocumentsDirectory();
    var weekFile = File('${appDir.path}/$weekName.sjk');

    // Read existing content from the file
    String existingContent =
        await weekFile.exists() ? await weekFile.readAsString() : '';

    // Parse existing content into a Map
    Map<String, List<String>> weekData = {};

    if (existingContent.isNotEmpty) {
      try {
        weekData = Map.fromIterable(
          existingContent.split('\n'),
          key: (item) => item.split('-')[0],
          value: (item) => item.split('-')[1].split(';'),
        );
      } catch (e) {
        print('Error parsing existing data: $e');
      }
    }

    // Update or add the person details for the specified day
    if (weekData.containsKey(day)) {
      // Update details for an existing day
      weekData[day]!.add('$name,$meetTime,$number');
    } else {
      // Add details for a new day
      weekData[day] = ['$name,$meetTime,$number'];
    }

    // Write the updated content back to the file
    await weekFile.writeAsString(weekData.entries.map((entry) {
      return '${entry.key}-${entry.value.join(';')}';
    }).join('\n'));
  }

  Future<List<List<String>>> getClients(String weekName, String day) async {
    var appDir = await getApplicationDocumentsDirectory();
    var weekFile = File('${appDir.path}/$weekName.sjk');

    if (await weekFile.exists()) {
      String fileContent = await weekFile.readAsString();

      List<List<String>> clientsList = [];

      try {
        Map<String, List<String>> weekData = Map.fromIterable(
          fileContent.split('\n'),
          key: (item) => item.split('-')[0],
          value: (item) => item.split('-')[1].split(';'),
        );

        if (weekData.containsKey(day)) {
          for (String personDetails in weekData[day]!) {
            clientsList.add(personDetails.split(','));
          }
        }
      } catch (e) {
        print('Error parsing file content: $e');
      }

      return clientsList;
    } else {
      print('File $weekName does not exist');
      return [];
    }
  }

  void getUser() async {
    if (!hasRun) {
      List<List<String>> clients =
          await getClients(widget.weekName, widget.day);
      print(clients);
      addedPerson = true;
      for (int i = 0; i < clients.length; i++) {
        listOfCients
            .add(ClientCard(clients[i][0], clients[i][1], clients[i][2]));
      }
      setState(() {
        hasRun = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    getUser();
    return SizedBox(
      height: MediaQuery.sizeOf(context).height / 1.5,
      width: MediaQuery.sizeOf(context).width / 2.3,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Card(
            elevation: 15,
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Text(
                      '${widget.day}',
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                  addedPerson
                      ? ElevatedButton.icon(
                          onPressed: () {
                            setState(() {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    content: Column(children: [
                                      TextField(
                                        onChanged: (value) {
                                          clientName = value;
                                        },
                                        decoration: InputDecoration(
                                            hintText: 'Client Name'),
                                      ),
                                      TextField(
                                        onChanged: (value) {
                                          meetTime = value;
                                        },
                                        decoration: InputDecoration(
                                            hintText: 'Meeting Time'),
                                      ),
                                      TextField(
                                        onChanged: (value) {
                                          clientNumber = value;
                                        },
                                        decoration: InputDecoration(
                                            hintText: 'Phone Number'),
                                      ),
                                      ElevatedButton(
                                        onPressed: () {
                                          setState(() {
                                            if (clientName != '') {
                                              listOfCients.add(
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(5.0),
                                                  child: ClientCard(
                                                    clientName,
                                                    meetTime,
                                                    clientNumber,
                                                  ),
                                                ),
                                              );
                                            }
                                          });
                                          storePerson(
                                              widget.weekName,
                                              clientName,
                                              clientNumber,
                                              meetTime,
                                              widget.day);
                                        },
                                        child: Text('Finished'),
                                      ),
                                    ]),
                                  );
                                },
                              );
                              addedPerson = true;
                            });
                          },
                          icon: Icon(Icons.add),
                          label: Text('Add Person'),
                        )
                      : SizedBox(),
                  addedPerson
                      ? SizedBox(
                          height: MediaQuery.sizeOf(context).height / 2,
                          width: MediaQuery.sizeOf(context).width / 2.8,
                          child: Card(
                              elevation: 15,
                              child: SingleChildScrollView(
                                physics: BouncingScrollPhysics(),
                                child: Column(children: [...listOfCients]),
                              )),
                        )
                      : ElevatedButton.icon(
                          onPressed: () {
                            setState(() {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    content: Column(children: [
                                      TextField(
                                        onChanged: (value) {
                                          clientName = value;
                                        },
                                        decoration: InputDecoration(
                                            hintText: 'Client Name'),
                                      ),
                                      TextField(
                                        onChanged: (value) {
                                          meetTime = value;
                                        },
                                        decoration: InputDecoration(
                                            hintText: 'Meeting Time'),
                                      ),
                                      TextField(
                                        onChanged: (value) {
                                          clientNumber = value;
                                        },
                                        decoration: InputDecoration(
                                            hintText: 'Phone Number'),
                                      ),
                                      ElevatedButton(
                                        onPressed: () {
                                          setState(() {
                                            if (clientName != '') {
                                              listOfCients.add(
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(5.0),
                                                  child: ClientCard(
                                                    clientName,
                                                    meetTime,
                                                    clientNumber,
                                                  ),
                                                ),
                                              );
                                            }
                                          });
                                          storePerson(
                                              widget.weekName,
                                              clientName,
                                              clientNumber,
                                              meetTime,
                                              widget.day);
                                        },
                                        child: Text('Finished'),
                                      ),
                                    ]),
                                  );
                                },
                              );
                              addedPerson = true;
                            });
                          },
                          icon: Icon(Icons.add),
                          label: Text('Add Person'),
                        ),
                ],
              ),
            )),
      ),
    );
  }
}
