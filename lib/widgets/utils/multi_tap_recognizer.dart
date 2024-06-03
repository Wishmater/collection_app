import 'package:flutter/widgets.dart';

/// Utility class providing a mechanism to recognize and dispatch single- and
/// multi-tap events. This provides a workaround for a deficiency in Flutter's
/// gesture recognition logic, namely the mandatory, hard-coded 300ms delay
/// added to tap handlers if a double-tap handler is also installed.
///
/// The behavior implemented by this class is:
///
/// - Always fire the single-tap handler on the first tap;
/// - If a second tap arrives within the recognition time window, fire the
///   double-tap handler;
/// - If a third tap arrives within the window, fire the triple-tap handler;
/// - Subsequent fast taps within the window fire the single-tap handler;
/// - After the recognition time window passes, the state is reset and the
///   algorithm restarts from the top.
///
/// Here is an example sequence of incoming tap events and the resulting
/// callbacks made, assuming a recognition window of 300ms:
/// - [t=0ms] tap: onTap()
/// - [t=231ms] tap: onDoubleTap()
/// - [t=401ms] tap: onTripleTap()
/// - [t=499ms] tap: onSingleTap()
/// - [t=564ms] tap: onSingleTap()
/// - [t=900ms] tap: reset; onSingleTap()
///
/// Additional custom handling can be implemented on top of this flow. For
/// example, if your usecase requires dispatching only a double or triple tap,
/// but not both, you can implement a time-based gate similar to this class in
/// your double and triple tap handlers.
///
/// This class can be used via a provided convenience widget,
/// [MultiTapListener], or on its own for more advanced applications.
///
/// Related Flutter bugs:
/// - https://github.com/flutter/flutter/issues/110300
/// - https://github.com/flutter/flutter/issues/106170
class MultiTapRecognizer {
  static const _kDefaultRecognitionWindow = Duration(milliseconds: 300);
  final Duration _window;
  DateTime? _lastTap;
  int _consecutiveTaps = 1;

  /// The callback made on single taps.
  final void Function()? onTap;

  /// The callback made on double-taps.
  final void Function()? onDoubleTap;

  /// The callback made on triple-taps.
  final void Function()? onTripleTap;

  /// Optional override of the recognition window.
  final Duration? recognitionWindow;

  /// Constructs a multi-tap recognizer with the given event callbacks.
  MultiTapRecognizer({
    this.onTap,
    this.onDoubleTap,
    this.onTripleTap,
    this.recognitionWindow,
  }) : _window = recognitionWindow ?? _kDefaultRecognitionWindow;

  /// Accept an incoming tap event and dispatch to the appropriate callback.
  void dispatchTap() {
    final time = DateTime.now();

    if (_lastTap == null) {
      _lastTap = time;
      onTap?.call();
      return;
    }

    final elapsed = time.difference(_lastTap!);
    if (elapsed.compareTo(_window) <= 0) {
      _consecutiveTaps++;
    } else {
      _consecutiveTaps = 1;
    }

    switch (_consecutiveTaps) {
      case 2:
        onDoubleTap?.call();
      case 3:
        onTripleTap?.call();
      default:
        onTap?.call();
    }

    _lastTap = time;
  }
}

/// A widget that recognizes and dispatches multi-tap events. This widget does
/// not use or participate in the gesture arena, allowing it to be combined with
/// existing Flutter widgets that have built in tap responses that you want to
/// keep. The following example creates an InkWell that responds to double-taps,
/// while keeping the existing tap handling (e.g. the ink splash effect):
///
/// Example:
///
/// ```dart
/// class DoubleTapInkWell extends StatelessWidget {
///   const DoubleTapInkWell({super.key});
///
///   @override
///   Widget build(BuildContext context) {
///     return MultiTapListener(
///       onDoubleTap: () {
///         // Handle double tap.
///       },
///       child: InkWell(
///         onTap: () {
///           // Handle normal tap.
///         },
///       ),
///     );
///   }
/// }
/// ```
///
/// Because this widget does not use the gesture arena, adding an [onTap]
/// callback to the [MultiTapListener] in the above example would result in both
/// the InkWell and the [MultiTapListener] responding to single taps.
class MultiTapListener extends StatefulWidget {
  /// The callback made on single taps.
  final void Function()? onTap;

  /// The callback made on double-taps.
  final void Function()? onDoubleTap;

  /// The callback made on triple-taps.
  final void Function()? onTripleTap;

  /// Optional override of the recognition window.
  final Duration? recognitionWindow;

  /// Optional child widget.
  final Widget? child;

  /// Constructs a [MultiTapListener].
  const MultiTapListener(
      {this.onTap,
        this.onDoubleTap,
        this.onTripleTap,
        this.recognitionWindow,
        this.child,
        super.key,});

  @override
  State<MultiTapListener> createState() => _MultiTapListenerState();
}

class _MultiTapListenerState extends State<MultiTapListener> {
  late MultiTapRecognizer _recognizer;

  @override
  void initState() {
    super.initState();
    _setRecognizer();
  }

  @override
  void didUpdateWidget(covariant MultiTapListener oldWidget) {
    super.didUpdateWidget(oldWidget);
    _setRecognizer();
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerUp: (_) => _recognizer.dispatchTap(),
      child: widget.child,
    );
  }

  void _setRecognizer() {
    _recognizer = MultiTapRecognizer(
      onTap: widget.onTap,
      onDoubleTap: widget.onDoubleTap,
      onTripleTap: widget.onTripleTap,
      recognitionWindow: widget.recognitionWindow,
    );
  }
}