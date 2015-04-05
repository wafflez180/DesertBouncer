//
//  MainScene.h
//  ballpumpGame
//
//  Created by Arthur Araujo on 2/14/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//
#import "CCScene.h"
#import <GoogleMobileAds/GADInterstitial.h>

@interface MainScene : CCScene <CCPhysicsCollisionDelegate>

@property (nonatomic, strong) GADInterstitial *interstitial;

@end
