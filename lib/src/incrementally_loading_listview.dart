import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:rxdart/subjects.dart';
import 'package:rxdart/rxdart.dart';

typedef LoadMore = Future Function();

typedef OnLoadMore = void Function();

typedef ItemCount = int Function();

typedef HasMore = bool Function();

typedef OnLoadMoreFinished = void Function();

/// A list view that can be used for incrementally loading items when the user scrolls.
/// This is an extension of the ListView widget that uses the ListView.builder constructor.
class IncrementallyLoadingListView extends StatefulWidget {
  /// A callback that indicates if the collection associated with the ListView has more items that should be loaded
  final HasMore hasMore;

  /// A callback to an asynchronous function that would load more items
  final LoadMore loadMore;

  /// Determines when the list view should attempt to load more items based on of the index of the item is scrolling into view
  /// This is relative to the bottom of the list and has a default value of 0 so that it loads when the last item within the list view scrolls into view.
  /// As an example, setting this to 1 would attempt to load more items when the second last item within the list view scrolls into view
  final int loadMoreOffsetFromBottom;
  final Key key;
  final Axis scrollDirection;
  final bool reverse;
  final ScrollController controller;
  final bool primary;
  final ScrollPhysics physics;
  final bool shrinkWrap;
  final EdgeInsetsGeometry padding;
  final double itemExtent;
  final IndexedWidgetBuilder itemBuilder;
  final IndexedWidgetBuilder separatorBuilder;
  final ItemCount itemCount;
  final bool addAutomaticKeepAlives;
  final bool addRepaintBoundaries;
  final double cacheExtent;

  /// A callback that is triggered when more items are being loaded
  final OnLoadMore onLoadMore;

  /// A callback that is triggered when items have finished being loaded
  final OnLoadMoreFinished onLoadMoreFinished;

  IncrementallyLoadingListView(
      {@required this.hasMore,
      @required this.loadMore,
      this.loadMoreOffsetFromBottom = 0,
      this.key,
      this.scrollDirection = Axis.vertical,
      this.reverse = false,
      this.controller,
      this.primary,
      this.physics,
      this.shrinkWrap = false,
      this.padding,
      this.itemExtent,
      @required this.itemBuilder,
      @required this.itemCount,
      this.separatorBuilder,
      this.addAutomaticKeepAlives = true,
      this.addRepaintBoundaries = true,
      this.cacheExtent,
      this.onLoadMore,
      this.onLoadMoreFinished});

  @override
  IncrementallyLoadingListViewState createState() {
    return IncrementallyLoadingListViewState();
  }
}

class IncrementallyLoadingListViewState
    extends State<IncrementallyLoadingListView> {
  bool _loadingMore = false;
  final PublishSubject<bool> _loadingMoreSubject = PublishSubject<bool>();
  Stream<bool> _loadingMoreStream;

  IncrementallyLoadingListViewState() {
    _loadingMoreStream =
        _loadingMoreSubject.switchMap((shouldLoadMore) => loadMore());
  }

  bool get _isSeparated => widget.separatorBuilder != null;

  int _separatedItemCount() {
    final count = widget.itemCount();
    if (count == 0) {
      return 0;
    }
    return count * 2 - 1;
  }

  Widget _separatedItemBuilder(BuildContext context, int index) {
    final itemIndex = index ~/ 2;

    if (index.isOdd) {
      return widget.separatorBuilder(context, itemIndex);
    } else {
      return _buildItem(context, itemIndex);
    }
  }

  Widget _buildItem(BuildContext context, int index) {
    if (!_loadingMore &&
        index == widget.itemCount() - widget.loadMoreOffsetFromBottom - 1 &&
        widget.hasMore()) {
      _loadingMore = true;
      _loadingMoreSubject.add(true);
    }

    return widget.itemBuilder(context, index);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: _loadingMoreStream,
        builder: (context, snapshot) {
          final itemCount =
              _isSeparated ? _separatedItemCount() : widget.itemCount();
          final itemBuilder = _isSeparated ? _separatedItemBuilder : _buildItem;
          return ListView.builder(
            key: widget.key,
            scrollDirection: widget.scrollDirection,
            reverse: widget.reverse,
            controller: widget.controller,
            primary: widget.primary,
            physics: widget.physics,
            shrinkWrap: widget.shrinkWrap,
            padding: widget.padding,
            itemExtent: widget.itemExtent,
            itemBuilder: itemBuilder,
            itemCount: itemCount,
            addAutomaticKeepAlives: widget.addAutomaticKeepAlives,
            addRepaintBoundaries: widget.addRepaintBoundaries,
            cacheExtent: widget.cacheExtent,
          );
        });
  }

  Stream<bool> loadMore() async* {
    yield _loadingMore;
    if (widget.onLoadMore != null) {
      widget.onLoadMore();
    }
    await widget.loadMore();
    _loadingMore = false;
    yield _loadingMore;
    if (widget.onLoadMoreFinished != null) {
      widget.onLoadMoreFinished();
    }
  }

  @override
  void dispose() {
    _loadingMoreSubject.close();
    super.dispose();
  }
}
