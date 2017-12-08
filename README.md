# WeatherApp

A simple weather app that requests weather forecasts from [Dark Sky API](https://darksky.net/dev) and displays it. The code also doubles as a showcase for the MVVM architecture using a binding library [RxSwift](https://github.com/ReactiveX/RxSwift) and the Coordinator pattern (http://khanlou.com/2015/01/the-coordinator/).

## Running the Project

This project requires Xcode 9+ and Swift 4

## Design Decisions

#### MVVM Architecture

Apple's standard iOS app architecture makes use of MVC. Through the years, many have found that this lead to increased difficulty in scaling an app. There are other architectural patterns out there that can be used (e.g VIPER, Unidirectional data flow) but I have chosen to use this one as this is the common and modern approach to iOS app development. It is just enough for the start of a small app and can scale up to a mid-to-large sized application.

#### RxSwift

MVVM in iOS can be done by using KVO but using a [functional reactive programming](https://en.wikipedia.org/wiki/Functional_reactive_programming) library decreases code and a declarative way of programming. RxSwift, part of the [ReactiveX](http://reactivex.io/) family, by  is used to listen for changes in data and allow the app to react once the data comes in. It also has a clearer way of scheduling work in the background thread and bringing it back to the main thread.

#### Coordinators

To better the separation of concerns, the coordinator pattern is used to manage the display of the view controllers. Rather than view controllers calling one another directly, the coordinator allows better separation between them so that view controllers can just focus on displaying the UI while the coordinator is the one directing which view controllers to show the user.

## Dependencies

This project manages it's dependencies using CocoaPods

#### Moya

This is a layer of abstraction for working with APIs. It helps ease writing of HTTP clients for any API and helps testing by allowing stubbing responses.

#### ObjectMapper

Makes mapping objects from JSON and back simpler.

#### RxSwift, RxCocoa, RxDataSources

A functional reactive programming library used along with its other helper libraries. Makes UIKit reactive.

#### PureLayout

Makes working with Autolayout through code simpler to read.

## Assets

Background images were taken from [Pixabay](https://pixabay.com/)

Weather icons were taken from [Icons8](https://pixabay.com/)
