import 'package:arabicdictionaryforspeakersofotherlanguages/core/constants/color_constsnts.dart';
import 'package:arabicdictionaryforspeakersofotherlanguages/features/home/model/word_model.dart';
import 'package:arabicdictionaryforspeakersofotherlanguages/features/home/view/card.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';

class HomeScreen extends ConsumerWidget {
  HomeScreen({super.key});

  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    _searchController.addListener(() {
      _performSearch(ref);
    });
    return Scaffold(
      backgroundColor: ColorConstants.backgroundColor,
      appBar: AppBar(
        toolbarHeight: 160,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            const Text(
              'Welcome to',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 26,
                  color: ColorConstants.mainText),
            ),
            const SizedBox(
              height: 5,
            ),
            const Text(
              'المعجم العربي للناطقين بلغات أخرى',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: ColorConstants.secondaryText),
            ),
            const SizedBox(
              height: 15,
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.3),
                borderRadius: BorderRadius.circular(16),
              ),
              child: TextField(
                controller: _searchController,
                textDirection: TextDirection.rtl,
                decoration: InputDecoration(
                  hintText: 'Search...',
                  border: InputBorder.none,
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.search),
                    onPressed: () {
                      // Perform the search here
                      _performSearch(ref);
                    },
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: SizedBox(
          height: MediaQuery.of(context).size.height - 190,
          child: Padding(
            padding:
                const EdgeInsets.only(top: 20, left: 20, right: 20, bottom: 65),
            child: Consumer(
              builder: (context, ref, child) {
                final vocabularyService = ref.watch(getVocabularyService);
                final vocabularyList = vocabularyService.vocabularyList;
                final searchQuery = _searchController.text.toLowerCase();
          
                // Filter vocabularyList based on search query
                final filteredList = vocabularyList.where((wordModel) {
                  final word = wordModel.word.toLowerCase();
                  return word.contains(searchQuery);
                }).toList();
          
                return vocabularyService.isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : filteredList.isNotEmpty
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: filteredList.length,
                              itemBuilder: (BuildContext context, int index) {
                                final wordModel = filteredList[index];
                                return Column(
                                  children: [
                                    WordCard(
                                      key: Key(wordModel.id),
                                      wordModel: wordModel,
                                    ),
                                    Divider(
                                      height: 0.5,
                                      color: ColorConstants.mainText
                                          .withOpacity(0.1),
                                    ),
                                  ],
                                );
                              },
                            ),
                          )
                        : const Center(
                            child: Text(
                              'No Words Found!',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: ColorConstants.secondaryText,
                              ),
                            ),
                          );
              },
            ),
          ),
        ),
      ),
    );
  }

  void _performSearch(WidgetRef ref) {
    // You can perform additional actions here if needed
    ref.read(getVocabularyService.notifier).search(_searchController.text);
  }
}
