import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:arabicdictionaryforspeakersofotherlanguages/core/constants/color_constsnts.dart';
import 'package:arabicdictionaryforspeakersofotherlanguages/features/home/model/word_model.dart';

class WordDetailsScreen extends ConsumerStatefulWidget {
  final WordModel wordModel;

  WordDetailsScreen({Key? key, required this.wordModel}) : super(key: key);

  @override
  _WordDetailsScreenState createState() => _WordDetailsScreenState();
}

class _WordDetailsScreenState extends ConsumerState<WordDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    final word = ref.watch(getVocabularyService);
    final vocabularyList = word.vocabularyList;
    final boolknow = word.isAudioPlaying;

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
                    widget.wordModel.imageUrl,
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
                          widget.wordModel.word.length > 20
                              ? '${widget.wordModel.word.substring(0, 20)}...'
                              : widget.wordModel.word,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 26,
                            color: Colors.black,
                          ),
                        ),
                        Text(
                          widget.wordModel.meaning.length > 60
                              ? '${widget.wordModel.meaning.substring(0, 60)}...'
                              : widget.wordModel.meaning,
                          style: const TextStyle(
                            fontWeight: FontWeight.normal,
                            fontSize: 16,
                            color: Colors.black,
                          ),
                        ),
                        Consumer(
                          builder: (context, ref, child) {
                            final isAudioPlaying =
                                ref.watch(getVocabularyService).isAudioPlaying2;

                            return IconButton(
                              onPressed: () {
                                ref.read(getVocabularyService).playAudio(
                                    widget.wordModel.audioUrl,
                                    widget.wordModel.id);
                              },
                              icon: isAudioPlaying
                                  ? const Icon(Icons.pause)
                                  : const Icon(Icons.play_arrow),
                            );
                          },
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
                  widget.wordModel.partsOfSpeech.length > 50
                      ? '${widget.wordModel.partsOfSpeech.substring(0, 50)}...'
                      : widget.wordModel.partsOfSpeech,
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
                children: getWordWidgets(widget.wordModel.explanation),
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
                children: getWordWidgets(widget.wordModel.example1),
              ),
            ),
            const SizedBox(height: 10),
            Flexible(
              child: Wrap(
                alignment: WrapAlignment.end,
                children: getWordWidgets(widget.wordModel.example2),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
