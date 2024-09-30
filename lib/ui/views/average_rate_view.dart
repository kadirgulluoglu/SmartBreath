import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smartbreath/core/viewmodels/average_rate_view_model.dart';
import 'package:smartbreath/ui/widgets/rating_widget.dart';
import 'package:smartbreath/ui/widgets/comment_list_widget.dart';
import 'package:smartbreath/core/theme/app_theme.dart';

class AverageRateView extends StatelessWidget {
  final LatLng targetPos;

  const AverageRateView({Key? key, required this.targetPos}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AverageRateViewModel(targetPos),
      child: AverageRateViewContent(),
    );
  }
}

class AverageRateViewContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<AverageRateViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Ortalama Değerlendirme'),
        backgroundColor: AppTheme.primaryGreen,
      ),
      body: viewModel.isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: 20),
                  Text(
                    'Ortalama Puan',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  RatingWidget(rating: viewModel.averageRating),
                  SizedBox(height: 20),
                  Text(
                    'Yorumlar',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  CommentListWidget(comments: viewModel.comments),
                ],
              ),
            ),
    );
  }
}