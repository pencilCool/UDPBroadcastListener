//
//  UDPBroadcastListener.m
//  UDPBroadcastListener
//
//  Created by yuhua Tang on 2023/2/20.
//

#import "UDPBroadcastListener.h"
#import "TYHUDPThreadSafeArray.h"
@import CocoaAsyncSocket;
@interface UDPBroadcastListener()<GCDAsyncUdpSocketDelegate>
@property (nonatomic,strong) GCDAsyncUdpSocket *socket;
@property (nonatomic,strong) TYHUDPThreadSafeArray *delegateArray;
@property (nonatomic,assign) uint16_t port;
@end
@implementation UDPBroadcastListener
+ (instancetype)shared {
    static UDPBroadcastListener *shared = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shared = [[self alloc] initPrivate];
    });
    return shared;
}

- (instancetype)initPrivate {
    self = [super init];
    if(self) {
        self.delegateArray = [[TYHUDPThreadSafeArray alloc] init];
        [self configSocket];
    }
    return self;
}

- (void)configSocket {
    [self resetWithPort:5555];
}

- (void)resetWithPort:(uint16_t)port {
    self.port = port;
    dispatch_queue_t queue = dispatch_get_main_queue();
    self.socket = [[GCDAsyncUdpSocket alloc] initWithDelegate:self delegateQueue:queue socketQueue:nil];
    NSError *error = nil;
    BOOL result = [self.socket bindToPort:port error:&error];
}


- (void)addDelegate:(id<GCDAsyncUdpSocketDelegate>)delegate {
    if(delegate == nil) return;
    if(![delegate conformsToProtocol:@protocol(GCDAsyncUdpSocketDelegate)]) return;
    if(![self.delegateArray containsObject:delegate]) {
        [self.delegateArray addObject:delegate];
    }
}

- (void)removeDelegate:(id<GCDAsyncUdpSocketDelegate>)delegate {
    if(delegate == nil) return;
    if(![delegate conformsToProtocol:@protocol(GCDAsyncUdpSocketDelegate)]) return;
    [self.delegateArray removeObject:delegate];
}

- (void)start {
    if (self.socket.isClosed) {
        [self resetWithPort:self.port];
    }
    [self.socket beginReceiving:nil];
}

- (void)pause {
    [self.socket pauseReceiving];
}

- (void)stop {
    [self.socket close];
}


//MARK: GCDAsyncUdpSocketDelegate

/**
 * By design, UDP is a connectionless protocol, and connecting is not needed.
 * However, you may optionally choose to connect to a particular host for reasons
 * outlined in the documentation for the various connect methods listed above.
 *
 * This method is called if one of the connect methods are invoked, and the connection is successful.
**/
- (void)udpSocket:(GCDAsyncUdpSocket *)sock didConnectToAddress:(NSData *)address {
    for(id<GCDAsyncUdpSocketDelegate> delegate in self.delegateArray) {
        if([delegate respondsToSelector:_cmd]) {
            [delegate udpSocket:sock didConnectToAddress:address];
        }
    }
}

/**
 * By design, UDP is a connectionless protocol, and connecting is not needed.
 * However, you may optionally choose to connect to a particular host for reasons
 * outlined in the documentation for the various connect methods listed above.
 *
 * This method is called if one of the connect methods are invoked, and the connection fails.
 * This may happen, for example, if a domain name is given for the host and the domain name is unable to be resolved.
**/
- (void)udpSocket:(GCDAsyncUdpSocket *)sock didNotConnect:(NSError * _Nullable)error {
    for(id<GCDAsyncUdpSocketDelegate> delegate in self.delegateArray) {
        if([delegate respondsToSelector:_cmd]) {
            [delegate udpSocket:sock didNotConnect:error];
        }
    }
}

/**
 * Called when the datagram with the given tag has been sent.
**/
- (void)udpSocket:(GCDAsyncUdpSocket *)sock didSendDataWithTag:(long)tag {
    for(id<GCDAsyncUdpSocketDelegate> delegate in self.delegateArray) {
        if([delegate respondsToSelector:_cmd]) {
            [delegate udpSocket:sock didSendDataWithTag:tag];
        }
    }
}

/**
 * Called if an error occurs while trying to send a datagram.
 * This could be due to a timeout, or something more serious such as the data being too large to fit in a sigle packet.
**/
- (void)udpSocket:(GCDAsyncUdpSocket *)sock didNotSendDataWithTag:(long)tag dueToError:(NSError * _Nullable)error {
    for(id<GCDAsyncUdpSocketDelegate> delegate in self.delegateArray) {
        if([delegate respondsToSelector:_cmd]) {
            [delegate udpSocket:sock didNotSendDataWithTag:tag dueToError:error];
        }
    }
}

/**
 * Called when the socket has received the requested datagram.
**/
- (void)udpSocket:(GCDAsyncUdpSocket *)sock
   didReceiveData:(NSData *)data
      fromAddress:(NSData *)address
withFilterContext:(nullable id)filterContext {
    for(id<GCDAsyncUdpSocketDelegate> delegate in self.delegateArray) {
        if([delegate respondsToSelector:_cmd]) {
            [delegate udpSocket:sock didReceiveData:data fromAddress:address withFilterContext:filterContext];
        }
    }
}

/**
 * Called when the socket is closed.
**/
- (void)udpSocketDidClose:(GCDAsyncUdpSocket *)sock
                withError:(NSError  * _Nullable)error {
    for(id<GCDAsyncUdpSocketDelegate> delegate in self.delegateArray) {
        if([delegate respondsToSelector:_cmd]) {
            [self udpSocketDidClose:sock withError:error];
        }
    }
}
@end
