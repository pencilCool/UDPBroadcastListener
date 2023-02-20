//
//  UDPBroadcastListener.h
//  UDPBroadcastListener
//
//  Created by yuhua Tang on 2023/2/20.
//

#import <Foundation/Foundation.h>
@protocol GCDAsyncUdpSocketDelegate;
NS_ASSUME_NONNULL_BEGIN

@interface UDPBroadcastListener : NSObject
+ (instancetype)shared;
- (void)start;
- (void)pause;
- (void)stop;

- (void)addDelegate:(id<GCDAsyncUdpSocketDelegate>)delegate;
- (void)removeDelegate:(id<GCDAsyncUdpSocketDelegate>)delegate;
- (void)resetWithPort:(uint16_t)port;

@end

NS_ASSUME_NONNULL_END
