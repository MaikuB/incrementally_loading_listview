import 'dart:async';

import 'package:flutter/material.dart';
import 'package:incrementally_loading_listview/incrementally_loading_listview.dart';
import 'package:shimmer/shimmer.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'IncrementallyLoadingListView demo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Item> items;
  bool _loadingMore;
  bool _hasMoreItems;
  bool _useSeparator;
  int _maxItems = 30;
  int _numItemsPage = 10;
  Future _initialLoad;

  Future _loadMoreItems() async {
    final totalItems = items.length;
    await Future.delayed(Duration(seconds: 3), () {
      for (var i = 0; i < _numItemsPage; i++) {
        items.add(Item('Item ${totalItems + i + 1}'));
      }
    });

    _hasMoreItems = items.length < _maxItems;
  }

  @override
  void initState() {
    super.initState();
    _initialLoad = Future.delayed(Duration(seconds: 3), () {
      items = List<Item>();
      for (var i = 0; i < _numItemsPage; i++) {
        items.add(Item('Item ${i + 1}'));
      }
      _hasMoreItems = true;
      _useSeparator = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.yellow,
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          IconButton(
              icon: Icon(
                  _useSeparator ? Icons.border_horizontal : Icons.border_clear),
              tooltip: _useSeparator ? "Not use separator" : "Use separator",
              onPressed: () {
                setState(() {
                  _useSeparator = !_useSeparator;
                });
              }),
        ],
      ),
      body: FutureBuilder(
        future: _initialLoad,
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return Center(child: CircularProgressIndicator());
            case ConnectionState.done:
              return IncrementallyLoadingListView(
                hasMore: () => _hasMoreItems,
                itemCount: () => items.length,
                loadMore: () async {
                  // can shorten to "loadMore: _loadMoreItems" but this syntax is used to demonstrate that
                  // functions with parameters can also be invoked if needed
                  await _loadMoreItems();
                },
                onLoadMore: () {
                  setState(() {
                    _loadingMore = true;
                  });
                },
                onLoadMoreFinished: () {
                  setState(() {
                    _loadingMore = false;
                  });
                },
                loadMoreOffsetFromBottom: 2,
                itemBuilder: (context, index) {
                  final item = items[index];
                  if ((_loadingMore ?? false) && index == items.length - 1) {
                    return Column(
                      children: <Widget>[
                        ItemCard(item: item),
                        PlaceholderItemCard(item: item),
                      ],
                    );
                  }
                  return ItemCard(item: item);
                },
                separatorBuilder: _useSeparator
                    ? (context, index) => const Divider(
                          color: Colors.black,
                        )
                    : null,
              );
            default:
              return Text('Something went wrong');
          }
        },
      ),
    );
  }
}

class ItemCard extends StatelessWidget {
  const ItemCard({
    Key key,
    @required this.item,
  }) : super(key: key);

  final Item item;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Image.network(item.avatarUrl),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(8.0, 0.0, 0.0, 0.0),
                      child: Text(item.name),
                    ),
                  )
                ],
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0.0, 8.0, 0.0, 0.0),
                child: Text(item.message),
              )
            ],
          ),
        ),
      ),
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => ItemDetailsPage(item)),
      ),
    );
  }
}

class PlaceholderItemCard extends StatelessWidget {
  const PlaceholderItemCard({Key key, @required this.item}) : super(key: key);

  final Item item;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Shimmer.fromColors(
          baseColor: Colors.grey[300],
          highlightColor: Colors.grey[100],
          child: Column(
            children: <Widget>[
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    width: 60.0,
                    height: 60.0,
                    color: Colors.white,
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(8.0, 0.0, 0.0, 0.0),
                    child: Container(
                      color: Colors.white,
                      child: Text(
                        item.name,
                        style: TextStyle(color: Colors.transparent),
                      ),
                    ),
                  )
                ],
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0.0, 8.0, 0.0, 0.0),
                child: Container(
                  color: Colors.white,
                  child: Text(
                    item.message,
                    style: TextStyle(color: Colors.transparent),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class ItemDetailsPage extends StatelessWidget {
  final Item item;
  const ItemDetailsPage(this.item);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.yellow,
        appBar: AppBar(
          title: Text(item.name),
        ),
        body: Container(
          child: Text(item.message),
        ));
  }
}

class Item {
  final String name;
  final String avatarUrl = 'http://via.placeholder.com/60x60';
  final String message =
      'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.';

  Item(this.name);
}
