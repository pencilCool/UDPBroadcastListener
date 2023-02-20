//
//  TYHViewController.m
//  UDPBroadcastListener
//
//  Created by pencilCool on 02/20/2023.
//  Copyright (c) 2023 pencilCool. All rights reserved.
//

#import "TYHViewController.h"
@import UDPBroadcastListener;
@import CocoaAsyncSocket;
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


@interface TYHViewController ()

@end

@implementation TYHViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [UDPBroadcastListener shared];
    
    [self addCell:@"add A delegate" action:^{
        [[UDPBroadcastListener shared] addDelegate:[ADelegate new]];
        NSLog(@"add A delegate");
    }];
    
    [self addCell:@"add B delegate" action:^{
        [[UDPBroadcastListener shared] addDelegate:[BDelegate new]];
        NSLog(@"add B delegate");
    }];
    
    [self addCell:@"Start" action:^{
        [[UDPBroadcastListener shared] start];
        NSLog(@"start");
    }];
    
    [self addCell:@"pause" action:^{
        [[UDPBroadcastListener shared] pause];
        NSLog(@"pause");
    }];
    
    [self addCell:@"Stop" action:^{
        [[UDPBroadcastListener shared] stop];
        NSLog(@"Stop");
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
