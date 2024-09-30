import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smartbreath/core/viewmodels/auth_view_model.dart';
import 'package:smartbreath/ui/widgets/custom_text_field.dart';
import 'package:smartbreath/ui/widgets/custom_button.dart';

class ForgotPasswordView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final authViewModel = Provider.of<AuthViewModel>(context);

    return Scaffold(
      appBar: AppBar(title: Text('Şifremi Unuttum')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            CustomTextField(
              controller: authViewModel.emailController,
              labelText: 'E-posta',
              icon: Icons.email,
              keyboardType: TextInputType.emailAddress,
              validator: authViewModel.validateEmail,
            ),
            SizedBox(height: 24),
            CustomButton(
              text: 'Şifre Sıfırlama Bağlantısı Gönder',
              onPressed: () => authViewModel.resetPassword(context),
            ),
          ],
        ),
      ),
    );
  }
}