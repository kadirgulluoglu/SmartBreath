import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:smartbreath/core/models/user_model.dart';
import 'package:smartbreath/core/exceptions/auth_exception.dart';

class AuthService {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
// Mevcut kullanıcıyı al
  UserModel? get currentUser {
    final user = auth.currentUser;
    if (user != null) {
      return UserModel(
        uid: user.uid,
        email: user.email,
        name: user.displayName,
      );
    }
    return null;
  }

// Kullanıcı girişi
  Future<UserModel> signIn(String email, String password) async {
    try {
      final userCredential = await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = userCredential.user;
      if (user == null) {
        throw AuthException('Giriş başarısız oldu');
      }
      return await getUserDetails(user.uid);
    } on FirebaseAuthException catch (e) {
      throw AuthException(getMessageFromErrorCode(e.code));
    }
  }

// Yeni kullanıcı kaydı
  Future<UserModel> signUp(String name, String email, String password) async {
    try {
      final userCredential = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = userCredential.user;
      if (user == null) {
        throw AuthException('Kayıt başarısız oldu');
      }
      await user.updateDisplayName(name);
      await saveUserDetails(UserModel(
        uid: user.uid,
        email: email,
        name: name,
      ));
      return await getUserDetails(user.uid);
    } on FirebaseAuthException catch (e) {
      throw AuthException(getMessageFromErrorCode(e.code));
    }
  }

// Kullanıcı çıkışı
  Future<void> signOut() async {
    await auth.signOut();
  }

// Şifre sıfırlama
  Future<void> resetPassword(String email) async {
    try {
      await auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw AuthException(getMessageFromErrorCode(e.code));
    }
  }

// Kullanıcı detaylarını Firestore'dan al
  Future<UserModel> getUserDetails(String uid) async {
    final doc = await firestore.collection('users').doc(uid).get();
    return UserModel.fromMap(doc.data() ?? {});
  }

// Kullanıcı detaylarını Firestore'a kaydet
  Future<void> saveUserDetails(UserModel user) async {
    await firestore.collection('users').doc(user.uid).set(user.toMap());
  }

// Firebase hata kodlarını anlaşılır mesajlara çevir
  String getMessageFromErrorCode(String errorCode) {
    switch (errorCode) {
      case "ERROR_EMAIL_ALREADY_IN_USE":
      case "account-exists-with-different-credential":
      case "email-already-in-use":
        return "Bu e-posta adresi zaten kullanımda.";
      case "ERROR_WRONG_PASSWORD":
      case "wrong-password":
        return "Yanlış e-posta/şifre kombinasyonu.";
      case "ERROR_USER_NOT_FOUND":
      case "user-not-found":
        return "Bu e-posta adresine sahip bir kullanıcı bulunamadı.";
      case "ERROR_USER_DISABLED":
      case "user-disabled":
        return "Kullanıcı devre dışı bırakıldı.";
      case "ERROR_TOO_MANY_REQUESTS":
      case "operation-not-allowed":
        return "Bu hesap için çok fazla istek var. Lütfen daha sonra tekrar deneyin.";
      case "ERROR_OPERATION_NOT_ALLOWED":
        return "Sunucu hatası, lütfen daha sonra tekrar deneyin.";
      case "ERROR_INVALID_EMAIL":
      case "invalid-email":
        return "E-posta adresi geçersiz.";
      default:
        return "Giriş başarısız oldu. Lütfen tekrar deneyin.";
    }
  }
}
