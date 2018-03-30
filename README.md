# TwitterClient
[![Swift](https://img.shields.io/badge/Swift-4.0-orange.svg)](https://swift.org)
[![Xcode](https://img.shields.io/badge/Xcode-9.0-blue.svg)](https://developer.apple.com/xcode)
[![MIT](https://img.shields.io/badge/License-MIT-red.svg)](https://opensource.org/licenses/MIT)

TwitterClient is an mini application that show followers of current user, and show latest 10 tweets for each follower. 

## Requirements:
- **iOS** 8.0+
- Xcode 9.0+
- Swift 4.0+

This application used MVP and MVC architecture patterns. And I gonna explain each layer.

## MVP Concepts
##### Presentation Logic
* `View` - delegates user interaction events to the `Presenter` and displays data passed by the `Presenter`
    * All `UIViewController`, `UIView`, `UITableViewCell` subclasses belong to the `View` layer
    * Usually the view is passive / dumb - it shouldn't contain any complex logic and that's why most of the times we don't need write Unit Tests for it
* `Presenter` - contains the presentation logic and tells the `View` what to present
    * Usually we have one `Presenter` per scene (view controller)
    * It doesn't reference the concrete type of the `View`, but rather it references the `View` protocol that is implemented usually by a `UIViewController` subclass
    * It should be a plain `Swift` class and not reference any `iOS` framework classes - this makes it easier to reuse it maybe in a `macOS` application
    * It should be covered by Unit Tests
* `Configurator` - injects the dependency object graph into the scene (view controller)
    * You could very easily use a DI (dependency injection) library. Unfortunately DI libraries are not quite mature yet on `iOS` / `Swift`
    * Usually it contains very simple logic and we don't need to write Unit Tests for it
* `Router` - contains navigation / flow logic from one scene (view controller) to another
    * In some communities / blog posts it might be referred to as a `FlowController`
    * Writing tests for it is quite difficult because it contains many references to `iOS` framework classes so usually we try to keep it really simple and we don't write Unit Tests for it
    * It is usually referenced only by the `Presenter` but due to the `func prepare(for segue: UIStoryboardSegue, sender: Any?)` method we some times need to reference it in the view controller as well

* `NetWorking` - handle every call to internet, and I used `TwitterManager` class to handle all networking calls to twitter apis, and used `Swifter` library over `OAuth` way to avoid reinvent the wheel :D

* `Persistance Data` - I used `Realm` Database to handle persisting data on device for offline usage. `RealmConfigurator` used to configure realm schema's versions and realm object. `DBManager` Singleton used to save and retrieve data from realm.
