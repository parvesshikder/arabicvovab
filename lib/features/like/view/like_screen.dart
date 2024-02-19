import 'package:arabicdictionaryforspeakersofotherlanguages/core/constants/color_constsnts.dart';
import 'package:arabicdictionaryforspeakersofotherlanguages/features/home/view/card.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:arabicdictionaryforspeakersofotherlanguages/features/home/model/word_model.dart';

class LikeScreen extends ConsumerWidget {
  const LikeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vocabularyService = ref.watch(getVocabularyService);
    final likedWords =
        vocabularyService.vocabularyList.where((word) => word.isFAv).toList();

    return Scaffold(
      backgroundColor: ColorConstants.backgroundColor,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            const SizedBox(height: 40),
            const Text(
              'FAVOURITE WORD',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 24,
                color: ColorConstants.mainText,
              ),
            ),
            const SizedBox(height: 0),
            Expanded(
              child: likedWords.isNotEmpty
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: ListView.builder(
                        itemCount: likedWords.length,
                        itemBuilder: (BuildContext context, int index) {
                          return WordCard(wordModel: likedWords[index]);
                        },
                      ),
                    )
                  : const Center(
                      child: Text(
                        'No Liked Words Found!',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: ColorConstants.secondaryText,
                        ),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
