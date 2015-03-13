//
//  purchaseCoinsNode.m
//  ballpumpGame
//
//  Created by Arthur Araujo on 2/17/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "purchaseCoinsNode.h"
#import "ALIncentivizedInterstitialAd.h"
#import "ALAdRewardDelegate.h"
#import "ALAdLoadDelegate.h"
#import "ALAdService.h"

@implementation purchaseCoinsNode{
    
}

-(void)didLoadFromCCB{
    // Set the display delegate so we can receive the "wasHiddenIn" callback for preloading the next ad.
    [ALIncentivizedInterstitialAd shared].adDisplayDelegate = self;
    // If you want to use a load delegate, set it here.  For this example, we will use nil.
    if ([ALIncentivizedInterstitialAd isReadyForDisplay] == false) {
        [ALIncentivizedInterstitialAd preloadAndNotify:nil];
    }
    
    //Load video
}

-(void)twentyDollarPurchase{
    [MGWU buyProduct:@"com.twentyDollarPurchase.product3ID" withCallback:@selector(twenty:) onTarget:self];
}

-(void)fiveDollarPurchase{
    [MGWU buyProduct:@"com.fiveDollarPurchase.product2ID" withCallback:@selector(five:) onTarget:self];
}

-(void)oneDollarPurchase{
    [MGWU buyProduct:@"com.oneDollarPurchase.product2ID" withCallback:@selector(one:) onTarget:self];
}
-(void)removeAds{
    [MGWU buyProduct:@"com.removeads.product2ID" withCallback:@selector(adsRemove:) onTarget:self];
}

-(void)twenty:(NSString *)purchasedStr{
    if (purchasedStr != nil) {
        [self close:6000];
    }else{
        NSLog(@"CANCELED $20 PURCHASE");
        [self closeScroll];
    }
}
-(void)five:(NSString *)purchasedStr{
    if (purchasedStr != nil) {
        [self close:1500];
    }else{
        NSLog(@"CANCELED $5 PURCHASE");
        [self closeScroll];
    }
}
-(void)one:(NSString *)purchasedStr{
    if (purchasedStr != nil) {
        [self close:250];
    }else{
        NSLog(@"CANCELED $1 PURCHASE");
        [self closeScroll];
    }
}
-(void)adsRemove:(NSString *)purchasedStr{
    if (purchasedStr != nil) {
        [MGWU setObject:[NSNumber numberWithBool:YES] forKey:@"RemovedAds"];
    }else{
        NSLog(@"CANCELED $2 PURCHASE");
        [self closeScroll];
    }
}

-(void)watchAd{
    // Check to see if an ad is ready before attempting to show.
    if([ALIncentivizedInterstitialAd isReadyForDisplay]){
        
        // Show call if using a reward delegate.
        [ALIncentivizedInterstitialAd showAndNotify: self];
    }
    else{
        // No rewarded ad is currently available.  Perform failover logic...
        NSLog(@"Video not avaliable");
    }
}


-(void)close:(int)CoinsToAdd{
    int coins = [[MGWU objectForKey:@"coins"] intValue];
    coins = CoinsToAdd + coins;
    [MGWU setObject:[NSNumber numberWithInt:coins] forKey:@"coins"];

    [self runAction:[CCActionMoveTo actionWithDuration:0.5 position:ccp(0.5,-0.5)]];
}

-(void)closeScroll{
    [self setPosition:ccp(0.5,-0.5)];
}

#pragma mark ALAdRewardDelegate implementation... mandatory for rewarded videos

-(void) rewardValidationRequestForAd:(ALAd *)ad didSucceedWithResponse:(NSDictionary *)response
{
    // Grant your user coins, or better yet, set up postbacks in the UI and refresh the balance from your server.
    
    NSString* currencyName = [response objectForKey: @"Coins"];
    // For example - "Coins", "Gold", whatever you set in the UI.
    
    NSString* amountGivenString = [response objectForKey: @"5"];
    // For example, "5" or "5.00" if you've specified an amount in the UI.
    // Obviously NSStrings aren't super helpful for numerica data, so you'll probably want to convert to NSNumber.
    
    int amountGiven = 5;
    
    int coins = [[MGWU objectForKey:@"coins"] intValue];
    coins = amountGiven + coins;
    [MGWU setObject:[NSNumber numberWithInt:coins] forKey:@"coins"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"updateCoins" object:nil userInfo:nil];
    
    // Do something with this information.
    // [MYCurrencyManagerClass updateUserCurrency: currencyName withChange: amountGiven];
    
    // By default we'll show a UIAlertView informing your user of the currency & amount earned.
    // If you don't want this, you can turn it off in the Manage Apps UI.
}

-(void) rewardValidationRequestForAd:(ALAd *)ad didFailWithError:(NSInteger)responseCode
{
    if(responseCode == kALErrorCodeIncentivizedValidationNetworkTimeout)
    {
        // The SDK was unable to reach AppLovin over the network.  The user's device is likely experiencing poor connectivity.
    }
    else if(responseCode == kALErrorCodeIncentivizedUserClosedVideo)
    {
        /* Indicates the user has exited a video prior to completion.  You may have already received didSucceedWithResponse.
         If you choose, to handle this case, you may optionally cancel the previously granted reward (if any). */
    }
    else
    {
        /* Something else went wrong. Wait a bit before showing another rewarded video. */
    }
}

-(void) rewardValidationRequestForAd:(ALAd *)ad wasRejectedWithResponse:(NSDictionary *)response
{
    // The user's reward was marked as fraudulent, they are most likely trying to modify their balance illicitly.
}

-(void) userDeclinedToViewAd: (ALAd*) ad
{
    /* When prompted, the user decided they did not want to view a rewarded video.  This is only possible if you have the
     "post video modal" enabled on managed apps.  Otherwise, feel free to omit this method - it's optional in the protocol. */
}

-(void) rewardValidationRequestForAd:(ALAd *)ad didExceedQuotaWithResponse:(NSDictionary *)response {
    // No longer used }
}

// ALAdDisplayDelegate methods
- (void)ad:(ALAd *)ad wasClickedIn:(UIView *)view{}
- (void)ad:(ALAd *)ad wasDisplayedIn:(UIView *)view{}
- (void)ad:(ALAd *)ad wasHiddenIn:(UIView *)view {
    // The user has closed the ad.  We must preload the next rewarded video.
    if ([ALIncentivizedInterstitialAd isReadyForDisplay] == false) {
    [ALIncentivizedInterstitialAd preloadAndNotify:nil];
    }
}

@end
