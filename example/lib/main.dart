import 'dart:async';

import 'package:flutter/material.dart';
import 'package:incrementally_loading_listview/incrementally_loading_listview.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flutter Demo',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Item> items;
  bool _loadingMore;
  bool _hasMoreItems;
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
      items = new List<Item>();
      for (var i = 0; i < _numItemsPage; i++) {
        items.add(Item('Item ${i + 1}'));
      }
      _hasMoreItems = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Colors.yellow,
      appBar: new AppBar(
        title: new Text(widget.title),
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
                          Card(
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                children: <Widget>[
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Container(
                                        width: 60.0,
                                        height: 60.0,
                                        color: Colors.grey,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            8.0, 0.0, 0.0, 0.0),
                                        child: Container(
                                          color: Colors.grey,
                                          child: Text(
                                            item.name,
                                            style: TextStyle(
                                                color: Colors.transparent),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        0.0, 8.0, 0.0, 0.0),
                                    child: Container(
                                      color: Colors.grey,
                                      child: Text(
                                        item.message,
                                        style: TextStyle(
                                            color: Colors.transparent),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      );
                    }
                    return new ItemCard(item: item);
                  },
                );
              default:
                return Text('Something went wrong');
            }
          }),
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

class ItemDetailsPage extends StatelessWidget {
  final Item item;
  const ItemDetailsPage(this.item);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.yellow,
        appBar: new AppBar(
          title: new Text(item.name),
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
