## [0.3.0] 11/1/2020
* **BREAKING CHANGE** Updated rxdart dependency
* Bump minimum Flutter version to 1.12
* Update pedantic dependency
* Recreate example app with minor refactoring
* Updated example to use shimmer package when showing placeholder item card that is displayed when loading more items

## [0.2.0+2] 28/9/2019
* Add pub badge to readme

## [0.2.0+1] 14/8/2019
* Update email address in pubspec.yaml

## [0.2.0] 10/6/2019
* **BREAKING CHANGE** Updated rxdart dependency

## [0.1.0+1] 27/3/2019
* No functional changes in this release. Changes were to fix formatting to meet Dart guidelines

## [0.1.0] - 25/2/2019
* **BREAKING CHANGE** Updated rxdart dependency
* Formatted README. Thanks to PR from [Mohammed Salman](https://github.com/msal4)

## [0.0.4+3] - 15/8/2018

* Reordering changelog

## [0.0.4+2] - 15/8/2018

* **BREAKING CHANGE** separated `onLoadMore` callback. There is now an `onLoadMore` that doesn't pass a boolean and is triggered when more items are being loaded and `onLoadMoreFinished` when more items have finished being loaded.
* Updated README to explain `onLoadMore` and `onLoadMoreFinished`

## [0.0.4+1] - 15/8/2018

* Updated README

## [0.0.4] - 15/8/2018

* **BREAKING CHANGES** fixed an issue that occurred where package no longer worked due to the way the list view was triggering the loading of more items. This was due to the fact that setState was being called while the build was occurred. Changed this now to use a `StreamBuilder` wrapped around a `ListView.builder` now so that upon reaching the nth item from the bottom will emit an item onto a stream that executes the function required to load more items and rebuild the `ListView` when the functions completes execution. As a result of these changes `itemCount` and `hasMore` are now callbacks
* Updated sample to add navigating to an item details page for testing

## [0.0.3] - 23/7/2018

* Corrected some bad grammar in the README due to late night blogging/coding...

## [0.0.2] - 21/7/2018

* Updated license

## [0.0.1] - 21/7/2018

* Initial release