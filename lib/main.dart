import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import 'package:tablet_ime/keyboard_service.dart';
import 'package:tablet_ime/floating_keyboard.dart';
import 'package:tablet_ime/keyboard_state.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => KeyboardState()),
        Provider(create: (_) => KeyboardService()),
      ],
      child: MaterialApp(
        title: 'Tablet IME',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
          useMaterial3: true,
        ),
        home: const FloatingKeyboard(),
      ),
    );
  }
}
