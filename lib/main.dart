import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:web_event/Pages/login_page.dart';
import 'package:web_event/Services/EventProvider.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => Eventprovider()),
    ],
    child: const MainApp(),
  ));
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    final eventprovider = Provider.of<Eventprovider>(context, listen: false);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      eventprovider.fetchEvents(eventprovider.value);
    });
    return MaterialApp(
      home: Scaffold(body: Login()),
    );
  }
}
