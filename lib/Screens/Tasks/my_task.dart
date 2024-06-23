import 'dart:convert';
import 'package:drive_check/Widgets/new_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../controller/my_task_controller.dart';

class MyTask extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Tasks'),
      ),
      body: SafeArea(
        child: GetBuilder<MyTaskController>(
          init: MyTaskController(), // Initialize controller
          builder: (_controller) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (_controller.employeeName == null)
                Center(child: CircularProgressIndicator())
              else
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'Tasks for ${_controller.employeeName}',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
              Divider(),
              Expanded(
                child: _controller.allTasks.isEmpty
                    ? Center(child: Text('No tasks available.'))
                    : ListView.builder(
                  itemCount: _controller.allTasks.length,
                  itemBuilder: (context, index) {
                    DocumentSnapshot task = _controller.allTasks[index];
                    Map<String, dynamic> data =
                    jsonDecode(jsonEncode(task.data()));

                    return Card(
                      elevation: 3,
                      color: Colors.blue.shade50,
                      margin: EdgeInsets.symmetric(
                          vertical: 8, horizontal: 16),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${task.id}',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 8),
                            ...data.entries.map((entry) {
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 4),
                                child: Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      '${entry.key}:',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Flexible(
                                      child: Text(
                                        entry.value.toString(),
                                        textAlign: TextAlign.right,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),
                            SizedBox(height: 8),
                            Row(
                              mainAxisAlignment:
                              MainAxisAlignment.spaceEvenly,
                              children: [
                                NewButton(buttonText: "Accept", onTap: (){_controller.acceptTask(task.id);}),
                                NewButton(buttonText: "Reject", onTap: (){_controller.rejectTask(task.id);}),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
