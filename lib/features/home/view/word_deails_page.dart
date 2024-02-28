import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:arabicdictionaryforspeakersofotherlanguages/core/constants/color_constsnts.dart';
import 'package:arabicdictionaryforspeakersofotherlanguages/features/home/model/word_model.dart';

class WordDetailsScreen extends ConsumerWidget {
  final WordModel wordModel;

  WordDetailsScreen({Key? key, required this.wordModel}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final word = ref.watch(getVocabularyService);
    final vocabularyList = word.vocabularyList;

    // Function to check if a word is in the vocabularyList and return the matching WordModel
    WordModel? getVocabularyWordModel(String word) {
      return vocabularyList.firstWhereOrNull((model) => model.word == word);
    }

    // Function to highlight a word if it's in the vocabularyList
    Widget highlightWord(String text, String mainWord, Color cc, double value) {
      if (text.toLowerCase() == mainWord.toLowerCase()) {
        // If the word is the main word, don't highlight it
        return Directionality(
          textDirection: TextDirection.rtl,
          child: Text(
            text,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: ColorConstants.secondaryText,
            ),
          ),
        );
      }

      WordModel? vocabularyWordModel = getVocabularyWordModel(text);

      return InkWell(
        onTap: () {
          if (vocabularyWordModel != null) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => WordDetailsScreen(
                  wordModel: vocabularyWordModel,
                ),
              ),
            );
          }
        },
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: vocabularyWordModel != null
              ? Text(
                  text,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                )
              : Text(
                  text,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: cc,
                    fontSize: value,
                  ),
                ),
        ),
      );
    }

    // Function to split a sentence into a list of words
    List<Widget> getWordWidgets(String sentence, Color cc, double value) {
      // Define a regular expression for Arabic words
      final RegExp regExp = RegExp(r"[\u0600-\u06FF]+");

      // Use the regular expression to find Arabic words in the sentence
      List<String> words =
          regExp.allMatches(sentence).map((match) => match.group(0)!).toList();

      return words.reversed
          .map((word) => highlightWord(word, wordModel.word, cc, value))
          .toList();
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Word Details'),
      ),
      body: SingleChildScrollView(
        child: SizedBox(
          height: MediaQuery.of(context).size.height - 100,
          child: Padding(
            padding: const EdgeInsets.all(25.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Image.network(
                          wordModel.imageUrl,
                          height: 200,
                          width: 200,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Flexible(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              wordModel.word.length > 20
                                  ? '${wordModel.word.substring(0, 20)}...'
                                  : wordModel.word,
                              textAlign: TextAlign.end,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 26,
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            Text(
                              wordModel.meaning.length > 60
                                  ? '${wordModel.meaning.substring(0, 60)}...'
                                  : wordModel.meaning,
                              textAlign: TextAlign.end,
                              style: const TextStyle(
                                fontWeight: FontWeight.normal,
                                fontSize: 16,
                                color: Colors.black,
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                ref
                                    .read(getVocabularyService)
                                    .playAudio(wordModel.audioUrl);
                              },
                              icon: word.isAudioPlaying
                                  ? const Icon(Icons.pause)
                                  : const Icon(Icons.play_arrow),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Text(
                      wordModel.partsOfSpeech.length > 50
                          ? '${wordModel.partsOfSpeech.substring(0, 50)}...'
                          : wordModel.partsOfSpeech,
                      textAlign: TextAlign.end,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                Flexible(
                  child: Text(
                    wordModel.explanation,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                      fontSize: 20,
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                Flexible(
                  child: Text(
                    wordModel.example1,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                      fontSize: 14,
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                Flexible(
                  child: Text(
                    wordModel.example2,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.blueGrey,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
