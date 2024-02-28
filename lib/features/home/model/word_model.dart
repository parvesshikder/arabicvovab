import 'package:audioplayers/audioplayers.dart' as audio;
import 'package:audioplayers/audioplayers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class WordModel {
  final String id;
  final String word;
  final String meaning;
  final String imageUrl;
  final bool isFAv;
  final bool isPlay;
  final String example1;
  final String example2;
  final String explanation;
  final String audioUrl;
  final String partsOfSpeech;

  bool isCurrentlyPlaying;

  WordModel({
    required this.id,
    required this.word,
    required this.meaning,
    required this.imageUrl,
    required this.isFAv,
    required this.isPlay,
    required this.example1,
    required this.example2,
    required this.explanation,
    required this.audioUrl,
    required this.partsOfSpeech,
    this.isCurrentlyPlaying = false,
  });

  WordModel copyWith({
    bool? isFAv,
    bool? isPlay,
    bool? isCurrentlyPlaying,
  }) {
    return WordModel(
      id: this.id,
      word: this.word,
      meaning: this.meaning,
      imageUrl: this.imageUrl,
      isFAv: isFAv ?? this.isFAv,
      isPlay: isPlay ?? this.isPlay,
      example1: this.example1,
      example2: this.example2,
      explanation: this.explanation,
      audioUrl: this.audioUrl,
      partsOfSpeech: this.partsOfSpeech,
      isCurrentlyPlaying: isCurrentlyPlaying ?? this.isCurrentlyPlaying,
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

  final audio.AudioPlayer _audioPlayer = audio.AudioPlayer();
  audio.AudioPlayer get audioPlayer => _audioPlayer;

  String? _currentPlayingAudioUrl;
  bool _isAudioPlaying = false;
  bool get isAudioPlaying => _isAudioPlaying;

  final Map<String, WordModel> _cache = {};

  Future<void> fetchInitialData() async {
    _isLoading = true;

    try {
      if (_cache.isNotEmpty) {
        _vocabularyList = _cache.values.toList();
      } else {
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
            partsOfSpeech: doc['partsOfSpeech'],
          );
        }).toList();

        _vocabularyList.forEach((word) {
          _cache[word.id] = word;
        });
      }

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
      _updateLocalFavoriteStatus(id, isFavorite);
      await _vocabularyCollection.doc(id).update({'isFAv': isFavorite});
      notifyListeners();
    } catch (e) {
      if (kDebugMode) {
        print('Error updating favorite status: $e');
      }
    }
  }

  void _updateLocalFavoriteStatus(String id, bool isFavorite) {
    final index = _vocabularyList.indexWhere((element) => element.id == id);
    if (index != -1) {
      _vocabularyList[index] =
          _vocabularyList[index].copyWith(isFAv: isFavorite);
    }
  }

   Future<void> playAudio(String audioUrl) async {
    toggleAudioPlaying();

    // Start playing the selected audio
    await _audioPlayer.play(UrlSource(audioUrl));

    // Set the currently playing audio URL
    _currentPlayingAudioUrl = audioUrl;

    // Toggle play/pause state after a short delay
    await Future.delayed(const Duration(seconds: 1));
    toggleAudioPlaying();
  }

  void toggleAudioPlaying() {
    _isAudioPlaying = !_isAudioPlaying;
    notifyListeners();
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

  void updatePlayingState(String wordId, bool isCurrentlyPlaying) async {
    final index = _vocabularyList.indexWhere((element) => element.id == wordId);
    if (index != -1) {
      _vocabularyList[index] = _vocabularyList[index].copyWith(
        isCurrentlyPlaying: isCurrentlyPlaying,
      );
      notifyListeners();

      await Future.delayed(const Duration(seconds: 2));

      _vocabularyList[index] = _vocabularyList[index].copyWith(
        isCurrentlyPlaying: false,
      );
      notifyListeners();
    }
  }
}

final getVocabularyService =
    ChangeNotifierProvider<GetVocabularyService>((ref) {
  final service = GetVocabularyService();
  service.fetchInitialData();
  return service;
});
