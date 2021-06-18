import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '/models/todo_item.dart';
import '/services/notification_service.dart';
import '/services/storage_service.dart';
import '/classes/storage.dart';

import '/screens/item_screen.dart';
import '/screens/list_screen.dart';
import '/screens/home_screen.dart';
import '/screens/edit_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) => FutureBuilder(
        future: fetchData(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            Map data = snapshot.data! as Map;
            Storage storageService = data['storageService'];
            NotificationService notificationService =
                data['notificationService'];
            return MultiProvider(
              providers: [
                ChangeNotifierProvider(
                    create: (_) => TodoItemModel(
                        storageService: storageService,
                        notificationService: notificationService)
                      ..init()),
              ],
              child: MaterialApp(
                title: 'Flutter Demo',
                initialRoute: '/',
                routes: {
                  '/': (context) => HomeScreen(),
                  '/list': (context) => ListScreen(),
                  '/item': (context) => ItemScreen(),
                  '/edit': (context) => EditScreen(),
                },
              ),
            );
          } else {
            return CircularProgressIndicator();
          }
        },
      );

  Future fetchData() async {
    Storage storageService = await StorageService.init();
    NotificationService notificationService = NotificationService()..init();
    return {
      'storageService': storageService,
      'notificationService': notificationService,
    };
  }
}
