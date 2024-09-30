import 'package:flutter/material.dart';
import 'package:smartbreath/core/services/firebase_service.dart';

class LoCommentsViewModel extends ChangeNotifier {
  final FirebaseService _firebaseService;
  final LatLng locId;
  final String placeName;

  double _rating;
  final TextEditingController commentController = TextEditingController();

  LoCommentsViewModel(this.locId, this._rating, this.placeName)
      : _firebaseService = FirebaseService();

  double get rating => _rating;

  void updateRating(double newRating) {
    _rating = newRating;
    notifyListeners();
  }

  Future<void> submitComment() async {
    if (commentController.text.isNotEmpty) {
      await _firebaseService.addComment(
        locId,
        _rating,
        commentController.text,
        placeName,
      );
      commentController.clear();
      notifyListeners();
    }
  }

  @override
  void dispose() {
    commentController.dispose();
    super.dispose();
  }
}