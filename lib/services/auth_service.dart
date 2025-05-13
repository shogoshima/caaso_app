import 'package:caaso_app/models/user_data.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'api_service.dart';

class AuthService {
  static final AuthService _instance = AuthService._internal();
  final GoogleSignIn _googleSignIn = GoogleSignIn(); // Single instance

  AuthService._internal();

  factory AuthService() {
    return _instance;
  }

  Future<UserData> getUser() async {
    final data = await ApiService().get('/auth/profile');
    return UserData.fromJson(data['user']);
  }

  Future<UserData> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
    if (googleUser == null) {
      // The user canceled the sign-in
      throw Exception('Google sign-in aborted');
    }

    // Obtain the auth details from the request
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    // Once signed in, return the UserCredential
    await FirebaseAuth.instance.signInWithCredential(credential);

    if (FirebaseAuth.instance.currentUser == null) {
      throw Exception('Erro ao realizar login com Google.');
    }

    final data = await ApiService().post('/login', {});
    return UserData.fromJson(data['user']);
  }

  Future<void> signUpWithEmail({
    required String displayName,
    required String email,
    required String password,
  }) async {
    try {
      final credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = credential.user;
      if (user != null) {
        // Update user profile
        await user.updateDisplayName(displayName);
        final defaultAvatar =
            'https://ui-avatars.com/api/?name=$displayName&background=0D8ABC&color=fff';
        await user.updatePhotoURL(defaultAvatar);

        await ApiService().post('/login', {});

        // Send email verification
        try {
          await user.sendEmailVerification();
        } on FirebaseAuthException catch (e) {
          throw Exception('Erro ao enviar código de verificação: ${e.message}');
        }
      } else {
        throw Exception('Erro ao criar usuário.');
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        throw Exception('A senha é muito fraca.');
      } else if (e.code == 'email-already-in-use') {
        throw Exception(
            'Você já possui uma conta com esse email. Tente outra forma de login.');
      }
      throw Exception('Erro ao criar usuário: ${e.message}');
    }
  }

  Future<UserData> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = credential.user;
      if (user == null) {
        throw Exception('Erro ao realizar login.');
      }

      final data = await ApiService().post('/login', {});
      return UserData.fromJson(data['user']);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'invalid-credential') {
        throw Exception('Email ou senha inválidos. ');
      }
      throw Exception('Erro ao realizar login: ${e.message}');
    }
  }

  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        throw Exception('Usuário não encontrado.');
      }
      throw Exception('Erro no envio do email de recuperação: ${e.message}');
    }
  }

  Future<void> logout() async {
    await _googleSignIn.signOut();
    await FirebaseAuth.instance.signOut();
  }
}
