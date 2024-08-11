import 'package:collection_app/models/item.dart';
import 'package:collection_app/providers/data_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:from_zero_ui/from_zero_ui.dart';


class VideoCachedThumbnail extends ConsumerStatefulWidget {

  final Item item;

  const VideoCachedThumbnail({
    required this.item,
    super.key,
  });

  @override
  ConsumerState createState() => _VideoCachedThumbnailState();

}


class _VideoCachedThumbnailState extends ConsumerState<VideoCachedThumbnail> {

  @override
  Widget build(BuildContext context) {
    return ApiProviderBuilder(
      provider: DataProvider.thumbnail.call(widget.item),
      animatedSwitcherType: AnimatedSwitcherType.normal,
      dataBuilder: (context, file) {
        if (file==null) {
          return const SizedBox.shrink();
        }
        return SizedBox(
          width: double.infinity,
          child: Image.file(file,
            fit: BoxFit.contain,
          ),
        );
      },
      loadingBuilder: (context, progress) {
        return AspectRatio(
          aspectRatio: 16/9,
          child: SizedBox(width: double.infinity,
            child: ApiProviderBuilder.defaultLoadingBuilder(context, progress),
          ),
        );
      },
    );
  }

}
