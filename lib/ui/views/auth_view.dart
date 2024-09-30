import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smartbreath/core/viewmodels/auth_view_model.dart';
import 'package:smartbreath/ui/widgets/custom_text_field.dart';
import 'package:smartbreath/ui/widgets/custom_button.dart';
import 'package:smartbreath/core/constants/app_constants.dart';
import 'package:smartbreath/ui/views/forgot_password_view.dart';
import 'package:smartbreath/ui/views/signup_view.dart';

class AuthView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AuthViewModel(),
      child: AuthViewContent(),
    );
  }
}

class AuthViewContent extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final authViewModel = Provider.of<AuthViewModel>(context);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: 48),
                Text(
                  'Giriş Yap',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 24),
                CustomTextField(
                  controller: authViewModel.emailController,
                  labelText: 'E-posta',
                  icon: Icons.email,
                  keyboardType: TextInputType.emailAddress,
                  validator: authViewModel.validateEmail,
                ),
                SizedBox(height: 16),
                CustomTextField(
                  controller: authViewModel.passwordController,
                  labelText: 'Şifre',
                  icon: Icons.lock,
                  obscureText: true,
                  validator: authViewModel.validatePassword,
                ),
                SizedBox(height: 24),
                CustomButton(
                  text: 'Giriş Yap',
                  onPressed: () => _submitForm(context),
                ),
                SizedBox(height: 16),
                TextButton(
                  child: Text('Şifremi Unuttum'),
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => ForgotPasswordView()),
                  ),
                ),
                SizedBox(height: 16),
                TextButton(
                  child: Text('Hesabın yok mu? Kayıt Ol'),
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => SignupView()),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _submitForm(BuildContext context) async {
    final authViewModel = Provider.of<AuthViewModel>(context, listen: false);
    if (_formKey.currentState!.validate()) {
      bool success = await authViewModel.signIn();
      if (success) {
        Navigator.of(context).pushReplacementNamed('/home');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Giriş başarısız oldu')),
        );
      }
    }
  }
}