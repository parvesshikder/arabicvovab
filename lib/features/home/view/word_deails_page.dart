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
    Widget highlightWord(String text) {
      WordModel? vocabularyWordModel = getVocabularyWordModel(text);

      return vocabularyWordModel != null
          ? InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => WordDetailsScreen(
                      wordModel: vocabularyWordModel,
                    ),
                  ),
                );
              },
              child: Text(
                text,
                textAlign: TextAlign.end,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.yellow,
                ),
              ),
            )
          : Text(
              text,
              textAlign: TextAlign.end,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: ColorConstants.secondaryText,
              ),
            );
    }

    // Function to split a sentence into a list of words
    List<Widget> getWordWidgets(String sentence) {
      List<String> words = sentence.split(' ');
      return words.map((word) => highlightWord(word)).toList();
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Word Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Image.network(
                    wordModel.imageUrl,
                    height: 200,
                    width: 200,
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
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 26,
                            color: Colors.black,
                          ),
                        ),
                        Text(
                          wordModel.meaning.length > 60
                              ? '${wordModel.meaning.substring(0, 60)}...'
                              : wordModel.meaning,
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
                padding: const EdgeInsets.all(10.0),
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
            const SizedBox(height: 20),
            const Text(
              'Explanation',
              textAlign: TextAlign.end,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: ColorConstants.mainText,
              ),
            ),
            Flexible(
              child: Wrap(
                alignment: WrapAlignment.end,
                children: getWordWidgets(wordModel.explanation),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Example',
              textAlign: TextAlign.end,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: ColorConstants.mainText,
              ),
            ),
            Flexible(
              child: Wrap(
                alignment: WrapAlignment.end,
                children: getWordWidgets(wordModel.example1),
              ),
            ),
            const SizedBox(height: 10),
            Flexible(
              child: Wrap(
                alignment: WrapAlignment.end,
                children: getWordWidgets(wordModel.example2),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
