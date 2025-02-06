import 'package:caaso_app/common/secure_storage.dart';
import 'package:caaso_app/models/user_data.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'api_service.dart';

class AuthService {
  final ApiService api;

  AuthService(this.api);

  Future<UserData> getUser() async {
    SecureStorage storage = SecureStorage();
    String? token = await storage.getAccessToken();
    if (token == null) {
      throw Exception("Not logged in");
    }
    final data = await api.get('/users/me', token);
    return UserData.fromJson(data);
  }

  Future<User?> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential
    await FirebaseAuth.instance.signInWithCredential(credential);

    return FirebaseAuth.instance.currentUser;
  }

  Future<UserData> login(String idToken) async {
    final data = await api.post('/user/login', {}, idToken);
    SecureStorage storage = SecureStorage();
    await storage.setAccessToken(data['token']);
    return UserData.fromJson(data['user']);
  }

  Future<UserData> create(UserData userData, String idToken) async {
    final data = await api.post('/user/create', userData.toJson(), idToken);
    return UserData.fromJson(data['user']);
  }

  Future<void> logoutWithGoogle() async {
    final GoogleSignIn googleSignIn = GoogleSignIn();
    await googleSignIn.signOut();
    SecureStorage storage = SecureStorage();
    await storage.clearStorage();
  }
}
