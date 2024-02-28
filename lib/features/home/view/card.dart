import 'package:arabicdictionaryforspeakersofotherlanguages/features/home/model/word_model.dart';
import 'package:arabicdictionaryforspeakersofotherlanguages/features/home/view/word_deails_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class WordCard extends ConsumerWidget {
  final WordModel wordModel;

  const WordCard({Key? key, required this.wordModel}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: () {
        // Navigate to WordDetailsScreen when card is tapped
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => WordDetailsScreen(
              wordModel: wordModel,
            ),
          ),
        );
      },
      child: Container(
        height: 80,
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              Image.network(
                wordModel.imageUrl,
                height: 50,
                width: 50,
              ),
              const SizedBox(width: 10),
              SizedBox(
                width: 150,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      wordModel.word.length > 20
                          ? '${wordModel.word.substring(0, 20)}...'
                          : wordModel.word,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      wordModel.meaning.length > 60
                          ? '${wordModel.meaning.substring(0, 60)}...'
                          : wordModel.meaning,
                      style: const TextStyle(
                        fontWeight: FontWeight.normal,
                        fontSize: 10,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: () {
                  final audioPlayer =
                      ref.read(getVocabularyService).audioPlayer;
                  final service = ref.read(getVocabularyService.notifier);
                  service.playAudio(wordModel.audioUrl);

                  // Update the playing state for the pressed WordCard
                  ref
                      .read(getVocabularyService.notifier)
                      .updatePlayingState(wordModel.id, true);
                },
                icon: wordModel.isCurrentlyPlaying
                    ? const Icon(Icons.pause)
                    : const Icon(Icons.play_arrow),
              ),
              IconButton(
                icon: Icon(
                  wordModel.isFAv ? Icons.favorite : Icons.favorite_border,
                  color: wordModel.isFAv ? Colors.black : Colors.grey,
                ),
                onPressed: () {
                  // Toggle favorite status and update using Riverpod
                  ref.read(getVocabularyService).toggleFavorite(
                        wordModel.id,
                        !wordModel.isFAv,
                      );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
