import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smartbreath/core/viewmodels/profile_view_model.dart';
import 'package:smartbreath/ui/widgets/profile_image_widget.dart';
import 'package:smartbreath/ui/widgets/notification_toggle_widget.dart';
import 'package:smartbreath/ui/widgets/theme_toggle_widget.dart';
import 'package:smartbreath/core/theme/app_theme.dart';  // Bu satırı ekleyin

class ProfileView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ProfileViewModel(),
      child: ProfileViewContent(),
    );
  }
}

class ProfileViewContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<ProfileViewModel>(context);
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: viewModel.isLoading
          ? Center(child: CircularProgressIndicator())
          : Container(
              width: size.width,
              height: size.height * 0.91,
              child: ListView(
                children: <Widget>[
                  SizedBox(height: 40.0),
                  Center(
                    child: Text(
                      "Profilim",
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(height: 20.0),
                  ProfileImageWidget(),
                  SizedBox(height: size.height * .03),
                  NotificationToggleWidget(),
                  SizedBox(height: size.height * .03),
                  ThemeToggleWidget(),
                  _buildHelpButton(context),
                  _buildLogoutButton(context),
                ],
              ),
            ),
    );
  }

  Widget _buildHelpButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextButton(
        onPressed: () => Provider.of<ProfileViewModel>(context, listen: false).showHelpPage(context),
        child: Text(
          'Sıkça Sorulan Sorular',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppTheme.primaryGreen,  // Bu satırı ekleyin
          ),
        ),
      ),
    );
  }

  Widget _buildLogoutButton(BuildContext context) {
    return TextButton(
      onPressed: () => Provider.of<ProfileViewModel>(context, listen: false).logout(context),
      child: Text(
        'Çıkış Yap',
        style: TextStyle(
          color: Colors.red,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}