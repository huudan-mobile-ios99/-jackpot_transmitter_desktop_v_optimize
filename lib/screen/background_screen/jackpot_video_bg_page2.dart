import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';
import 'package:playtech_transmitter_app/screen/background_screen/hive_page.dart';
import 'package:playtech_transmitter_app/screen/background_screen/hive_page.dart';

import 'package:playtech_transmitter_app/service/config_custom.dart';
import 'package:playtech_transmitter_app/service/widget/circlar_progress.dart';
import 'package:playtech_transmitter_app/screen/background_screen/bloc/video_blocv1.dart';
import 'package:playtech_transmitter_app/screen/background_screen/jackpot_screen_page.dart';
import 'package:playtech_transmitter_app/screen/background_screen/bloc_socket_time/jackpot_bloc2.dart';
import 'package:playtech_transmitter_app/screen/background_screen/bloc_socket_time/jackpot_event2.dart';

class JackpotBackgroundShowWindowFadeAnimateV2 extends StatefulWidget {
  const JackpotBackgroundShowWindowFadeAnimateV2({super.key});

  @override
  _JackpotBackgroundShowWindowFadeAnimateV2State createState() => _JackpotBackgroundShowWindowFadeAnimateV2State();
}

class _JackpotBackgroundShowWindowFadeAnimateV2State extends State<JackpotBackgroundShowWindowFadeAnimateV2>
    with SingleTickerProviderStateMixin {
  late final Player _player;
  late final VideoController _controller;
  String? _currentVideoPath;
  bool _isInitialized = false;
  bool _isSwitching = false;
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;
  int _retryCount = 0;
  static const int _maxRetries = 10;
  final Media _media1 = Media('asset://${ConfigCustom.videoBg}');
  final Media _media2 = Media('asset://${ConfigCustom.videoBg2}');

  @override
  void initState() {
    super.initState();
    MediaKit.ensureInitialized();

    // Initialize fade animation
    _fadeController = AnimationController(
      duration: Duration(milliseconds: ConfigCustom.switchBetweeScreenDuration),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeIn),
    );

    // Initialize player and controller
    _player = Player();
    _controller = VideoController(
      _player,
      configuration: const VideoControllerConfiguration(
        enableHardwareAcceleration: true,
      ),
    );

    // Load initial video
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadVideo(ConfigCustom.videoBg);
    });

    // Handle errors
    _player.stream.error.listen((error) {
      if (mounted && _retryCount < _maxRetries) {
        _retryCount++;
        setState(() {
          _isInitialized = false;
          _currentVideoPath = null;
        });
        Future.delayed(const Duration(seconds: 2), () {
          if (mounted) {
            _loadVideo(_currentVideoPath ?? ConfigCustom.videoBg);
          }
        });
      }
    });

    // Ensure playback unless jackpot hit
    _player.stream.playing.listen((playing) {
      if (!playing && mounted && context.read<JackpotBloc2>().state is! JackpotHitReceived && !_isSwitching) {
        _player.play();
      }
    });

    // Update initialization state
    _player.stream.width.listen((width) {
      if (width != null && width > 0 && mounted) {
        setState(() {
          _isInitialized = true;
        });
      }
    });
  }

  Future<void> _loadVideo(String videoPath) async {
    if (_currentVideoPath == videoPath || _isSwitching) {
      if (_player.state.playing) return;
      await _player.play();
      return;
    }

    _isSwitching = true;
    try {
      _fadeController.reset();
      await _player.pause();
      await Future.delayed( Duration(milliseconds: ConfigCustom.switchBetweeScreenDuration)); // Delay to stabilize libmpv
      _currentVideoPath = videoPath;
      final media = videoPath == ConfigCustom.videoBg ? _media1 : _media2;
      await _player.open(media, play: false);
      await _player.setVolume(0.0);
      await _player.play();
      if (mounted) {
        _fadeController.forward();
      }
      _retryCount = 0;
    } catch (error) {
      if (mounted && _retryCount < _maxRetries) {
        _retryCount++;
        setState(() {
          _isInitialized = false;
          _currentVideoPath = null;
        });
        Future.delayed(const Duration(seconds: 2), () {
          if (mounted) {
            _loadVideo(videoPath);
          }
        });
      }
    } finally {
      _isSwitching = false;
    }
  }

  @override
  void dispose() {
    _player.pause();
    _player.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final jackpotState = context.read<JackpotBloc2>().state;
    if (jackpotState is JackpotHitReceived) {
      _player.pause();
    } else if (!_player.state.playing && !_isSwitching) {
      _player.play();
    }
  }

   @override
  Widget build(BuildContext context) {
    return BlocSelector<VideoBloc, ViddeoState, ({String currentVideo, int count, bool isRestart})>(
      selector: (state) => (currentVideo: state.currentVideo, count: state.count, isRestart: state.isRestart),
      builder: (context, value) {
        if (_currentVideoPath != value.currentVideo && context.read<JackpotBloc2>().state is! JackpotHitReceived) {
          _loadVideo(value.currentVideo);
        }
        return AspectRatio(
          aspectRatio: ConfigCustom.fixWidth / ConfigCustom.fixHeight,
          child: Stack(
            fit: StackFit.expand,
            children: [
              _isInitialized
                  ? RepaintBoundary(
                      child: FadeTransition(
                        opacity: _fadeAnimation,
                        child: Video(
                          fill: Colors.transparent,
                          controls: (state) => Container(),
                          controller: _controller,
                          fit: BoxFit.contain,
                          width: ConfigCustom.fixWidth,
                          height: ConfigCustom.fixHeight,
                        ),
                      ),
                    )
                  : circularProgessCustom(),
              const RepaintBoundary(child: JackpotDisplayScreen()),
              Positioned(
                top: 10,
                left: 10,
                child: Text(
                  'Cycle Count: ${value.count}, Restart: ${value.isRestart}',
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
              //Display Hive Saved Data PREV
              //  Positioned(
              //   top:0,right:0,
              //   child: RepaintBoundary(child:  HiveViewPage()))
            ],
          ),
        );
      },
    );
  }
}
