<p>
    <img src="https://img.shields.io/badge/version-1.0.0-green" />
    <img src="https://img.shields.io/badge/Swift-5.5.3-ff69b4.svg" />
    <img src="https://img.shields.io/badge/iOS-12+-brightgreen.svg" />
    <img src="https://img.shields.io/badge/macOS-10.12+-brightgreen.svg" />
    <a href="https://twitter.com/lukeeep_">
        <img src="https://img.shields.io/badge/Contact-@lukeeep_-lightgrey.svg?style=flat" alt="Twitter: @lukeeep_" />
    </a>
</p>

# KrakenAPI

>### IMPORTANT
>This Library is heavily inspired by [Antonio Casero](@acaserop). The original repo can be found [here](https://github.com/antoniocasero/Kraken). I added missing endpoints, async/await support and documentation.
>
>Please thoroughly vet everything in the code for yourself before using this lib to buy, sell, or move any of your assets.
>
>PLEASE submit an issue or pull request if you notice any bugs, security holes, or potential improvements. Any help is appreciated!

## Description

This library is a wrapper for the [Kraken Digital Asset Trading Platform](https://www.kraken.com) API. Official documentation from Kraken can be found [here](https://www.kraken.com/help/api).

The current version  can be used to query public/private data and make trades. Private data queries and trading functionality require use of your Kraken account API keys.

Kraken Swift was built by [Antonio Casero](@acaserop) 

## Installation

### Swift Package Manager
To use in your project simply add this to your ```Package.swift``` under ```dependencies```.

```swift
.package(url: "https://github.com/lukepistrol/KrakenAPI.git", .upToNextMajor(from: "1.0.0"))
```
When using Xcode go to ```File > Add Packages``` and add the following URL: 
```
https://github.com/lukepistrol/KrakenAPI.git
```

## Usage

Create a Kraken client using your credentials

```swift
import KrakenAPI

let credentials = Kraken.Credentials(apiKey: "YOUR-API-KEY", 
                                     privateKey: "YOUR-PRIVATE-KEY")

let kraken = Kraken(credentials: credentials)
```

### Server Time

Get the server time from the Kraken API server.

```swift
kraken.serverTime { result in 
    switch result {
        case .success(let serverTime):
            print(serverTime["unixtime"]) // 1393056191
            print(serverTime["rfc1123"]) // "Sun, 13 Mar 2022 08:28:04 GMT"
        case .failure(let error):
            print(error) 
    }
}
```

Or using async await:

```swift
let result = await kraken.serverTime()

switch result {
	case .success(let serverTime):
		print(serverTime["unixtime"]) // 1393056191
		print(serverTime["rfc1123"]) // "Sun, 13 Mar 2022 08:28:04 GMT"
	case .failure(let error):
		print(error) 
}
```

See more documentation [here](https://docs.kraken.com/rest/) and in code documentation.
