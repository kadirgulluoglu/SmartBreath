import 'package:flutter/material.dart';
import 'package:smartbreath/core/services/firebase_service.dart';
import 'package:smartbreath/core/models/comment_model.dart';

class AverageRateViewModel extends ChangeNotifier {
  final FirebaseService _firebaseService;
  final LatLng targetPos;

  bool _isLoading = true;
  double _averageRating = 0.0;
  List<CommentModel> _comments = [];

  AverageRateViewModel(this.targetPos) : _firebaseService = FirebaseService() {
    _loadData();
  }

  bool get isLoading => _isLoading;
  double get averageRating => _averageRating;
  List<CommentModel> get comments => _comments;

  Future<void> _loadData() async {
    _isLoading = true;
    notifyListeners();

    try {
      _averageRating = await _firebaseService.getAverageRating(targetPos);
      _comments = await _firebaseService.getComments(targetPos);
    } catch (e) {
      print('Error loading data: $e');
    }

    _isLoading = false;
    notifyListeners();
  }
}