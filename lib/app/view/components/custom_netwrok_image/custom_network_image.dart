import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';

class CustomNetworkImage extends StatelessWidget {
  final String imageUrl;
  final double? height;
  final double width;
  final Border? border;
  final BorderRadius? borderRadius;
  final BoxShape boxShape;
  final Color? backgroundColor;
  final Widget? child;
  final ColorFilter? colorFilter;

  const CustomNetworkImage({
    super.key,
    required this.imageUrl,
    required this.width,
    this.height,
    this.border,
    this.borderRadius,
    this.boxShape = BoxShape.rectangle,
    this.backgroundColor,
    this.child,
    this.colorFilter,
  });

  bool get _isSvg => imageUrl.trim().toLowerCase().endsWith('.svg');

  @override
  Widget build(BuildContext context) {
    final url = imageUrl.trim();

    if (url.isEmpty) {
      return _placeholderOrError(isError: false);
    }

    return _isSvg ? _buildSvgImage(url) : _buildRasterImage(url);
  }

  Widget _buildSvgImage(String url) {
    return ClipRRect(
      borderRadius: borderRadius ?? BorderRadius.zero,
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          shape: boxShape,
          border: border,
          color: backgroundColor,
        ),
        child: SvgPicture.network(
          url,
          height: height,
          width: width,
          fit: BoxFit.cover,
          placeholderBuilder: (context) => _shimmerPlaceholder(),
          colorFilter: colorFilter,
          clipBehavior: Clip.antiAlias,
        ),
      ),
    );
  }

  Widget _buildRasterImage(String url) {
    return CachedNetworkImage(
      fit: BoxFit.cover,
      imageUrl: url,
      imageBuilder: (context, imageProvider) => Container(
        height: height,
        width: width,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          border: border,
          borderRadius: borderRadius,
          shape: boxShape,
          color: backgroundColor,
          image: DecorationImage(
            image: imageProvider,
            fit: BoxFit.cover,
            colorFilter: colorFilter,
          ),
        ),
        child: child,
      ),
      placeholder: (context, _) => _shimmerPlaceholder(),
      errorWidget: (context, _, __) => _placeholderOrError(isError: true),
    );
  }

  Widget _shimmerPlaceholder() {
    return Shimmer.fromColors(
      baseColor: Colors.grey.withOpacity(0.6),
      highlightColor: Colors.grey.withOpacity(0.3),
      child: Container(
        height: height,
        width: width,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          border: border,
          color: Colors.grey.withOpacity(0.6),
          borderRadius: borderRadius,
          shape: boxShape,
        ),
      ),
    );
  }

  Widget _placeholderOrError({required bool isError}) {
    return Container(
      height: height,
      width: width,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        border: border,
        color: Colors.grey.withOpacity(0.6),
        borderRadius: borderRadius,
        shape: boxShape,
      ),
      alignment: Alignment.center,
      child: isError ? const Icon(Icons.error) : child,
    );
  }
}
