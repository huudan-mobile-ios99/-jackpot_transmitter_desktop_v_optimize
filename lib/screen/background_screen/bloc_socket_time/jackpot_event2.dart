
 class JackpotEvent2 {}
class JackpotHitReceived extends JackpotEvent2 {
  final Map<String, dynamic> hit;
  JackpotHitReceived(this.hit);
}

class JackpotInitialConfigReceived extends JackpotEvent2 {
  final Map<String, dynamic> config;
  JackpotInitialConfigReceived(this.config);
}

class JackpotUpdatedConfigReceived extends JackpotEvent2 {
  final Map<String, dynamic> config;
  JackpotUpdatedConfigReceived(this.config);
}

class JackpotHideImagePage extends JackpotEvent2 {
   JackpotHideImagePage();
}

class JackpotConnect extends JackpotEvent2 {}

class JackpotDisconnect extends JackpotEvent2 {}

class JackpotReconnect extends JackpotEvent2 {}

class JackpotError extends JackpotEvent2 {
  final String error;
  JackpotError(this.error);
}

class JackpotReconnectAttempt extends JackpotEvent2 {
  final int attempt;
  JackpotReconnectAttempt(this.attempt);
}

class JackpotReconnectError extends JackpotEvent2 {
  final String error;
  JackpotReconnectError(this.error);
}
