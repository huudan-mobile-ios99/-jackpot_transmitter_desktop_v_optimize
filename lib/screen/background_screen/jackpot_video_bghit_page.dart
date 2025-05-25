import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';
import 'package:playtech_transmitter_app/service/config_custom.dart';
import 'package:playtech_transmitter_app/screen/setting/setting_service.dart';
import 'package:playtech_transmitter_app/service/widget/text_style.dart';

class JackpotBackgroundVideoHitWindowFadeAnimation extends StatefulWidget {
  final String number;
  final String value;
  final String id;

  const JackpotBackgroundVideoHitWindowFadeAnimation({
    super.key,
    required this.number,
    required this.value,
    required this.id,
  });

  @override
  _JackpotBackgroundVideoHitWindowFadeAnimationState createState() => _JackpotBackgroundVideoHitWindowFadeAnimationState();
}

class _JackpotBackgroundVideoHitWindowFadeAnimationState extends State<JackpotBackgroundVideoHitWindowFadeAnimation>
    with SingleTickerProviderStateMixin {
  late final Player _player;

  late final VideoController _controller;
  final NumberFormat _numberFormat = NumberFormat('#,##0.00', 'en_US');
  String? _currentVideoPath;
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;
  final settingsService = SettingsService();


  String getVideoAssetPath(String id) {
    debugPrint('getVideoAssetPath: id=$id');
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
      case '34':
         return settingsService.settings!.jpIdDailygoldenVideoPath;
      case '35':
         return settingsService.settings!.jpIdTrippleVideoPath;

      case '45':
         return settingsService.settings!.jpIdHighlimitVideoPath;
      case '46':
         return settingsService.settings!.jpIdVegasVideoPath;
      case '44':
         return settingsService.settings!.jpIdVegasVideoPath;
      case '80':
      case '81':
      case '88':
      case '89':
      case '97':
      case '98':
        return   settingsService.settings!.jpIdPpochiMonFriVideoPath;
      default:
        debugPrint('Unknown id: $id, falling back to frequent.mpg');
        return  settingsService.settings!.jpIdFrequentVideoPath;
    }
  }

  @override
  void initState() {
    super.initState();
    debugPrint('Initializing JackpotBackgroundVideoHitWindow');

    // Initialize fade animation
    _fadeController = AnimationController(
      duration: Duration(milliseconds: ConfigCustom.switchBetweeScreenDurationForHitScreen),
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
  }

  @override
  void didUpdateWidget(JackpotBackgroundVideoHitWindowFadeAnimation oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.id != oldWidget.id) {
      debugPrint('ID changed from ${oldWidget.id} to ${widget.id}');
      _loadVideo(getVideoAssetPath(widget.id));
    }
  }

  Future<void> _loadVideo(String videoPath) async {
    if (_currentVideoPath == videoPath) {
      debugPrint('Video unchanged: $videoPath, skipping load');
      return;
    }

    debugPrint('Loading video: $videoPath');
    _currentVideoPath = videoPath;

    try {
      await _player.open(Media('asset:///$videoPath'), play: false);
      debugPrint('Setting playlist mode and volume');
      await _player.setPlaylistMode(PlaylistMode.loop);
      await _player.setVolume(100.0);
      debugPrint('Playing video');
      await _player.play();

      if (mounted) {
        // Trigger fade-in
        _fadeController.reset();
        await _fadeController.forward();
        debugPrint('Fade-in complete');
      }
    } catch (error) {
      debugPrint('Error loading video: $error');
    }
  }

  @override
  void dispose() {
    debugPrint('Disposing JackpotBackgroundVideoHitWindow');
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
          top: screenSize.height/2  - settingsService.settings!.textHitPriceSize*0.935,
          child: Container(
            alignment: Alignment.center,
            child: Text(
             (widget.value =='0.00' || widget.value =='0' || widget.value=='0.0')? "" : '\$${_numberFormat.format(num.parse(widget.value))}',
              style: textStyleJPHit,
              textAlign: TextAlign.center,
            ),
          ),
        ),
        Positioned(
          bottom: settingsService.settings!.textHitNumberDY,
          right: settingsService.settings!.textHitNumberDX,
          child: Text(
            '#${widget.number}',
            style: textStyleSmall,
          ),
        ),
      ],
    );
  }
}
