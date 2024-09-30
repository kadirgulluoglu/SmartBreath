import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smartbreath/core/viewmodels/lo_comments_view_model.dart';
import 'package:smartbreath/ui/widgets/rating_widget.dart';
import 'package:smartbreath/ui/widgets/comment_input_widget.dart';
import 'package:smartbreath/core/theme/app_theme.dart';

class LoCommentsView extends StatelessWidget {
  final LatLng locId;
  final double initialRating;
  final String placeName;

  const LoCommentsView({
    Key? key,
    required this.locId,
    required this.initialRating,
    required this.placeName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => LoCommentsViewModel(locId, initialRating, placeName),
      child: LoCommentsViewContent(),
    );
  }
}

class LoCommentsViewContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<LoCommentsViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(viewModel.placeName),
        backgroundColor: AppTheme.primaryGreen,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Değerlendirmeniz',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            RatingWidget(
              rating: viewModel.rating,
              onRatingUpdate: viewModel.updateRating,
            ),
            SizedBox(height: 20),
            CommentInputWidget(
              controller: viewModel.commentController,
              onSubmit: viewModel.submitComment,
            ),
          ],
        ),
      ),
    );
  }
}