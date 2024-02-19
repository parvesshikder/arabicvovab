import 'package:arabicdictionaryforspeakersofotherlanguages/core/constants/color_constsnts.dart';
import 'package:arabicdictionaryforspeakersofotherlanguages/features/home/view/home_screen.dart';
import 'package:arabicdictionaryforspeakersofotherlanguages/features/like/view/like_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        hoverColor: Colors.transparent,
        colorScheme: ColorScheme.fromSwatch(
          backgroundColor: ColorConstants.backgroundColor,
          primarySwatch: MaterialColor(
            ColorConstants.mainText.value,
            const <int, Color>{
              50: ColorConstants.mainText,
              100: ColorConstants.mainText,
              200: ColorConstants.mainText,
              300: ColorConstants.mainText,
              400: ColorConstants.mainText,
              500: ColorConstants.mainText,
              600: ColorConstants.mainText,
              700: ColorConstants.mainText,
              800: ColorConstants.mainText,
              900: ColorConstants.mainText,
            },
          ),
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),
      home: const ArabicApp(),
    );
  }
}

class ArabicApp extends ConsumerStatefulWidget {
  const ArabicApp({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ByCliqUserAppState createState() => _ByCliqUserAppState();
}

class _ByCliqUserAppState extends ConsumerState<ArabicApp> {
  double xOffset = 0;
  double yOffset = 0;

  bool isDrawerOpen = false;
  int _selectedItemIndex = 0;

  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();

    _pages = [
      HomeScreen(),
       LikeScreen(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        IndexedStack(
          index: _selectedItemIndex,
          children: _pages,
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withOpacity(
                      0.8), // Adjust the alpha value for transparency
                  Colors.black.withOpacity(
                      1), // Adjust the alpha value for transparency
                ],
              ),
            ),
            child: BottomNavigationBar(
              backgroundColor: Colors.black.withOpacity(0.7),
              elevation: 0,
              selectedItemColor: Colors.white, // Selected icon color
              unselectedItemColor: Colors.white, // Unselected icon color
              type: BottomNavigationBarType.fixed,
              currentIndex: _selectedItemIndex, // Update currentIndex
              showSelectedLabels: true,
              showUnselectedLabels: true,

              onTap: (index) {
                // Handle tap on navigation items
                setState(() {
                  _selectedItemIndex = index;
                });
              },
              items: [
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.home,
                    size: 32,
                    color: _selectedItemIndex == 0
                        ? Colors.white.withOpacity(0.8)
                        : Colors.grey.withOpacity(0.4),
                  ),
                  label: 'HOME',
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.favorite,
                    size: 32,
                    color: _selectedItemIndex == 1
                        ? Colors.white.withOpacity(0.8)
                        : Colors.grey.withOpacity(0.4),
                  ),
                  label: 'FAVOURITE',
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
