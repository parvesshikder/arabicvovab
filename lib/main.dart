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
        fontFamily: 'Amiri',
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



// import 'package:collection/collection.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:arabicdictionaryforspeakersofotherlanguages/core/constants/color_constsnts.dart';
// import 'package:arabicdictionaryforspeakersofotherlanguages/features/home/model/word_model.dart';

// class WordDetailsScreen extends ConsumerWidget {
//   final WordModel wordModel;

//   WordDetailsScreen({Key? key, required this.wordModel}) : super(key: key);

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final word = ref.watch(getVocabularyService);
//     final vocabularyList = word.vocabularyList;

//     // Function to check if a word is in the vocabularyList and return the matching WordModel
//     WordModel? getVocabularyWordModel(String word) {
//       return vocabularyList.firstWhereOrNull((model) => model.word == word);
//     }

//     // Function to highlight a word if it's in the vocabularyList
//     Widget highlightWord(String text, String mainWord, Color cc, double value) {
//       if (text.toLowerCase() == mainWord.toLowerCase()) {
//         // If the word is the main word, don't highlight it
//         return Directionality(
//           textDirection: TextDirection.rtl,
//           child: Text(
//             text,
//             style: const TextStyle(
//               fontWeight: FontWeight.bold,
//               color: ColorConstants.secondaryText,
//             ),
//           ),
//         );
//       }

//       WordModel? vocabularyWordModel = getVocabularyWordModel(text);

//       return vocabularyWordModel != null
//           ? InkWell(
//               onTap: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => WordDetailsScreen(
//                       wordModel: vocabularyWordModel,
//                     ),
//                   ),
//                 );
//               },
//               child: Directionality(
//                 textDirection: TextDirection.rtl,
//                 child: Text(
//                   text,
//                   style: const TextStyle(
//                     fontWeight: FontWeight.bold,
//                     color: Colors.green,
//                   ),
//                 ),
//               ),
//             )
//           : Directionality(
//               textDirection: TextDirection.rtl,
//               child: Text(
//                 text,
//                 style: TextStyle(
//                   fontWeight: FontWeight.bold,
//                   color: cc,
//                   fontSize: value,
//                 ),
//               ),
//             );
//     }

//     // Function to split a sentence into a list of words
//     List<Widget> getWordWidgets(String sentence, Color cc, double value) {
//       List<String> words = sentence.split(' ');
//       return words.reversed
//           .map((word) => highlightWord(word, wordModel.word, cc, value))
//           .toList();
//     }

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Word Details'),
//       ),
//       body: SingleChildScrollView(
//         child: SizedBox(
//           height: MediaQuery.of(context).size.height - 100,
//           child: Padding(
//             padding: const EdgeInsets.all(25.0),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.end,
//               children: [
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Expanded(
//                       child: Padding(
//                         padding: const EdgeInsets.all(10.0),
//                         child: Image.network(
//                           wordModel.imageUrl,
//                           height: 200,
//                           width: 200,
//                         ),
//                       ),
//                     ),
//                     Expanded(
//                       flex: 2,
//                       child: Flexible(
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.end,
//                           children: [
//                             Text(
//                               wordModel.word.length > 20
//                                   ? '${wordModel.word.substring(0, 20)}...'
//                                   : wordModel.word,
//                               textAlign: TextAlign.end,
//                               style: const TextStyle(
//                                 fontWeight: FontWeight.bold,
//                                 fontSize: 26,
//                                 color: Colors.black,
//                               ),
//                             ),
//                             const SizedBox(
//                               height: 15,
//                             ),
//                             Text(
//                               wordModel.meaning.length > 60
//                                   ? '${wordModel.meaning.substring(0, 60)}...'
//                                   : wordModel.meaning,
//                               textAlign: TextAlign.end,
//                               style: const TextStyle(
//                                 fontWeight: FontWeight.normal,
//                                 fontSize: 16,
//                                 color: Colors.black,
//                               ),
//                             ),
//                             IconButton(
//                               onPressed: () {
//                                 ref
//                                     .read(getVocabularyService)
//                                     .playAudio(wordModel.audioUrl);
//                               },
//                               icon: word.isAudioPlaying
//                                   ? const Icon(Icons.pause)
//                                   : const Icon(Icons.play_arrow),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 20),
//                 Container(
//                   width: double.infinity,
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                   child: Padding(
//                     padding: const EdgeInsets.all(20.0),
//                     child: Text(
//                       wordModel.partsOfSpeech.length > 50
//                           ? '${wordModel.partsOfSpeech.substring(0, 50)}...'
//                           : wordModel.partsOfSpeech,
//                       textAlign: TextAlign.end,
//                       style: const TextStyle(
//                         fontWeight: FontWeight.bold,
//                         fontSize: 20,
//                         color: Colors.black,
//                       ),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 30),
//                 Flexible(
//                   child: Wrap(
//                     alignment: WrapAlignment.end,
//                     children: getWordWidgets(
//                         wordModel.explanation, Colors.black87, 20),
//                   ),
//                 ),
//                 const SizedBox(height: 40),
//                 Flexible(
//                   child: Wrap(
//                     alignment: WrapAlignment.end,
//                     children:
//                         getWordWidgets(wordModel.example1, Colors.grey, 14),
//                   ),
//                 ),
//                 const SizedBox(height: 15),
//                 Flexible(
//                   child: Wrap(
//                     alignment: WrapAlignment.end,
//                     children:
//                         getWordWidgets(wordModel.example2, Colors.blueGrey, 14),
//                   ),
//                 ),
//                 Text(wordModel.example2)
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
