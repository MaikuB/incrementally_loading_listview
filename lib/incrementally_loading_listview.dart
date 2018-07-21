library incrementally_loading_listview;

import 'dart:async';
import 'package:flutter/widgets.dart';

typedef Future _LoadMore();

/// A list view that can be used for incrementally loading items when the user scrolls.
/// This is an extension of the ListView widget that uses the ListView.builder constructor.
class IncrementallyLoadingListView extends StatefulWidget {
  /// If the collection has more items that should be loaded
  final bool hasMore;

  /// A reference to an asynchronous function that would load more items
  final _LoadMore loadMore;

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
  final int itemCount;
  final bool addAutomaticKeepAlives;
  final bool addRepaintBoundaries;
  final double cacheExtent;

  IncrementallyLoadingListView(
      {@required this.hasMore,
      @required this.loadMore,
      this.loadMoreOffsetFromBottom: 0,
      this.key,
      this.scrollDirection: Axis.vertical,
      this.reverse: false,
      this.controller,
      this.primary,
      this.physics,
      this.shrinkWrap: false,
      this.padding,
      this.itemExtent,
      @required this.itemBuilder,
      @required this.itemCount,
      this.addAutomaticKeepAlives: true,
      this.addRepaintBoundaries: true,
      this.cacheExtent});

  @override
  IncrementallyLoadingListViewState createState() {
    return new IncrementallyLoadingListViewState();
  }
}

class IncrementallyLoadingListViewState
    extends State<IncrementallyLoadingListView> {
  bool _loadingMore = false;

  @override
  Widget build(BuildContext context) {
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
      itemBuilder: (itemBuilderContext, index) {
        if (!_loadingMore &&
            index == widget.itemCount - widget.loadMoreOffsetFromBottom - 1 &&
            widget.hasMore) {
          _loadingMore = true;
          widget.loadMore().whenComplete(() {
            setState(() {
              _loadingMore = false;
            });
          });
        }
        return widget.itemBuilder(itemBuilderContext, index);
      },
      itemCount: widget.itemCount,
      addAutomaticKeepAlives: widget.addAutomaticKeepAlives,
      addRepaintBoundaries: widget.addRepaintBoundaries,
      cacheExtent: widget.cacheExtent,
    );
  }
}
