import 'package:flutter/material.dart';
import 'package:maza_task/mqtt_task/mqtt_screen.dart';
import 'package:maza_task/youtub_part/screens/video_list.dart';

class TaskSWitch extends StatefulWidget {
  const TaskSWitch({super.key});

  @override
  State<TaskSWitch> createState() => _TaskSWitchState();
}

class _TaskSWitchState extends State<TaskSWitch> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
          Center(
            child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                ),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const VideoList()));
                },
                child: const Text(
                  'Youtube Task',
                  style: TextStyle(color: Colors.white, fontSize: 20),
                )),
          ),
          const SizedBox(
            height: 20,
          ),
          Center(
            child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                ),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>  MQTTScreen()));
                },
                child: const Text(
                  'MQTT Task',
                  style: TextStyle(color: Colors.white, fontSize: 20),
                )),
          ),
        ]));
  }
}
