import 'package:flutter/material.dart';
import 'package:tiktok_clone/features/videos/views/widgets/video_post.dart';

class VideoTimelineScreen extends StatefulWidget {
  const VideoTimelineScreen({super.key});

  @override
  State<VideoTimelineScreen> createState() => _VideoTimelineScreenState();
}

class _VideoTimelineScreenState extends State<VideoTimelineScreen> {
  int _itemCount = 4;

  final PageController _pageController = PageController();

  final _scrollDuration = const Duration(milliseconds: 250);
  final _scrollCurve = Curves.linear;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      displacement: 50,
      edgeOffset: 20,
      color: Theme.of(context).primaryColor,
      onRefresh: _onRefresh,
      child: PageView.builder(
        controller: _pageController,
        scrollDirection: Axis.vertical,
        onPageChanged: _onPageChanged,
        itemCount: _itemCount,
        itemBuilder: (context, index) =>
            VideoPost(onVideoFinished: _onVideoFinished, index: index),
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged(int page) {
    _pageController.animateToPage(
      page,
      duration: _scrollDuration,
      curve: _scrollCurve,
    );

    if (page == _itemCount - 1) {
      _itemCount = _itemCount + 4;
      setState(() {});
    }
  }

  Future<void> _onRefresh() {
    // TODO: `Future.delayed()` is a dummy
    return Future.delayed(
      const Duration(seconds: 3),
    );
  }

  void _onVideoFinished() {
    return;
    // NOTE: Implementation for want to automatically skip to the next video like Youtube Shorts
    // _pageController.nextPage(
    //   duration: _scrollDuration,
    //   curve: _scrollCurve,
    // );
  }
}
