//
//  purchaseCoinsNode.m
//  ballpumpGame
//
//  Created by Arthur Araujo on 2/17/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "purchaseCoinsNode.h"

@implementation purchaseCoinsNode{
    
}

-(void)didLoadFromCCB{
 
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

-(void)restorePurchases{
    [MGWU restoreProductsWithCallback:@selector(restoredProducts:) onTarget:self];
}

-(void)restoredProducts:(NSString *)purchasedStr{
    if (purchasedStr != nil) {
        NSLog(@"%@", purchasedStr);
        NSLog(@"Restored");
        NSArray *strings = (NSArray *)purchasedStr;
        for (int i = 0; strings.count > i; i++) {
            NSString *theString = [strings objectAtIndex:i];
            if ([theString containsString:@"com.twentyDollarPurchase.product3ID"]) {
                int coins = [[MGWU objectForKey:@"coins"] intValue];
                coins = 6000 + coins;
                [MGWU setObject:[NSNumber numberWithInt:coins] forKey:@"coins"];
                NSLog(@"Restored $20");
            }
            if ([theString containsString:@"com.fiveDollarPurchase.product2ID"]) {
                int coins = [[MGWU objectForKey:@"coins"] intValue];
                coins = 1500 + coins;
                [MGWU setObject:[NSNumber numberWithInt:coins] forKey:@"coins"];
                NSLog(@"Restored $5");
            }
            if ([theString containsString:@"com.oneDollarPurchase.product2ID"]) {
                int coins = [[MGWU objectForKey:@"coins"] intValue];
                coins = 250 + coins;
                [MGWU setObject:[NSNumber numberWithInt:coins] forKey:@"coins"];
                NSLog(@"Restored $1");
            }
            if ([theString containsString:@"com.removeads.product2ID"]) {
                [MGWU setObject:[NSNumber numberWithBool:YES] forKey:@"RemovedAds"];
                NSLog(@"Restored RemovedAds");
            }
        }
    }else{
        NSLog(@"CANCELED $20 PURCHASE");
        [self closeScroll];
    }
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

-(void)close:(int)CoinsToAdd{
    int coins = [[MGWU objectForKey:@"coins"] intValue];
    coins = CoinsToAdd + coins;
    [MGWU setObject:[NSNumber numberWithInt:coins] forKey:@"coins"];

    [self runAction:[CCActionMoveTo actionWithDuration:0.5 position:ccp(0.5,-0.5)]];
}

-(void)closeScroll{
    [self setPosition:ccp(0.5,-0.5)];
}

@end