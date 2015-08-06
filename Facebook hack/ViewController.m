//
//  ViewController.m
//  Facebook hack
//
//  Created by OR on 8/6/15.
//  Copyright (c) 2015 com.facebook.hack. All rights reserved.
//

#import "ViewController.h"
@import MultipeerConnectivity;
@import AVFoundation.AVPlayer;


@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.myPeerID = [[MCPeerID alloc] initWithDisplayName:@"Or"];
    self.session = [[MCSession alloc] initWithPeer:self.myPeerID];
    self.session.delegate = self;
    self.advertiser = [[MCNearbyServiceAdvertiser alloc] initWithPeer:self.myPeerID discoveryInfo:@{} serviceType:@"iosToOsx"];
    self.advertiser.delegate = self;
    [self.advertiser startAdvertisingPeer];
    NSLog(@"Waiting for connection...");
//    [self playPeer:@"http://cfvod.kaltura.com/pd/p/811441/sp/81144100/serveFlavor/entryId/1_mhyj12pj/v/1/flavorId/1_2rs07zkf/name/a.mp4" withOffset:CMTimeMake(20, 1)];
}

- (void)playPeer:(NSString *)link withOffset:(CMTime)offset {
    NSURL *mediaUrl = [NSURL
                       URLWithString:link];
    self.avPlayer = [AVPlayer playerWithURL:mediaUrl];
    [self.view setWantsLayer:YES];
    AVPlayerLayer * playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.avPlayer];
    [playerLayer setFrame:self.view.bounds];
    [self.view enterFullScreenMode:[NSScreen mainScreen] withOptions:@{}];
//    playerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    [self.view.layer addSublayer:playerLayer];
    [self.avPlayer play];
    [self.avPlayer seekToTime:offset];
}

- (void)advertiser:(MCNearbyServiceAdvertiser *)advertiser didReceiveInvitationFromPeer:(MCPeerID *)peerID withContext:(NSData *)context invitationHandler:(void (^)(BOOL, MCSession *))invitationHandler {
    invitationHandler(true, self.session);
}

- (void)session:(MCSession *)session peer:(MCPeerID *)peerID didChangeState:(MCSessionState)state {
    if (state == MCSessionStateConnected) {

        NSLog(@"Connected!");
    }
}

- (void)session:(MCSession *)session didReceiveData:(NSData *)data fromPeer:(MCPeerID *)peerID {
    NSDictionary *dataDictionary = (NSDictionary*) [NSKeyedUnarchiver unarchiveObjectWithData:data];
    NSString *urlString = [[NSString alloc]initWithFormat:@"%@",[dataDictionary objectForKey:@"urlString"]];
    CMTime offset=CMTimeMake(0, 1);
    if ([dataDictionary objectForKey:@"offset"] != nil){
        offset=CMTimeMake([[dataDictionary objectForKey:@"offset"] integerValue], 1);
    }
    NSLog(@"Received data: {urlString: %@, offset: %f seconds}", urlString, CMTimeGetSeconds(offset));
    [self playPeer:urlString withOffset:offset];
}

- (void)session:(MCSession *)session didFinishReceivingResourceWithName:(NSString *)resourceName fromPeer:(MCPeerID *)peerID atURL:(NSURL *)localURL withError:(NSError *)error {
    
}

- (void)session:(MCSession *)session didStartReceivingResourceWithName:(NSString *)resourceName fromPeer:(MCPeerID *)peerID withProgress:(NSProgress *)progress {
    
}

- (void)session:(MCSession *)session didReceiveStream:(NSInputStream *)stream withName:(NSString *)streamName fromPeer:(MCPeerID *)peerID {
    
}

- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}

@end
