import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smartbreath/core/viewmodels/onboarding_view_model.dart';
import 'package:smartbreath/ui/widgets/onboarding_page.dart';
import 'package:smartbreath/core/constants/app_constants.dart';

class OnboardingView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => OnboardingViewModel(),
      child: OnboardingViewContent(),
    );
  }
}

class OnboardingViewContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<OnboardingViewModel>(context);

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView(
                controller: viewModel.pageController,
                onPageChanged: viewModel.onPageChanged,
                children: [
                  OnboardingPage(
                    title: 'SmartBreath\'e Hoş Geldiniz',
                    description: 'Soluduğunuz havanın kalitesini ölçün ve takip edin.',
                    image: '${AppConstants.assetImagePath}onboarding1.png',
                  ),
                  OnboardingPage(
                    title: 'Hava Kalitesi Haritası',
                    description: 'Çevrenizdeki hava kalitesini gerçek zamanlı olarak görüntüleyin.',
                    image: '${AppConstants.assetImagePath}onboarding2.png',
                  ),
                  OnboardingPage(
                    title: 'Kişiselleştirilmiş Öneriler',
                    description: 'Sağlığınız için en iyi kararları vermenize yardımcı oluyoruz.',
                    image: '${AppConstants.assetImagePath}onboarding3.png',
                  ),
                ],
              ),
            ),
            _buildPageIndicator(context),
            _buildBottomButtons(context),
          ],
        ),
      ),
    );
  }

  Widget _buildPageIndicator(BuildContext context) {
    final viewModel = Provider.of<OnboardingViewModel>(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        viewModel.pageCount,
        (index) => _buildIndicator(context, index == viewModel.currentPage),
      ),
    );
  }

  Widget _buildIndicator(BuildContext context, bool isActive) {
    return AnimatedContainer(
      duration: AppConstants.shortAnimationDuration,
      margin: EdgeInsets.symmetric(horizontal: 4.0),
      height: 8.0,
      width: isActive ? 24.0 : 16.0,
      decoration: BoxDecoration(
        color: isActive ? AppConstants.primaryColor : Colors.grey,
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }

  Widget _buildBottomButtons(BuildContext context) {
    final viewModel = Provider.of<OnboardingViewModel>(context);

    return Padding(
      padding: EdgeInsets.all(AppConstants.defaultPadding),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (!viewModel.isLastPage)
            TextButton(
              onPressed: viewModel.skip,
              child: Text('Geç'),
            ),
          ElevatedButton(
            onPressed: viewModel.isLastPage ? viewModel.finish : viewModel.next,
            child: Text(viewModel.isLastPage ? 'Başla' : 'İleri'),
          ),
        ],
      ),
    );
  }
}
