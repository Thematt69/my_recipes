import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:fpdart/fpdart.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:my_recipes/blocs/bloc_provider.dart';
import 'package:my_recipes/extensions/exception.dart';
import 'package:my_recipes/fridge_firebase_options.dart';

class FirebaseAuthBloc extends BlocBase {
  final _fridgeInstance = FirebaseAuth.instanceFor(
    app: Firebase.app(FridgeFirebaseOptions.name),
  );
  final _instance = FirebaseAuth.instance;

  User? get currentUser => _fridgeInstance.currentUser;

  @override
  void dispose() {}

  @override
  void initState() {
    _fridgeInstance.setLanguageCode('fr');
    _instance.setLanguageCode('fr');
  }

  Future<Either<UserCredential?, String>> createUserWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final user = await _fridgeInstance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      await _instance.signInAnonymously();
      return left(user);
    } catch (e) {
      final exception = e.logException();
      return right(exception);
    }
  }

  Future<Either<UserCredential, String>> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final userCredential = await _fridgeInstance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      await _instance.signInAnonymously();
      return left(userCredential);
    } catch (e) {
      final exception = e.logException();
      return right(exception);
    }
  }

  Future<Either<UserCredential?, String>> signInWithGoogle() async {
    try {
      if (kIsWeb) {
        final googleProvider = GoogleAuthProvider()
            .addScope('https://www.googleapis.com/auth/userinfo.profile');

        final user = await _fridgeInstance.signInWithPopup(googleProvider);
        await _instance.signInAnonymously();
        return left(user);
      } else {
        final googleUser = await GoogleSignIn().signIn();

        final googleAuth = await googleUser?.authentication;

        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth?.accessToken,
          idToken: googleAuth?.idToken,
        );

        final user = await _fridgeInstance.signInWithCredential(credential);
        await _instance.signInAnonymously();
        return left(user);
      }
    } catch (e) {
      final exception = e.logException();
      return right(exception);
    }
  }

  Future<Either<void, String>> signOut() async {
    try {
      await _fridgeInstance.signOut();
      await _instance.signOut();
      return left(null);
    } catch (e) {
      final exception = e.logException();
      return right(exception);
    }
  }

  Future<Either<void, String>> sendEmailVerification() async {
    try {
      await currentUser?.sendEmailVerification();
      return left(null);
    } catch (e) {
      final exception = e.logException();
      return right(exception);
    }
  }

  Future<Either<void, String>> updateDisplayName(String displayName) async {
    try {
      await currentUser?.updateDisplayName(displayName);
      return left(null);
    } catch (e) {
      final exception = e.logException();
      return right(exception);
    }
  }

  Future<Either<void, String>> deleteCurrentUser() async {
    try {
      await _fridgeInstance.currentUser?.delete();
      await _instance.currentUser?.delete();
      return left(null);
    } catch (e) {
      final exception = e.logException();
      return right(exception);
    }
  }

  Future<Either<void, String>> sendPasswordResetEmail(String email) async {
    try {
      await _fridgeInstance.sendPasswordResetEmail(email: email);
      return left(null);
    } catch (e) {
      final exception = e.logException();
      return right(exception);
    }
  }
}
