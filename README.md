# incrementally_loading_listview

An extension of the ListView widget with extensions for incrementally loading items upon scrolling.

## Getting Started

There's a working example that can run to see how it works.

First import the library

```
import 'package:incrementally_loading_listview/incrementally_loading_listview.dart';
```

You can then use the `IncrementallyLoadingListView` widget in a similar you would with the `ListView.builder` constructor

```
return IncrementallyLoadingListView(
    hasMore: _hasMoreItems,
    itemCount: items.length,
    loadMore: () async {
    // can shorten to "loadMore: _loadMoreItems" but this syntax is used to demonstrate that
    // functions with parameters can also be invoked if needed
    await _loadMoreItems();
    },
    loadMoreOffsetFromBottom: 2,
    itemBuilder: (context, index) {
        /// your builder function for rendering the item
});
```

The widget allows passing in the same ones you would to the `ListView.builder` constructor but `itemCount` is required so that when an item scrolls into view, it can see if it should attempt to load more items. The other parameters that can be specified are

- `hasMore`: a boolean that indicates if there are more items that can be loaded
- `loadMore`: a reference to an asynchronous function that loads more items
- `loadMoreOffsetFromBottom`: determines when the list view should attempt to load more items based on of the index of the item is scrolling into view. This is relative to the bottom of the list and has a default value of 0 so that it loads when the last item within the list view scrolls into view. As an example, setting this to 1 would attempt to load more items when the second last item within the list view scrolls into view


