IdentityMapper ![travis-ci](https://travis-ci.org/pjechris/IdentityMapper.svg)
==============

IdentityMapper is an implementation of the [identity map pattern](http://martinfowler.com/eaaCatalog/identityMap.html).
IdentityMapper intend to bring this pattern to your Objective-C applications. No more issues with your models not being updated correctly!

**Features**:

- volatile storage. As soon as the stored objects are released by your application they're gone from the identity map
- metadata. As iOS applications can live for a while IdentityMapper provide you with metadata so you can determine if your stored objects might need to be refreshed

## Installation

Installation has never been so easy thanks to Cocoapods:

1. Add IdentityMapper to your Podfile ```pod 'IdentityMapper'```
2. Run ```pod install```
3. Enjoy ;)

## How to get started

## License

This project is under the MIT license. See the LICENSE file for more info.
