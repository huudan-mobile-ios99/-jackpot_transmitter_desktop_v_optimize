
// Settings BLoC
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:playtech_transmitter_app/screen/setting/bloc/setting_event.dart';
import 'package:playtech_transmitter_app/screen/setting/bloc/setting_state.dart';
import 'package:playtech_transmitter_app/screen/setting/setting_service.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  SettingsBloc() : super(SettingsInitial()) {
    on<LoadSettingsEvent>(_onLoadSettings);
  }

  Future<void> _onLoadSettings(LoadSettingsEvent event, Emitter<SettingsState> emit) async {
    emit(SettingsLoading());
    try {
      // Load JSON from assets (requires BuildContext, so this is simplified for demo)
      // In a real app, pass BuildContext or use a service
      final jsonString = await DefaultAssetBundle.of(GlobalKey<NavigatorState>().currentState!.context)
          .loadString('assets/settings.json');
      final jsonData = json.decode(jsonString);
      final settings = Settings.fromJson(jsonData);
      final formattedJson = const JsonEncoder.withIndent('  ').convert(jsonData);
      emit(SettingsLoaded(settings, formattedJson));
    } catch (e) {
      emit(SettingsError('Error loading JSON: $e'));
    }
  }
}
