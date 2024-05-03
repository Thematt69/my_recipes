import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fpdart/fpdart.dart' as fpdart;
import 'package:my_apps/extensions/build_context.dart';
import 'package:my_apps/widgets/sign_in_form.dart';
import 'package:my_recipes/app_router.dart';
import 'package:my_recipes/blocs/bloc_provider.dart';
import 'package:my_recipes/blocs/firebase_auth_bloc.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  late final _authBloc = BlocProvider.of<FirebaseAuthBloc>(context);
  final _formKey = GlobalKey<FormState>();

  void _afterSignIn(fpdart.Either<UserCredential?, String> result) {
    result.match(
      (user) {
        if (user != null) {
          context.goNamed(AppRoute.recipes.name);
        }
      },
      (exception) => context.showErrorSnackBar(exception),
    );
  }

  Future<void> _signIn(String email, String password) async {
    if (_formKey.currentState?.validate() ?? false) {
      await _authBloc
          .signInWithEmailAndPassword(
            email: email,
            password: password,
          )
          .then(_afterSignIn);
    }
  }

  Future<void> _signUp(String email, String password) async {
    if (_formKey.currentState?.validate() ?? false) {
      await _authBloc
          .createUserWithEmailAndPassword(
            email: email,
            password: password,
          )
          .then(_afterSignIn);
    }
  }

  Future<void> _signInWithGoogle() async =>
      _authBloc.signInWithGoogle().then(_afterSignIn);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SignInForm(
        logoAsset: 'assets/images/menu_book.png',
        googleLogoAsset: 'assets/images/google.png',
        onSignIn: _signIn,
        onSignUp: _signUp,
        onSignInWithGoogle: _signInWithGoogle,
        formKey: _formKey,
      ),
    );
  }
}
