# UDPBroadcastListener

[![CI Status](https://img.shields.io/travis/pencilCool/UDPBroadcastListener.svg?style=flat)](https://travis-ci.org/pencilCool/UDPBroadcastListener)
[![Version](https://img.shields.io/cocoapods/v/UDPBroadcastListener.svg?style=flat)](https://cocoapods.org/pods/UDPBroadcastListener)
[![License](https://img.shields.io/cocoapods/l/UDPBroadcastListener.svg?style=flat)](https://cocoapods.org/pods/UDPBroadcastListener)
[![Platform](https://img.shields.io/cocoapods/p/UDPBroadcastListener.svg?style=flat)](https://cocoapods.org/pods/UDPBroadcastListener)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.
[API usage](https://github.com/pencilCool/UDPBroadcastListener/blob/main/Example/UDPBroadcastListener/TYHViewController.m)
```
@interface ADelegate:NSObject<GCDAsyncUdpSocketDelegate>
@end

@implementation  ADelegate

- (void)udpSocket:(GCDAsyncUdpSocket *)sock
   didReceiveData:(NSData *)data
      fromAddress:(NSData *)address
withFilterContext:(id)filterContext {
    NSLog(@"Adelegate");
}
@end


@interface BDelegate:NSObject<GCDAsyncUdpSocketDelegate>
@end

@implementation  BDelegate

- (void)udpSocket:(GCDAsyncUdpSocket *)sock
   didReceiveData:(NSData *)data
      fromAddress:(NSData *)address
withFilterContext:(id)filterContext {
    NSLog(@"Bdelegate");
}
@end



 [[UDPBroadcastListener shared] addDelegate:[ADelegate new]];
 [[UDPBroadcastListener shared] addDelegate:[BDelegate new]];
```
## Requirements

## Installation

UDPBroadcastListener is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'UDPBroadcastListener'
```

## Author

pencilCool, yhtangcoder@gmail.com

## Test

用 python 执行 udp_broadcast.py 脚本可以用来在 localhost 内发送广播，默认端口号是 5555

## License

UDPBroadcastListener is available under the MIT license. See the LICENSE file for more info.
