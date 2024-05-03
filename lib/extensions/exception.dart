import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:logger/logger.dart';

extension ObjectExtension on Object {
  String logException() {
    Logger().e(
      'Erreur capturée : $this',
      error: this,
      stackTrace: StackTrace.current,
    );
    FirebaseCrashlytics.instance.recordError(
      this,
      StackTrace.current,
      reason: 'Erreur capturée : $this',
    );
    return 'Une erreur est survenue, veuillez réessayer ultérieurement';
  }
}

extension FirebaseAuthExceptionExtension on FirebaseAuthException {
  String logException() {
    final message = switch (code) {
      ('provider-already-linked') =>
        "Ce type de compte a déjà été lié à l'utilisateur.",
      ('invalid-credential') => 'Les identifiants ne sont pas valides.',
      ('credential-already-in-use') =>
        'Un compte existe déjà avec ses identifiants.',
      ('user-not-found') => 'Aucun utilisateur trouvé pour cet e-mail.',
      ('wrong-password') => 'Mauvais mot de passe fourni pour cet utilisateur.',
      ('weak-password') => 'Le mot de passe fourni est trop faible.',
      ('email-already-in-use') => 'Le compte existe déjà pour cet e-mail.',
      ('account-exists-with-different-credential') =>
        'Un compte existe déjà avec cet e-mail mais avec un type de connexion différent.',
      ('operation-not-allowed') =>
        'Ce type de compte n’est pas autorisé. Veuillez contacter le support.',
      ('user-disabled') => 'Cette utilisateur a été désactivé.',
      ('invalid-email') => "L'adresse e-mail n'est pas valide.",
      ('requires-recent-login') =>
        "L'heure de la dernière connexion ne respecte pas les critères de sécurité. Veuillez vous reconnecter et réessayer.",
      (_) => "Échec avec code d'erreur: $code"
    };
    Logger().e(
      message,
      error: this,
      stackTrace: stackTrace,
    );
    FirebaseCrashlytics.instance.recordError(
      this,
      stackTrace,
      reason: message,
    );
    return message;
  }
}

extension FirebaseExceptionExtension on FirebaseException {
  String logException() {
    final message = switch (code) {
      ('storage/object-not-found') =>
        "Aucun objet n'existe à la référence souhaitée.",
      ('storage/bucket-not-found') =>
        "Aucun compartiment n'est configuré pour Firebase Storage.",
      ('storage/project-not-found') =>
        'Aucun projet n’est configuré pour Firebase Storage.',
      ('storage/quota-exceeded') => 'Les limites de quota ont été dépassées.',
      ('storage/unauthenticated') =>
        'L’utilisateur n’est pas authentifié. Authentifiez-vous et réessayez.',
      ('storage/unauthorized') =>
        'L’utilisateur n’est pas autorisé à effectuer l’action souhaitée. Veuillez contacter le support.',
      ('storage/retry-limit-exceeded') =>
        'Le nombre maximal de tentatives de transfert a été dépassé. Veuillez réessayer ultérieurement.',
      ('storage/invalid-checksum') =>
        'Le fichier sur le disque ne correspond pas au fichier d’origine. Veuillez réessayer.',
      ('storage/canceled') => "L'utilisateur a annulé l'opération.",
      ('storage/invalid-event-name') =>
        'Le nom de l’événement fourni n’est pas valide. Doit être l’un des suivants: [running, progress, pause]',
      ('storage/invalid-url') =>
        "L'URL fournie ne correspond pas à l'URL attendue.",
      ('storage/invalid-argument') =>
        "Un argument non valide a été fourni à l'opération.",
      ('storage/no-default-bucket') =>
        "Aucun compartiment n'est configuré par défaut et aucun compartiment n'a été fourni. Veuillez contacter le support.",
      ('storage/cannot-slice-blob') =>
        "Le fichier n'a pu être enregistré. Veuillez réessayer.",
      ('storage/server-file-wrong-size') =>
        'Le fichier enregistré ne correspond pas à la taille du fichier d’origine. Veuillez réessayer.',
      (_) => "Échec avec code d'erreur: $code",
    };
    Logger().e(
      message,
      error: this,
      stackTrace: stackTrace,
    );
    FirebaseCrashlytics.instance.recordError(
      this,
      stackTrace,
      reason: message,
    );
    return message;
  }
}
