import 'package:audioplayers/audioplayers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:audioplayers/audioplayers.dart' as audio;

class WordModel {
  final String id;
  final String word;
  final String meaning;
  final String imageUrl;
  final String audioUrl;
  bool isPlay;
  bool isFAv;
  final String example1;
  final String example2;
  final String explanation;
  final String partsOfSpeech;

  WordModel({
    required this.id,
    required this.word,
    required this.meaning,
    required this.imageUrl,
    required this.audioUrl,
    this.isFAv = false,
    this.isPlay = false,
    required this.example1,
    required this.example2,
    required this.explanation,
    required this.partsOfSpeech,
  });

  WordModel copyWith({bool? isFAv}) {
    return WordModel(
      id: id,
      word: word,
      meaning: meaning,
      imageUrl: imageUrl,
      isPlay: isPlay,
      isFAv: isFAv ?? this.isFAv,
      example1: example1,
      example2: example2,
      explanation: explanation,
      audioUrl: audioUrl,
      partsOfSpeech: partsOfSpeech,
    );
  }
}

class GetVocabularyService extends ChangeNotifier {
   final CollectionReference _vocabularyCollection =
      FirebaseFirestore.instance.collection('vocabulary');

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  List<WordModel> _vocabularyList = [];
  List<WordModel> get vocabularyList => _vocabularyList;

  List<WordModel> _originalVocabularyList = [];

  bool _isAudioPlaying = false;
  bool get isAudioPlaying => _isAudioPlaying;

  // Function to toggle play/pause state
  void toggleAudioPlaying() {
    _isAudioPlaying = !_isAudioPlaying;
    notifyListeners();
  }

  Future<void> fetchInitialData() async {
    _isLoading = true;

    try {
      QuerySnapshot querySnapshot = await _vocabularyCollection.limit(10).get();
      _vocabularyList = querySnapshot.docs.map((doc) {
        return WordModel(
            id: doc.id,
            word: doc['word'],
            meaning: doc['meaning'],
            imageUrl: doc['imageUrl'],
            isFAv: doc['isFAv'] ?? false,
            isPlay: doc['isPlay'] ?? false,
            example1: doc['example1'],
            example2: doc['example2'],
            explanation: doc['explanation'],
            audioUrl: doc['audioUrl'],
            partsOfSpeech: doc['partsOfSpeech']);
      }).toList();

      _originalVocabularyList = List.from(_vocabularyList);

      notifyListeners();
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching initial data: $e');
      }
    }

    _isLoading = false;
  }

  Future<void> toggleFavorite(String id, bool isFavorite) async {
    try {
      // Perform local update first
      _updateLocalFavoriteStatus(id, isFavorite);

      // Update Firestore
      await _vocabularyCollection.doc(id).update({'isFAv': isFavorite});

      // Notify listeners after updating Firestore
      notifyListeners();
    } catch (e) {
      if (kDebugMode) {
        print('Error updating favorite status: $e');
      }
    }
  }

  void _updateLocalFavoriteStatus(String id, bool isFavorite) {
    // Find the WordModel in the list and update the isFAv field locally
    final index = _vocabularyList.indexWhere((element) => element.id == id);
    if (index != -1) {
      _vocabularyList[index] =
          _vocabularyList[index].copyWith(isFAv: isFavorite);
    }
  }

  Future<void> playAudio(String audioUrl) async {
    toggleAudioPlaying();
    final player = audio.AudioPlayer();
    await player.play(UrlSource(audioUrl));
    toggleAudioPlaying();
  }

   void search(String query) {
    if (query.isEmpty) {
      _vocabularyList = List.from(_originalVocabularyList);
    } else {
      _vocabularyList = _originalVocabularyList
          .where((wordModel) =>
              wordModel.word.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }

    notifyListeners();
  }
}

final getVocabularyService =
    ChangeNotifierProvider<GetVocabularyService>((ref) {
  final service = GetVocabularyService();
  service.fetchInitialData();
  return service;
});