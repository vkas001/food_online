/// Auth feature barrel.
///
/// Mirrors the `modules/<feature>/index.ts` barrel pattern: exports screens,
/// providers, services, and models together under one entry point.
library;

export 'controllers/auth_provider.dart';
export 'controllers/focus_controller.dart';
export 'screens/login_screen.dart';
export 'screens/signup_screen.dart';
export 'services/auth_service.dart';
export 'services/user_preferences.dart';
export 'services/user_repository.dart';