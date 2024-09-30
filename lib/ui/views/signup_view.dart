import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smartbreath/core/viewmodels/auth_view_model.dart';
import 'package:smartbreath/ui/widgets/custom_text_field.dart';
import 'package:smartbreath/ui/widgets/custom_button.dart';

class SignupView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final authViewModel = Provider.of<AuthViewModel>(context);

    return Scaffold(
      appBar: AppBar(title: Text('Kayıt Ol')),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            CustomTextField(
              controller: authViewModel.nameController,
              labelText: 'Ad Soyad',
              icon: Icons.person,
              validator: authViewModel.validateName,
            ),
            SizedBox(height: 16),
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
              text: 'Kayıt Ol',
              onPressed: () => authViewModel.signUp(context),
            ),
          ],
        ),
      ),
    );
  }
}