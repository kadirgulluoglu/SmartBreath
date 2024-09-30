import 'package:flutter/material.dart';
import 'package:smartbreath/core/services/auth_service.dart';
import 'package:smartbreath/core/services/image_service.dart';
import 'package:smartbreath/core/services/notification_service.dart';
import 'package:smartbreath/core/services/theme_service.dart';
import 'package:smartbreath/ui/views/help_page.dart';
import 'package:smartbreath/ui/views/login_view.dart';

class ProfileViewModel extends ChangeNotifier {
  final AuthService _authService;
  final ImageService _imageService;
  final NotificationService _notificationService;
  final ThemeService _themeService;

  bool _isLoading = true;
  String _userName = '';
  String? _profileImageUrl;
  bool _notificationsEnabled = true;
  bool _isDarkMode = false;

  ProfileViewModel({
    required AuthService authService,
    required ImageService imageService,
    required NotificationService notificationService,
    required ThemeService themeService,
  })  : _authService = authService,
        _imageService = imageService,
        _notificationService = notificationService,
        _themeService = themeService {
    _init();
  }

  bool get isLoading => _isLoading;
  String get userName => _userName;
  String? get profileImageUrl => _profileImageUrl;
  bool get notificationsEnabled => _notificationsEnabled;
  bool get isDarkMode => _isDarkMode;

  Future<void> _init() async {
    _isLoading = true;
    notifyListeners();

    final user = await _authService.getCurrentUser();
    _userName = user?.displayName ?? '';
    _profileImageUrl = await _imageService.getProfileImageUrl();
    _notificationsEnabled = await _notificationService.areNotificationsEnabled();
    _isDarkMode = await _themeService.isDarkMode();

    _isLoading = false;
    notifyListeners();
  }

  Future<void> updateProfileImage(ImageSource source) async {
    final newImageUrl = await _imageService.updateProfileImage(source);
    if (newImageUrl != null) {
      _profileImageUrl = newImageUrl;
      notifyListeners();
    }
  }

  Future<void> toggleNotifications() async {
    _notificationsEnabled = await _notificationService.toggleNotifications();
    notifyListeners();
  }

  Future<void> toggleTheme() async {
    _isDarkMode = await _themeService.toggleTheme();
    notifyListeners();
  }

  void showHelpPage(BuildContext context) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => HelpPage()));
  }

  Future<void> logout(BuildContext context) async {
    await _authService.signOut();
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => LoginView()));
  }
}