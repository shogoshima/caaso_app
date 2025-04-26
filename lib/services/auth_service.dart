import 'package:caaso_app/common/secure_storage.dart';
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
    SecureStorage storage = SecureStorage();
    String? token = await storage.getAccessToken();
    if (token == null) {
      throw Exception("Not logged in");
    }
    final data = await ApiService().get('/auth/profile', token);
    return UserData.fromJson(data['user']);
  }

  Future<User?> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
    if (googleUser == null) return null;

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

    return FirebaseAuth.instance.currentUser;
  }

  Future<UserData> login(String idToken) async {
    final data = await ApiService().post('/login', {}, idToken);
    SecureStorage storage = SecureStorage();
    await storage.setAccessToken(data['token']);
    return UserData.fromJson(data['user']);
  }

  Future<void> logoutWithGoogle() async {
    await _googleSignIn.signOut();
    SecureStorage storage = SecureStorage();
    await storage.clearStorage();
  }
}
