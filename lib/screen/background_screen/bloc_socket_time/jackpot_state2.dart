import 'package:equatable/equatable.dart';
class JackpotState2 extends Equatable {
  final List<Map<String, dynamic>> hits;
  final Map<String, dynamic>? config;
  final bool isConnected;
  final String? error;
  final bool showImagePage;
  final Map<String, dynamic>? latestHit;
  final List<Map<String, dynamic>>? hitQueue;

  const JackpotState2({
    this.hits = const [],
    this.config,
    this.isConnected = false,
    this.error,
    this.showImagePage = false,
    this.latestHit,
    this.hitQueue = const [],
  });

  JackpotState2 copyWith({
    List<Map<String, dynamic>>? hits,
    Map<String, dynamic>? config,
    bool? isConnected,
    String? error,
    bool? showImagePage,
    Map<String, dynamic>? latestHit,
    List<Map<String, dynamic>>? hitQueue,
  }) {
    return JackpotState2(
      hits: hits ?? this.hits,
      config: config ?? this.config,
      isConnected: isConnected ?? this.isConnected,
      error: error ?? this.error,
      showImagePage: showImagePage ?? this.showImagePage,
      latestHit: latestHit ?? this.latestHit,
      hitQueue: hitQueue ?? this.hitQueue,
    );
  }

  @override
  List<Object?> get props => [hits, config, isConnected, error, showImagePage, latestHit, hitQueue];
}
