# incrementally_loading_listview

[![pub package](https://img.shields.io/pub/v/incrementally_loading_listview.svg)](https://pub.dev/packages/incrementally_loading_listview)

An extension of the Flutter ListView widget for incrementally loading items upon scrolling. This could be used to load paginated data received from API requests. 

**NOTE**: this package depends on [rxdart](https://pub.dev/packages/rxdart). If you run into conflicts with different versions of rxdart, consider using dependency overrides as per this [link](https://flutter.dev/docs/development/packages-and-plugins/using-packages#conflict-resolution)

## Getting Started

There's a working example that can be run to see how it works.

First import the library

```dart
import 'package:incrementally_loading_listview/incrementally_loading_listview.dart';
```

You can then use the `IncrementallyLoadingListView` widget in a similar way you would with the `ListView.separated` constructor

```dart
return IncrementallyLoadingListView(
    hasMore: () => _hasMoreItems,
    itemCount: () => items.length,
    loadMore: () async {
        // can shorten to "loadMore: _loadMoreItems" but this syntax is used to demonstrate that
        // functions with parameters can also be invoked if needed
        await _loadMoreItems();
    },
    loadMoreOffsetFromBottom: 2,
    itemBuilder: (context, index) {
        /// your builder function for rendering the item
    },
    separatorBuilder: (context, index) {
        /// your builder function for rendering the separator
    }
);
```

The widget allows passing in the same parameters you would to the `ListView.builder` constructor but `itemCount` is required so that when an item scrolls into view, it can see if it should attempt to load more items. Note that this is a callback that returns a boolean rather than being a boolean value. This allows the widget to not require a reference/copy of your data collection. The other parameters that can be specified are

- `hasMore`: a callback that indicates if there are more items that can be loaded
- `loadMore`: a callback to an asynchronous function that loads more items
- `loadMoreOffsetFromBottom`: determines when the list view should attempt to load more items based on of the index of the item is scrolling into view. This is relative to the bottom of the list and has a default value of 0 so that it loads when the last item within the list view scrolls into view. As an example, setting this to 1 would attempt to load more items when the second last item within the list view scrolls into view
- `onLoadMore`: a callback that is triggered when more items are being loaded. At first this will pass a boolean value of true to when items are being loaded by triggering the `loadMore` callback function. You could use this to update your UI to show a loading indicator
- `onLoadMoreFinished`: a callback that is triggered when items have finished being loading. You can use this to hide your loading indicator
- `separatorBuilder`: not required builder function that place separator between items 

Providing `onLoadMore` and `onLoadMoreFinished` callbacks means the widget doesn't make assumptions on how you want to render a loading indicator so it will be up to your application to handle these callbacks to render the appropriate UI.
