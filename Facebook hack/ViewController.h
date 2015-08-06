//
//  ViewController.h
//  Facebook hack
//
//  Created by OR on 8/6/15.
//  Copyright (c) 2015 com.facebook.hack. All rights reserved.
//

#import <Cocoa/Cocoa.h>
@import MultipeerConnectivity;
@import AVFoundation;

@interface ViewController : NSViewController <MCNearbyServiceAdvertiserDelegate, MCSessionDelegate>
@property MCPeerID *myPeerID;
@property MCSession *session;
@property MCPeerID *ownPeer;
@property MCNearbyServiceAdvertiser *advertiser;
@property AVPlayer *avPlayer;
//@property NSTimeInterval currentTime;


@end

