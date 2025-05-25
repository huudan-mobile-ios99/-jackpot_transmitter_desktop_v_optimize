import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';
import 'package:playtech_transmitter_app/service/config_custom.dart';
import 'package:playtech_transmitter_app/service/widget/circlar_progress.dart';
import 'package:playtech_transmitter_app/screen/background_screen/bloc/video_bloc.dart';
import 'package:playtech_transmitter_app/screen/background_screen/jackpot_screen_page.dart';
import 'package:playtech_transmitter_app/screen/background_screen/bloc_socket_time/jackpot_bloc2.dart';
import 'package:playtech_transmitter_app/screen/background_screen/bloc_socket_time/jackpot_event2.dart';

class JackpotBackgroundShowWindowFadeAnimate extends StatefulWidget {
  const JackpotBackgroundShowWindowFadeAnimate({super.key});

  @override
  _JackpotBackgroundShowWindowFadeAnimateState createState() => _JackpotBackgroundShowWindowFadeAnimateState();
}

class _JackpotBackgroundShowWindowFadeAnimateState extends State<JackpotBackgroundShowWindowFadeAnimate>
    with SingleTickerProviderStateMixin {
  late final Player _player;
  late final VideoController _controller;
  String? _currentVideoPath;
  bool _isInitialized = false;
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;
  Size? _lastScreenSize;

  @override
  void initState() {
    super.initState();
    debugPrint('Initializing JackpotBackgroundShowWindowFadeAnimate');
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
        enableHardwareAcceleration: false,
      ),
    );

    // Load initial video after frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadVideo(ConfigCustom.videoBg);
    });


    _player.stream.playing.listen((playing) {
      debugPrint('Player playing state: $playing');
      if (!playing && mounted && context.read<JackpotBloc2>().state is! JackpotHitReceived) {
        _player.play(); // Ensure video keeps playing unless jackpot hit
      }
    });

    _player.stream.width.listen((width) {
      if (width != null && width > 0 && mounted) {
        setState(() {
          _isInitialized = true; // Set initialized when width is available
        });
      }
    });
  }

  Future<void> _loadVideo(String videoPath) async {
    if (_currentVideoPath == videoPath) {
      debugPrint('Video already loaded: $videoPath');
      await _player.play(); // Ensure playback resumes
      return;
    }

    try {
      debugPrint('Loading video: $videoPath');
      _fadeController.reset();
      await _player.pause();
      _currentVideoPath = videoPath;
      await _player.open(Media('asset://$videoPath'), play: false);
      await _player.setPlaylistMode(PlaylistMode.loop);
      await _player.setVolume(0.0); // Muted
      await _player.play();
      if (mounted) {
        _fadeController.forward();
      }
    } catch (error, stackTrace) {
      debugPrint('Error loading video: $error\n$stackTrace');
      if (mounted) {
        setState(() {
          _isInitialized = false;
          _currentVideoPath = null;
        });
        // Retry after a delay
        Future.delayed(const Duration(seconds: 1), () {
          if (mounted) {
            _loadVideo(videoPath);
          }
        });
      }
    }
  }

  @override
  void dispose() {
    debugPrint('Disposing JackpotBackgroundShowWindowFadeAnimate');
    _player.pause();
    _player.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final jackpotState = context.read<JackpotBloc2>().state;
    // debugPrint('Jackpot state: $jackpotState');
    if (jackpotState is JackpotHitReceived) {
      _player.pause();
    } else if (!_player.state.playing) {
      _player.play(); // Resume playback if not paused by jackpot
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    if (_lastScreenSize != null &&
        (_lastScreenSize!.width - screenSize.width).abs() < 1.0 &&
        (_lastScreenSize!.height - screenSize.height).abs() < 1.0) {
      debugPrint('Screen size unchanged, skipping layout rebuild');
    } else {
      _lastScreenSize = screenSize;
      // debugPrint('Screen size updated: ${screenSize.width}x${screenSize.height}');
    }

    return BlocSelector<VideoBloc, ViddeoState, String>(
      selector: (state) => state.currentVideo,
      builder: (context, currentVideo) {
        debugPrint('BlocSelector: video=$currentVideo');
        if (_currentVideoPath != currentVideo) {
          _loadVideo(currentVideo);
        }
        return Center(
          child: AspectRatio(
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
                            width: ConfigCustom.fixWidth, // Fixed 1920
                            height: ConfigCustom.fixHeight, // Fixed 1080
                          ),
                        ),
                      )
                    : circularProgessCustom(),
                RepaintBoundary(child: JackpotDisplayScreen()),
              ],
            ),
          ),
        );
      },
    );
  }
}
