// Système de gestion d'erreurs pour l'application
// Utilise le pattern Result<T> pour une gestion d'erreurs type-safe

// Classe de base pour tous les résultats
sealed class Result<T> {
  const Result();

  // Vérifie si le résultat est un succès
  bool get isSuccess => this is Success<T>;

  // Vérifie si le résultat est un échec
  bool get isFailure => this is Failure<T>;

  // Récupère la donnée si succès, sinon null
  T? get dataOrNull => switch (this) {
    Success(data: final data) => data,
    Failure() => null,
  };

  // Récupère l'erreur si échec, sinon null
  Failure? get errorOrNull => switch (this) {
    Success() => null,
    Failure() => this as Failure<T>,
  };

  // Pattern matching sur le résultat
  R when<R>({
    required R Function(T data) success,
    required R Function(Failure failure) failure,
  }) {
    return switch (this) {
      Success(data: final data) => success(data),
      Failure() => failure(this as Failure<T>),
    };
  }
}

// Résultat de succès contenant des données
class Success<T> extends Result<T> {
  final T data;

  const Success(this.data);

  @override
  String toString() => 'Success($data)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is Success<T> && data == other.data;

  @override
  int get hashCode => data.hashCode;
}

// Résultat d'échec contenant une erreur
class Failure<T> extends Result<T> {
  final String message;
  final Exception? exception;
  final StackTrace? stackTrace;

  const Failure({required this.message, this.exception, this.stackTrace});

  @override
  String toString() => 'Failure(message: $message, exception: $exception)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Failure<T> &&
          message == other.message &&
          exception == other.exception;

  @override
  int get hashCode => Object.hash(message, exception);
}

// Types d'erreurs spécifiques
class DatabaseFailure<T> extends Failure<T> {
  const DatabaseFailure({
    required super.message,
    super.exception,
    super.stackTrace,
  });
}

class NotFoundFailure<T> extends Failure<T> {
  const NotFoundFailure({
    required super.message,
    super.exception,
    super.stackTrace,
  });
}

class ValidationFailure<T> extends Failure<T> {
  const ValidationFailure({
    required super.message,
    super.exception,
    super.stackTrace,
  });
}

class NetworkFailure<T> extends Failure<T> {
  const NetworkFailure({
    required super.message,
    super.exception,
    super.stackTrace,
  });
}

// Extension pour faciliter la création de Result depuis des Futures
extension FutureResultExtension<T> on Future<T> {
  // Convertit une Future en Future<Result<T>>
  Future<Result<T>> toResult() async {
    try {
      final data = await this;
      return Success(data);
    } catch (e, stackTrace) {
      return Failure(
        message: e.toString(),
        exception: e is Exception ? e : Exception(e.toString()),
        stackTrace: stackTrace,
      );
    }
  }
}
