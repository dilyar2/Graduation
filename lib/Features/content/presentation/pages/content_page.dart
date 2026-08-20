import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:video_player/video_player.dart';

import 'package:graduation2/Features/content/presentation/manager/bloc/content_bloc.dart';
import 'package:graduation2/core/di/injection.dart';

class ContentPage extends StatefulWidget {
  final int courseId;
  final int contentId;
  final String? title;
  final String? contentType;
  final String? description;
  final int? duration;
  final bool initialCompleted;
  final int initialLastPosition;

  const ContentPage({
    super.key,
    required this.courseId,
    required this.contentId,
    this.title,
    this.contentType,
    this.description,
    this.duration,
    this.initialCompleted = false,
    this.initialLastPosition = 0,
  });

  @override
  State<ContentPage> createState() => _ContentPageState();
}

class _ContentPageState extends State<ContentPage> {
  int _lastPosition = 0;

  @override
  void initState() {
    super.initState();
    _lastPosition = widget.initialLastPosition.clamp(0, 1 << 30).toInt();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<ContentBloc>()
        ..add(GetContentEvent(courseId: widget.courseId, contentId: widget.contentId)),
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.title?.trim().isNotEmpty == true ? widget.title! : 'Content'),
        ),
        body: BlocBuilder<ContentBloc, ContentState>(
          builder: (context, state) {
            if (state is ContentInitial || state is ContentLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is ContentError) {
              return _ErrorView(
                message: state.message,
                onRetry: () => context.read<ContentBloc>().add(
                  GetContentEvent(courseId: widget.courseId, contentId: widget.contentId),
                ),
              );
            }

            if (state is ContentLoaded) {
              if (state.file.isEmpty) {
                return _ErrorView(
                  message: 'The content file is empty.',
                  onRetry: () => context.read<ContentBloc>().add(
                    GetContentEvent(courseId: widget.courseId, contentId: widget.contentId),
                  ),
                );
              }

              return Column(
                children: [
                  Expanded(
                    child: _ContentViewer(
                      bytes: state.file,
                      title: widget.title,
                      contentType: widget.contentType,
                      description: widget.description,
                      duration: widget.duration,
                      initialLastPosition: widget.initialLastPosition,
                      onPositionChanged: (position) {
                        if (position != _lastPosition && mounted) {
                          setState(() => _lastPosition = position);
                        }
                      },
                    ),
                  ),
                  _CompletionBar(
                    completed: state.completed || widget.initialCompleted,
                    loading: state.updatingProgress,
                    error: state.progressError,
                    onComplete: () => context.read<ContentBloc>().add(
                      MarkContentCompletedEvent(
                        contentId: widget.contentId,
                        courseId: widget.courseId,
                        lastPosition: _lastPosition > 0
                            ? _lastPosition
                            : (widget.duration != null && widget.duration! > 0 ? widget.duration! : 0),
                      ),
                    ),
                    onDone: () => Navigator.pop(context, true),
                  ),
                ],
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}

class _ContentViewer extends StatelessWidget {
  final Uint8List bytes;
  final String? title;
  final String? contentType;
  final String? description;
  final int? duration;
  final int initialLastPosition;
  final ValueChanged<int>? onPositionChanged;

  const _ContentViewer({
    required this.bytes,
    this.title,
    this.contentType,
    this.description,
    this.duration,
    this.initialLastPosition = 0,
    this.onPositionChanged,
  });

  @override
  Widget build(BuildContext context) {
    final rawType = (contentType ?? '').trim().toLowerCase();



    final type = _resolveContentType(rawType, bytes);

    if (_isPdf(type)) {
      return Column(
        children: [
          _ContentHeader(
            title: title,
            description: description,
            duration: duration,
          ),
          Expanded(child: SfPdfViewer.memory(bytes)),
        ],
      );
    }

    if (_isVideo(type)) {
      return _VideoContent(
        bytes: bytes,
        title: title,
        description: description,
        duration: duration,
        initialLastPosition: initialLastPosition,
        onPositionChanged: onPositionChanged,
      );
    }

    if (_isImage(type)) {
      return Column(
        children: [
          _ContentHeader(
            title: title,
            description: description,
            duration: duration,
          ),
          Expanded(
            child: InteractiveViewer(
              minScale: 0.5,
              maxScale: 4,
              child: Image.memory(
                bytes,
                fit: BoxFit.contain,
                errorBuilder: (_, __, ___) => const _UnsupportedContent(),
              ),
            ),
          ),
        ],
      );
    }

    if (_isText(type)) {
      final text = utf8.decode(bytes, allowMalformed: true);
      return SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _ContentHeader(
              title: title,
              description: description,
              duration: duration,
            ),
            const SizedBox(height: 16),
            SelectableText(
              text,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(height: 1.6),
            ),
          ],
        ),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _ContentHeader(
            title: title,
            description: description,
            duration: duration,
          ),
          const SizedBox(height: 24),
          const _UnsupportedContent(),
          const SizedBox(height: 16),
          Text(
            'Downloaded ${_formatBytes(bytes.length)}',
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }

  String _resolveContentType(String type, Uint8List data) {
    if (type.isNotEmpty && type != 'application/octet-stream') {
      return type;
    }

    if (_looksLikeMp4(data)) return 'video/mp4';
    if (_looksLikePdf(data)) return 'application/pdf';
    if (_looksLikePng(data)) return 'image/png';
    if (_looksLikeJpeg(data)) return 'image/jpeg';
    if (_looksLikeWebP(data)) return 'image/webp';
    if (_looksLikeGif(data)) return 'image/gif';

    return type;
  }

  bool _looksLikeMp4(Uint8List data) {


    return data.length >= 12 &&
        data[4] == 0x66 &&
        data[5] == 0x74 &&
        data[6] == 0x79 &&
        data[7] == 0x70;
  }

  bool _looksLikePdf(Uint8List data) {
    return data.length >= 4 &&
        data[0] == 0x25 &&
        data[1] == 0x50 &&
        data[2] == 0x44 &&
        data[3] == 0x46;
  }

  bool _looksLikePng(Uint8List data) {
    const signature = [0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A];
    if (data.length < signature.length) return false;
    for (var i = 0; i < signature.length; i++) {
      if (data[i] != signature[i]) return false;
    }
    return true;
  }

  bool _looksLikeJpeg(Uint8List data) {
    return data.length >= 3 &&
        data[0] == 0xFF &&
        data[1] == 0xD8 &&
        data[2] == 0xFF;
  }

  bool _looksLikeWebP(Uint8List data) {
    return data.length >= 12 &&
        data[0] == 0x52 &&
        data[1] == 0x49 &&
        data[2] == 0x46 &&
        data[3] == 0x46 &&
        data[8] == 0x57 &&
        data[9] == 0x45 &&
        data[10] == 0x42 &&
        data[11] == 0x50;
  }

  bool _looksLikeGif(Uint8List data) {
    return data.length >= 6 &&
        data[0] == 0x47 &&
        data[1] == 0x49 &&
        data[2] == 0x46;
  }

  bool _isPdf(String type) => type.contains('pdf');

  bool _isVideo(String type) =>
      type.contains('video') ||
      type.contains('mp4') ||
      type.contains('webm') ||
      type.contains('mov');

  bool _isImage(String type) =>
      type.contains('image') ||
      type.contains('jpg') ||
      type.contains('jpeg') ||
      type.contains('png') ||
      type.contains('webp');

  bool _isText(String type) =>
      type.contains('text') || type.contains('txt') || type.contains('markdown');
}

class _VideoContent extends StatefulWidget {
  final Uint8List bytes;
  final String? title;
  final String? description;
  final int? duration;
  final int initialLastPosition;
  final ValueChanged<int>? onPositionChanged;

  const _VideoContent({
    required this.bytes,
    this.title,
    this.description,
    this.duration,
    this.initialLastPosition = 0,
    this.onPositionChanged,
  });

  @override
  State<_VideoContent> createState() => _VideoContentState();
}

class _VideoContentState extends State<_VideoContent> {
  VideoPlayerController? _controller;
  String? _error;

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    try {
      final directory = await getTemporaryDirectory();
      final file = File(
        '${directory.path}/course_${DateTime.now().microsecondsSinceEpoch}.mp4',
      );
      await file.writeAsBytes(widget.bytes, flush: true);

      final controller = VideoPlayerController.file(file);
      await controller.initialize();

      final resumeSeconds = widget.initialLastPosition;
      if (resumeSeconds > 0) {
        final target = Duration(seconds: resumeSeconds);
        final max = controller.value.duration;
        await controller.seekTo(
          target < max ? target : Duration.zero,
        );
      }

      var lastReportedSecond = -1;
      controller.addListener(() {
        if (!mounted) return;
        final second = controller.value.position.inSeconds;
        if (second != lastReportedSecond) {
          lastReportedSecond = second;
          widget.onPositionChanged?.call(second);
        }
        setState(() {});
      });

      if (!mounted) {
        await controller.dispose();
        return;
      }

      setState(() => _controller = controller);
    } catch (e) {
      if (mounted) {
        setState(() => _error = 'Unable to open this video: $e');
      }
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_error != null) {
      return _ErrorView(message: _error!);
    }

    final controller = _controller;
    if (controller == null || !controller.value.isInitialized) {
      return const Center(child: CircularProgressIndicator());
    }

    final position = controller.value.position;
    final duration = controller.value.duration;
    final progress = duration.inMilliseconds == 0
        ? 0.0
        : (position.inMilliseconds / duration.inMilliseconds)
            .clamp(0.0, 1.0);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _ContentHeader(
            title: widget.title,
            description: widget.description,
            duration: widget.duration,
          ),
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: AspectRatio(
              aspectRatio: controller.value.aspectRatio == 0
                  ? 16 / 9
                  : controller.value.aspectRatio,
              child: VideoPlayer(controller),
            ),
          ),
          const SizedBox(height: 12),
          VideoProgressIndicator(
            controller,
            allowScrubbing: true,
            padding: EdgeInsets.zero,
          ),
          Row(
            children: [
              IconButton(
                                icon: Icon(
                  controller.value.isPlaying
                      ? Icons.pause_circle_filled
                      : Icons.play_circle_fill,
                  size: 42,
                ),
                onPressed: () {
                  if (controller.value.isPlaying) {
                    controller.pause();
                  } else {
                    controller.play();
                  }
                },
              ),
              Text(
                '${_formatDuration(position)} / ${_formatDuration(duration)}',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const Spacer(),
              Text(
                '${(progress * 100).round()}%',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ContentHeader extends StatelessWidget {
  final String? title;
  final String? description;
  final int? duration;

  const _ContentHeader({this.title, this.description, this.duration});

  @override
  Widget build(BuildContext context) {
    final cleanTitle = title?.trim() ?? '';
    final cleanDescription = description?.trim() ?? '';

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              cleanTitle.isEmpty ? 'Course Content' : cleanTitle,
              style: const TextStyle(
                                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            if (cleanDescription.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(
                cleanDescription,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(height: 1.4),
              ),
            ],
            if (duration != null && duration! > 0) ...[
              const SizedBox(height: 8),
              Text(
                'Duration: $duration',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _UnsupportedContent extends StatelessWidget {
  const _UnsupportedContent();

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Icon(Icons.insert_drive_file_outlined, color: colors.primary, size: 56),
            const SizedBox(height: 12),
            Text(
              'This content type cannot be previewed yet.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}

class _CompletionBar extends StatelessWidget {
  final bool completed;
  final bool loading;
  final String? error;
  final VoidCallback onComplete;
  final VoidCallback onDone;

  const _CompletionBar({
    required this.completed,
    required this.loading,
    required this.error,
    required this.onComplete,
    required this.onDone,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return SafeArea(
      top: false,
      child: Container(
        padding: const EdgeInsets.fromLTRB(16, 10, 16, 12),
        decoration: BoxDecoration(
          color: colors.surface,
          border: Border(top: BorderSide(color: colors.outlineVariant)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (error != null) ...[
              Text(error!, style: TextStyle(color: colors.error), textAlign: TextAlign.center),
              const SizedBox(height: 8),
            ],
            SizedBox(
              width: double.infinity,
              child: completed
                  ? FilledButton.icon(
                      onPressed: onDone,
                      icon: const Icon(Icons.check_circle_rounded),
                      label: const Text('Completed • Back to course'),
                    )
                  : FilledButton.icon(
                      onPressed: loading ? null : onComplete,
                      icon: loading
                          ? const SizedBox.square(
                              dimension: 18,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Icon(Icons.check_rounded),
                      label: Text(loading ? 'Saving progress...' : 'Mark lesson as completed'),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback? onRetry;

  const _ErrorView({required this.message, this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error_outline, color: Theme.of(context).colorScheme.error, size: 48),
            const SizedBox(height: 12),
            Text(
              message,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            if (onRetry != null) ...[
              const SizedBox(height: 16),
              OutlinedButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh),
                label: const Text('Retry'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

String _formatBytes(int bytes) {
  if (bytes < 1024) return '$bytes B';
  if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
  return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
}

String _formatDuration(Duration value) {
  final hours = value.inHours;
  final minutes = value.inMinutes.remainder(60).toString().padLeft(2, '0');
  final seconds = value.inSeconds.remainder(60).toString().padLeft(2, '0');
  if (hours > 0) return '$hours:$minutes:$seconds';
  return '$minutes:$seconds';
}
