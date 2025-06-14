import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:new_app/config/dependencies.dart';
import 'package:new_app/ui/widgets/home_screen.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() {
  runApp(MultiProvider(providers: providersLocal, child: const MainApp()));
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Memorando', // Título do aplicativo
      debugShowCheckedModeBanner: false, // Remove o banner de debug
      localizationsDelegates: const [
        GlobalWidgetsLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('pt', 'BR'), // Suporte para português do Brasil
        Locale('en', 'US'), // Suporte para inglês
      ],
      theme: ThemeData(
        fontFamily: 'prompt',
        textTheme: GoogleFonts.promptTextTheme(Theme.of(context).textTheme),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xff263238),
          primary: const Color(0xff263238),
        ),
        useMaterial3: true,
      ),
      home: const HomeScreen(), // Rota inicial definida
    );
  }
}
