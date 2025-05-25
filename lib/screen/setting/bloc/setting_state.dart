

// BLoC States
import 'package:playtech_transmitter_app/screen/setting/setting_service.dart';

abstract class SettingsState {}

class SettingsInitial extends SettingsState {}

class SettingsLoading extends SettingsState {}

class SettingsLoaded extends SettingsState {
  final Settings settings;
  final String formattedJson;

  SettingsLoaded(this.settings, this.formattedJson);
}

class SettingsError extends SettingsState {
  final String error;

  SettingsError(this.error);
}
