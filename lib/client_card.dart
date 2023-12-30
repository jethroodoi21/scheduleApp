import 'package:flutter/material.dart';

class ClientCard extends StatefulWidget {
  const ClientCard(this.name, this.meetTime, this.number, {super.key});
  final name;
  final number;
  final meetTime;

  @override
  State<ClientCard> createState() => _ClientCardState();
}

class _ClientCardState extends State<ClientCard> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
            child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: ElevatedButton(
            onPressed: () {
              setState(() {
                showDialog(
                  context: context,
                  builder: (ctxt) {
                    return AlertDialog(
                      content: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Text(
                              'Name : ${widget.name}',
                              style: TextStyle(fontSize: 18),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Text(
                              'Number : ${widget.number}',
                              style: TextStyle(fontSize: 18),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Text(
                              'Meet Time : ${widget.meetTime}',
                              style: TextStyle(fontSize: 18),
                            ),
                          )
                        ],
                      ),
                    );
                  },
                );
              });
            },
            child: Text('${widget.name}'),
          ),
        ))
      ],
    );
  }
}
