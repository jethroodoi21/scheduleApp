import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:schedule_app/main_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft]);
  return runApp(MaterialApp(
    home: HomeScreen(),
  ));
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var listOfWeeks = [];
  var currWeeek = '';
  bool hasRun = false;

  Future<List<String>> getFilesInAppDir() async {
    var appDir = await getApplicationDocumentsDirectory();
    var directory = Directory(appDir.path);

    List<String> fileNames = [];

    if (await directory.exists()) {
      List<FileSystemEntity> files = await directory.list().toList();

      for (var file in files) {
        if (file is File &&
            file.path.endsWith('.sjk') &&
            !file.path.endsWith('count.sjk')) {
          fileNames.add(file.uri.pathSegments.last);
        }
      }
    } else {
      print('Application directory does not exist');
    }

    return fileNames;
  }

  void updateWeekNumber() async {
    var appDir = await getApplicationDocumentsDirectory();
    var countFile = File('${appDir.path}/count.sjk');

    if (!await countFile.exists()) {
      // File doesn't exist, create it with initial value '0'
      await countFile.writeAsString('0');
    }

    // Read the current count from the file
    var currentCount = int.parse(await countFile.readAsString());

    // Increment the count
    var newCount = currentCount + 1;

    // Update the file with the new count
    await countFile.writeAsString(newCount.toString());

    // Create a new file for the current week
    var weekFile = File('${appDir.path}/week_$currentCount.sjk');
    await weekFile.writeAsString('');
    currWeeek = 'week_$newCount';

    setState(() {
      listOfWeeks.add(
        Padding(
          padding: const EdgeInsets.all(5.0),
          child: Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: OutlinedButton(
                    onPressed: () {
                      setState(() {
                        Navigator.push(context, MaterialPageRoute(
                          builder: (context) {
                            return MainScreen(currWeeek);
                          },
                        ));
                      });
                    },
                    child: Text('Week $newCount'),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  void getWeeks() async {
    if (!hasRun) {
      List<String> files = await getFilesInAppDir();
      print(files);
      for (int i = 0; i < files.length; i++) {
        listOfWeeks.add(
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: OutlinedButton(
                      onPressed: () {
                        setState(() {
                          Navigator.push(context, MaterialPageRoute(
                            builder: (context) {
                              return MainScreen(
                                  files[i].replaceAll('.sjk', ''));
                            },
                          ));
                        });
                      },
                      child: Text(files[i]
                          .replaceAll('.sjk', '')
                          .replaceAll('_', ' ')
                          .replaceAll('w', 'W')),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }
      setState(() {
        hasRun = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    getWeeks();
    return Scaffold(
      appBar: AppBar(title: Text('Schedlue App')),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 20,
            ),
            Center(
              child: Text(
                'Add Week',
                style: TextStyle(fontSize: 20),
              ),
            ),
            SizedBox(
              height: MediaQuery.sizeOf(context).height / 1.5,
              width: MediaQuery.sizeOf(context).width,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Card(
                  elevation: 10.0,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [...listOfWeeks],
                    ),
                  ),
                ),
              ),
            ),
            Row(
              children: [
                Expanded(
                    child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        updateWeekNumber();
                      });
                    },
                    child: Text('New Week'),
                  ),
                )),
              ],
            )
          ],
        ),
      ),
    );
  }
}
