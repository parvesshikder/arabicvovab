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
      appBar: AppBar(
        toolbarHeight: 70,
        actions: const [
          Padding(
            padding: EdgeInsets.all(20.0),
            child: Text(
              'FAVOURITE WORD',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 24,
                color: ColorConstants.mainText,
              ),
            ),
          ),
        ],
      ),
      body: likedWords.isNotEmpty
          ? Padding(
              padding: const EdgeInsets.all(20.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: likedWords.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Column(
                      children: [
                        WordCard(
                          wordModel: likedWords[index],
                        ),
                        Divider(
                          height: 0.5,
                          color: ColorConstants.mainText.withOpacity(0.1),
                        ),
                      ],
                    );
                  },
                ),
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
    );
  }
}
