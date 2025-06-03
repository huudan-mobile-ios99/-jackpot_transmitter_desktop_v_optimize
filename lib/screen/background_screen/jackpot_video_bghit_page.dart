import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';
import 'package:playtech_transmitter_app/service/config_custom.dart';
import 'package:playtech_transmitter_app/screen/setting/setting_service.dart';
import 'package:playtech_transmitter_app/service/widget/text_style.dart';

class JackpotBackgroundVideoHitWindowFadeAnimationV2 extends StatefulWidget {
  final String number;
  final String value;
  final String id;

  const JackpotBackgroundVideoHitWindowFadeAnimationV2({
    super.key,
    required this.number,
    required this.value,
    required this.id,
  });

  @override
  _JackpotBackgroundVideoHitWindowFadeAnimationV2State createState() => _JackpotBackgroundVideoHitWindowFadeAnimationV2State();
}

class _JackpotBackgroundVideoHitWindowFadeAnimationV2State extends State<JackpotBackgroundVideoHitWindowFadeAnimationV2>
    with SingleTickerProviderStateMixin {
  late final Player _player;
  late final VideoController _controller;
  final NumberFormat _numberFormat = NumberFormat('#,##0.00', 'en_US');
  String? _currentVideoPath;
  bool _isSwitching = false;
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;
  final SettingsService settingsService = SettingsService();
  int _retryCount = 0;
  static const int _maxRetries = 5;
  final Map<String, Media> _mediaCache = {};

  String getVideoAssetPath(String id) {
    switch (id) {
      case '0':
        return settingsService.settings!.jpIdFrequentVideoPath;
      case '1':
        return settingsService.settings!.jpIdDailyVideoPath;
      case '2':
        return settingsService.settings!.jpIdDozenVideoPath;
      case '3':
        return settingsService.settings!.jpIdWeeklyVideoPath;
      case '4':
       return settingsService.settings!.jpIdVegasVideoPath;
      case '44':
       return settingsService.settings!.jpIdMonthlyVideoPath;
      case '46':
        return settingsService.settings!.jpIdMonthlyVideoPath;
      case '34':
        return settingsService.settings!.jpIdDailygoldenVideoPath;
      case '35':
        return settingsService.settings!.jpIdTrippleVideoPath;

      case '45':
        return settingsService.settings!.jpIdHighlimitVideoPath;
      case '18':
        return settingsService.settings!.jpIdHighlimitVideoPath;

      case '80': //tripple 777 price
        return settingsService.settings!.jpId7771stVideoPath;
      case '81':
        return settingsService.settings!.jpId7771stVideoPath;
      case '88': //1000 price jackpot town
        return settingsService.settings!.jpId10001stVideoPath;
      case '89':
        return settingsService.settings!.jpId10001stVideoPath;
      case '97': //ppochi video
        return settingsService.settings!.jpIdPpochiMonFriVideoPath;
      case '98':
        return settingsService.settings!.jpIdPpochiMonFriVideoPath;
      case '109':
        return settingsService.settings!.jpIdRlPpochiVideoPath;
      case '119':
        return settingsService.settings!.jpIdNew20PpochiVideoPath;
      default:
        return settingsService.settings!.jpIdFrequentVideoPath;
    }
  }

  @override
  void initState() {
    super.initState();
    MediaKit.ensureInitialized();

    // Initialize fade animation
    _fadeController = AnimationController(
      duration: Duration(milliseconds: ConfigCustom.switchBetweeScreenDurationForHitScreen.clamp(500, 1000)),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
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
      _loadVideo(getVideoAssetPath(widget.id));
    });

    // Handle errors
    _player.stream.error.listen((error) {
      if (mounted && _retryCount < _maxRetries) {
        _retryCount++;
        Future.delayed(const Duration(seconds: 2), () {
          if (mounted) {
            _loadVideo(_currentVideoPath ?? getVideoAssetPath(widget.id));
          }
        });
      }
    });
  }

  @override
  void didUpdateWidget(JackpotBackgroundVideoHitWindowFadeAnimationV2 oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.id != oldWidget.id) {
      _loadVideo(getVideoAssetPath(widget.id));
    }
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
      await Future.delayed(const Duration(milliseconds: 500)); // Delay to stabilize libmpv
      _currentVideoPath = videoPath;
      Media media = _mediaCache.putIfAbsent(videoPath, () => Media('asset://$videoPath'));
      await _player.open(media, play: false);
      await _player.setVolume(100.0);
      await _player.play();
      if (mounted) {
        _fadeController.forward();
      }
      _retryCount = 0;
    } catch (error) {
      if (mounted && _retryCount < _maxRetries) {
        _retryCount++;
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
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Stack(
      fit: StackFit.expand,
      children: [
        FadeTransition(
          opacity: _fadeAnimation,
          child: Video(
            fill: Colors.transparent,
            controls: (state) => Container(),
            controller: _controller,
            filterQuality: FilterQuality.none,
            fit: BoxFit.contain,
            width: screenSize.width,
            height: screenSize.height,
          ),
        ),
        Positioned(
          left: 0,
          right: 0,
          top: screenSize.height / 2 - settingsService.settings!.textHitPriceSize * 0.935,
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: Container(
              alignment: Alignment.center,
              child: Text(
                (widget.value == '0.00' || widget.value == '0' || widget.value == '0.0')
                    ? ""
                    : '\$${_numberFormat.format(num.parse(widget.value))}',
                style: textStyleJPHit,
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
        Positioned(
          bottom: settingsService.settings!.textHitNumberDY,
          right: settingsService.settings!.textHitNumberDX,
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: Text(
              '#${widget.number}',
              style: textStyleSmall,
            ),
          ),
        ),
      ],
    );
  }
}
