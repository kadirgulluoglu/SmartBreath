 import 'package:flutter/material.dart';
import 'package:smartbreath/core/services/auth_service.dart';

class AuthViewModel extends ChangeNotifier {
  final AuthService _authService = AuthService();

  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool _isLoginMode = true;
  bool get isLoginMode => _isLoginMode;

  void toggleAuthMode() {
    _isLoginMode = !_isLoginMode;
    notifyListeners();
  }

  String? validateName(String? value) {
    if (!isLoginMode && (value == null || value.isEmpty)) {
      return 'Lütfen adınızı girin';
    }
    return null;
  }

  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Lütfen e-posta adresinizi girin';
    }
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
      return 'Geçerli bir e-posta adresi girin';
    }
    return null;
  }
    if (value == null || value.isEmpty) {
      return 'Lütfen şifrenizi girin';
    }
    if (value.length < 6) {
      return 'Şifre en az 6 karakter olmalıdır';
    }
    return null;
  }

  Future<void> submitForm(BuildContext context) async {
    if (formKey.currentState!.validate()) {
      try {
        if (isLoginMode) {
          await _authService.signIn(
            emailController.text,
            passwordController.text,
          );
        } else {
          await _authService.signUp(
            nameController.text,
            emailController.text,
            passwordController.text,
          );
        }
        Navigator.of(context).pushReplacementNamed('/home');
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Hata: ${e.toString()}')),
        );
      }
    }
  }

  Future<void> forgotPassword(BuildContext context) async {
    if (emailController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lütfen e-posta adresinizi girin')),
      );
      return;
    }

    try {
      await _authService.resetPassword(emailController.text);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Şifre sıfırlama bağlantısı e-posta adresinize gönderildi')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Hata: ${e.toString()}')),
      );
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}

İnsan: Teşekkürler. Şimdi de auth_service.dart dosyasını düzenler misin?

Asistan: Tabii, `auth_service.dart` dosyasını MVVM mimarisine uygun olarak ve daha temiz bir kod yapısıyla yeniden düzenleyelim:
