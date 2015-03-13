//
//  purchaseCoinsNode.h
//  ballpumpGame
//
//  Created by Arthur Araujo on 2/17/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "CCNode.h"
#import "ALIncentivizedInterstitialAd.h"
#import "ALAdRewardDelegate.h"
#import "ALAdLoadDelegate.h"

@interface purchaseCoinsNode : CCNode <ALAdLoadDelegate, ALAdRewardDelegate, ALAdDisplayDelegate>

@property (assign, atomic, getter=isVideoAvailable) BOOL videoAvailable;

@end
