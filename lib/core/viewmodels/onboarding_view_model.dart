import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smartbreath/core/constants/app_constants.dart';
class OnboardingViewModel extends ChangeNotifier {
  final PageController pageController = PageController();
  int currentPage = 0;
  final int pageCount = 3;
  int get currentPage => currentPage;
  bool get isLastPage => currentPage == pageCount - 1;
  void onPageChanged(int page) {
    currentPage = page;
    notifyListeners();
  }
  void next() {
    if (currentPage < pageCount - 1) {
      pageController.nextPage(
        duration: AppConstants.mediumAnimationDuration,
        curve: Curves.easeInOut,
      );
    }
  }
  void skip() {
    pageController.animateToPage(
      pageCount - 1,
      duration: AppConstants.mediumAnimationDuration,
      curve: Curves.easeInOut,
    );
  }

  Future<void> finish() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(AppConstants.onboardingCompletedKey, true);
  }
  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }
}
import 'package:flutter/material.dart';
import 'package:smartbreath/core/constants/app_constants.dart';
class OnboardingPage extends StatelessWidget {
  final String title;
  final String description;
  final String image;
  const OnboardingPage({
    Key? key,
    required this.title,
    required this.description,
    required this.image,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(AppConstants.defaultPadding),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            image,
            height: 300,
            width: 300,
          ),
          SizedBox(height: AppConstants.defaultPadding),
          Text(
            title,
            style: AppConstants.headingStyle,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: AppConstants.defaultPadding / 2),
          Text(
            description,
            style: AppConstants.bodyStyle,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}