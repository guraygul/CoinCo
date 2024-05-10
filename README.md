# CoinCo
### An application for crypto lovers. You can browse through coins, share them and access their details easily.

## Table Of Contents
- [Features](#features)
  - [In app Gifs](#in-app-gifs)
  - [Tech Stack](#tech-stack)
  - [Architecture](#architecture)
- [Getting Started](#getting-started)
  - [Requirements](#requirements)
  - [Installation](#installation)
- [Known Issues](#known-issues)
- [Nice to have](#nice-to-have)

## Features
#### Browse Coins:
- Explore the Crypto world
- The Crypto datas are fetching from an Mock API so they are not real-time.

#### Coin Details
- Learn more about coins with graphs and additional informations
- Share your favorite coins with your friends

## In app Gifs
| Home Screen | Detail Screen |
| -------- | -------- |
| ![HomeScreen](https://github.com/guraygul/CoinCo/assets/58820744/91163e6a-b7e2-4ae3-bd2a-c63c16677825) | ![DetailScreen](https://github.com/guraygul/CoinCo/assets/58820744/c24fb608-0b32-499c-b5c5-33bb2fa3125e) | 

## Tech Stack
- Xcode: Version 15.3
- Language: Swift 5.10
- Minimum iOS Version: 17.4
- Dependency Manager: SPM

## Architecture
| MVVM Architecture |
| -------- |
| <img width="900" alt="MVVM" src="https://github.com/guraygul/CoinCo/assets/58820744/a0ee1bbd-287c-4aac-a604-d08a97aae266"> |

In developing CoinCo App, the programmatically approuch and MVVM (Modal-View-ViewModel) architecture are being used for these key reasons:

- Separation of Concerns: MVVM cleanly separates the UI (View) from business logic and data (ViewModel), promoting code clarity and ease of maintenance.
- Testability: MVVM enables easy unit testing of ViewModel logic independently of the UI, leading to more robust and reliable code.
- Code Reusability: ViewModel classes in MVVM can be reused across different views, reducing duplication and promoting modular development.
- UI Responsiveness: MVVM's data binding mechanisms ensure that the UI updates automatically in response to changes in underlying data, enhancing user experience.
- Maintainability and Scalability: With its modular design, MVVM simplifies maintenance and enables the addition of new features without disrupting existing functionality.
- Support for Data Binding: MVVM aligns well with data binding frameworks, reducing boilerplate code and improving developer productivity.
- Enhanced Collaboration: MVVM's clear separation of concerns allows developers with different skill sets to work concurrently on different parts of the application.
- Adaptability to Platform Changes: MVVM provides a flexible architecture that can easily adapt to changes in platform requirements or UI frameworks, ensuring long-term viability.

## Getting Started
### Requirements
Before you begin, ensure you have the following:
- Xcode installed

Also, make sure that these dependencies are added in your project's target:
- Alamofire: Alamofire is an elegant HTTP networking library for Swift that simplifies network requests and handling responses.
- SDWebImage: SDWebImage is a widely-used library for asynchronously downloading and caching images in iOS and macOS applications, providing a seamless and efficient way to manage image loading.

### Installation
1. Clone the repository:
```Swift
https://github.com/guraygul/CoinCo.git
```
2. Open the project in Xcode::
```
cd CoinCo
open CoinCo.xcodeproj
```
3. Add required dependencies using Swift Package Manager:
```
Alamofire
SDWebImage
```
4. Build and run the project.

## Known Issues
- Learn more button has no padding for the bottom of the screen in IPhone SE due to Scroll View hierarchy
- Decentraland (MANA) image is bad due to the url of the API

## Nice to have
- It would be better if we were fetching the data from a real-time API
- Localization for other languages can be added to be able to reach more user.
- More refactoring could be done for the Controllers.
