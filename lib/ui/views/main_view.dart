import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smartbreath/core/viewmodels/main_view_model.dart';
import 'package:smartbreath/ui/views/home_view.dart';
import 'package:smartbreath/ui/views/map_view.dart';
import 'package:smartbreath/ui/views/profile_view.dart';
import 'package:smartbreath/ui/widgets/custom_bottom_navigation_bar.dart';

class MainView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => MainViewModel(),
      child: MainViewContent(),
    );
  }
}

class MainViewContent extends StatelessWidget {
  final List<Widget> _screens = [
    HomeView(),
    MapView(),
    ProfileView(),
  ];

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<MainViewModel>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: IndexedStack(
        index: viewModel.selectedIndex,
        children: _screens,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              blurRadius: 20,
              color: Colors.black.withOpacity(.1),
            )
          ],
        ),
        child: SafeArea(
          child: CustomBottomNavigationBar(
            selectedIndex: viewModel.selectedIndex,
            onItemSelected: viewModel.setSelectedIndex,
          ),
        ),
      ),
    );
  }
}