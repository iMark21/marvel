## Marvel Super Heroes | MVVM-C | RxSwift | RxDataSources | StateView 
❤️ A sample Marvel heroes application based on MVVM-C architecture.

### MVVM-C

- Base on [sergdort/CleanArchitectureRxSwift](https://github.com/sergdort/CleanArchitectureRxSwift)
- Using [RxSwift](https://github.com/ReactiveX/RxSwift) - Reactive Programming in Swift 
- Using [RxDataSources](https://github.com/RxSwiftCommunity/RxDataSources) - to manage data sources in collection and table views with RxSwift
- Using [Realm & RxRealm](https://github.com/RxSwiftCommunity/RxDataSources) - to save data. (Characters).
- Using [Coordinators](https://blog.kulman.sk/architecting-ios-apps-coordinators/) to control the navigation flow of the application
- Using [Composition](https://medium.com/commencis/reusability-and-composition-in-swift-6630fc199e16) to avoid making use of baseviewcontroller
- Using [Codable](https://www.swiftbysundell.com/basics/codable) to mapping data response
- Using [Fastlane](https://fastlane.tools) to run tests in terminal
- Using [Repository Pattern](https://medium.com/tiendeo-tech/ios-repository-pattern-in-swift-85a8c62bf436) to manage requests and responses
- Implemented [Unit Test](https://geekytheory.com/la-importancia-de-ui-testing-y-unit-testing)

### Screenshots
<img src="list.png" width="250"> <img src="detail.png" width="250">

### Project 

#### Install
  * Before starting
    - Run `pod install`
    - Get your Marvel API Keys [Here](https://developer.marvel.com)
    - Set your API Keys into the Marvel-Info.plist
    - Open `marvel.xcworkspace`
    - Execute the application, explore it manually and make yourself familiar with the code.
    
  * Run tests in Terminal
```
fastlane tests
```

#### Structure
- APP
  - Coordinator
  - Database
  - Delegate
  - Extensions
  - Log
  - Network
  - Protocols
- Domain
  - Characters
    - Request
    - Model
  - Media
    - Comics
      - Request
      - Model 
    - Series
      - Request
      - Model 
  - Repository
- Layout
- Use Cases
  - Character Detail
    - Components
      - Media Component
        - Layout
        - View
        - ViewModel
      - Detail Component 
        - Layout
        - View
        - ViewModel  
    - Coordinator
    - View
    - ViewModel 
  - Characters List 
    - Actions
    - Components
      - Character Component
        - Layout
        - View
        - ViewModel  
    - Coordinator
    - View
    - ViewModel

### Third party
- [CryptoSwift](https://github.com/krzyzanowskim/CryptoSwift) for encryption in MD5
- [SDWebImage](https://github.com/SDWebImage/SDWebImage) for load and manage images

### Author
iMark21, marques.jm@icloud.com
