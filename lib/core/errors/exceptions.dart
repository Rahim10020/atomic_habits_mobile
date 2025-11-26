// Exceptions personnalisées pour l'application

/// Exception de base pour l'application
class AppException implements Exception {
  final String message;
  final dynamic originalException;
  final StackTrace? stackTrace;

  const AppException({
    required this.message,
    this.originalException,
    this.stackTrace,
  });

  @override
  String toString() => 'AppException: $message';
}

/// Exception liée à la base de données
class DatabaseException extends AppException {
  const DatabaseException({
    required super.message,
    super.originalException,
    super.stackTrace,
  });

  @override
  String toString() => 'DatabaseException: $message';
}

/// Exception pour les entités non trouvées
class NotFoundException extends AppException {
  final String entityName;
  final dynamic entityId;

  const NotFoundException({
    required this.entityName,
    required this.entityId,
    super.stackTrace,
  }) : super(message: '$entityName with id $entityId not found');

  @override
  String toString() => 'NotFoundException: $message';
}

/// Exception de validation
class ValidationException extends AppException {
  final Map<String, String> errors;

  ValidationException({
    required super.message,
    this.errors = const {},
    super.stackTrace,
  });

  @override
  String toString() => 'ValidationException: $message (errors: $errors)';
}

/// Exception de duplication
class DuplicateException extends AppException {
  final String field;
  final dynamic value;

  DuplicateException({
    required this.field,
    required this.value,
    super.stackTrace,
  }) : super(message: 'Duplicate value for $field: $value');

  @override
  String toString() => 'DuplicateException: $message';
}

/// Exception réseau
class NetworkException extends AppException {
  const NetworkException({
    required super.message,
    super.originalException,
    super.stackTrace,
  });

  @override
  String toString() => 'NetworkException: $message';
}

/// Exception de notification
class NotificationException extends AppException {
  const NotificationException({
    required super.message,
    super.originalException,
    super.stackTrace,
  });

  @override
  String toString() => 'NotificationException: $message';
}

/// Exception de permission
class PermissionException extends AppException {
  final String permission;

  PermissionException({required this.permission, super.stackTrace})
    : super(message: 'Permission denied: $permission');

  @override
  String toString() => 'PermissionException: $message';
}
