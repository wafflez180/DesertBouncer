//
//  StoreScene.m
//  ballpumpGame
//
//  Created by Arthur Araujo on 2/14/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "StoreScene.h"
#import "purchaseCoinsNode.h"

@implementation StoreScene{
    CCLabelTTF *moneyLabel;
    
    CCNode *coinValueUpgrade;
    CCLabelTTF *coinValueDescriptionLabel;
    CCLabelTTF *coinValueUpgradePriceLabel;
    int coinValueUpgradePrice;
    CCSprite *coinValueUpgradSlotOne;
    CCSprite *coinValueUpgradSlotTwo;
    CCSprite *coinValueUpgradSlotThree;
    CCSprite *coinValueUpgradSlotFour;
    CCSprite *coinValueUpgradSlotFive;
    NSMutableArray *coinValueUpgradeNumberArray;
    
    CCNode *speedUpgrade;
    CCLabelTTF *speedDescriptionLabel;
    CCLabelTTF *speedUpgradePriceLabel;
    int speedUpgradePrice;
    CCSprite *speedUpgradSlotOne;
    CCSprite *speedUpgradSlotTwo;
    CCSprite *speedUpgradSlotThree;
    CCSprite *speedUpgradSlotFour;
    CCSprite *speedUpgradSlotFive;
    NSMutableArray *speedUpgradeNumberArray;
    
    CCNode *timeUpgrade;
    CCLabelTTF *timeDescriptionLabel;
    CCLabelTTF *timeUpgradePriceLabel;
    int timeUpgradePrice;
    CCSprite *timeUpgradSlotOne;
    CCSprite *timeUpgradSlotTwo;
    CCSprite *timeUpgradSlotThree;
    CCSprite *timeUpgradSlotFour;
    CCSprite *timeUpgradSlotFive;
    NSMutableArray *timeUpgradeNumberArray;
    
    CCNode *starttimeUpgrade;
    CCLabelTTF *starttimeDescriptionLabel;
    CCLabelTTF *starttimeUpgradePriceLabel;
    int starttimeUpgradePrice;
    CCSprite *starttimeUpgradSlotOne;
    CCSprite *starttimeUpgradSlotTwo;
    CCSprite *starttimeUpgradSlotThree;
    CCSprite *starttimeUpgradSlotFour;
    CCSprite *starttimeUpgradSlotFive;
    NSMutableArray *starttimeUpgradeNumberArray;
    
    purchaseCoinsNode *purchaseCoinScroll;
    
    NSNumberFormatter *fmt;
}

-(void)didLoadFromCCB{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateCoins:) name:@"updateCoins" object:nil];

    int coinValueUpgradedSlots = [[MGWU objectForKey:@"coinValueUpgradedSlots"] intValue];
    int speedUpgradedSlots = [[MGWU objectForKey:@"speedUpgradedSlots"] intValue];
    int timeUpgradedSlots = [[MGWU objectForKey:@"timeUpgradedSlots"] intValue];
    int starttimeUpgradedSlots = [[MGWU objectForKey:@"starttimeUpgradedSlots"] intValue];
    [self setUpCoinValueUpgrade:coinValueUpgradedSlots];
    [self setUpSpeedUpgrade:speedUpgradedSlots];
    [self setUptimeUpgrade:timeUpgradedSlots];
    [self setUpstarttimeUpgrade:starttimeUpgradedSlots];
    
    int currentCoinsInGame = [[MGWU objectForKey:@"coins"] intValue];
    
    fmt = [[NSNumberFormatter alloc] init];
    [fmt setNumberStyle:NSNumberFormatterDecimalStyle]; // to get commas (or locale equivalent)
    [fmt setMaximumFractionDigits:0]; // to avoid any decimal
        
    moneyLabel.string = [NSString stringWithFormat:@"%@",[fmt stringFromNumber:@(currentCoinsInGame)]];
}

#pragma CoinValueUpgrade
-(void)setUpCoinValueUpgrade:(int)UpgradedSlots{
    coinValueUpgradeNumberArray = [NSMutableArray array];
    [coinValueUpgradeNumberArray addObject:coinValueUpgradSlotOne];
    [coinValueUpgradeNumberArray addObject:coinValueUpgradSlotTwo];
    [coinValueUpgradeNumberArray addObject:coinValueUpgradSlotThree];
    [coinValueUpgradeNumberArray addObject:coinValueUpgradSlotFour];
    [coinValueUpgradeNumberArray addObject:coinValueUpgradSlotFive];
    
    [self setUpCoins];
}

-(void)setUpCoins{
    int coinValueUpgradedSlots = [[MGWU objectForKey:@"coinValueUpgradedSlots"] intValue];
    
    [self setUpSlots:coinValueUpgradedSlots :coinValueUpgradeNumberArray];
    
    NSString *description = [[NSString alloc] init];
    
    if (coinValueUpgradedSlots == 0) {
        description = @"ADDS BLUE COINS\nWORTH 5 GOLD COINS";//DONE
        coinValueUpgradePrice = 25;
    }else if(coinValueUpgradedSlots == 1){
        description = @"ADDS RED COINS\nWORTH 10 GOLD COINS";//DONE
        coinValueUpgradePrice = 100;
    }else if(coinValueUpgradedSlots == 2){
        description = @"ADDS RANDOM GREEN COINS\nWORTH 100 GOLD COINS";
        coinValueUpgradePrice = 250;//100
    }else if(coinValueUpgradedSlots == 3){
        description = @"REPLACES ALL GOLD\nCOINS WITH BLUE";
        coinValueUpgradePrice = 500;
    }else if(coinValueUpgradedSlots == 4){
        description = @"MAKES ALL COINS RED";
        coinValueUpgradePrice = 1000;
    }else if (coinValueUpgradedSlots == 5){
        description = @"MAX";
        coinValueUpgradePrice = 0;
    }
    if (coinValueUpgradePrice != 0) {
        coinValueUpgradePriceLabel.string = [NSString stringWithFormat:@"%i  coins", coinValueUpgradePrice];
    }else{
        coinValueUpgradePriceLabel.string = [NSString stringWithFormat:@"MAX"];
    }
    coinValueDescriptionLabel.string = description;
}



#pragma SpeedUpgrade
-(void)setUpSpeedUpgrade:(int)UpgradedSlots{
    speedUpgradeNumberArray = [NSMutableArray array];
    [speedUpgradeNumberArray addObject:speedUpgradSlotOne];
    [speedUpgradeNumberArray addObject:speedUpgradSlotTwo];
    [speedUpgradeNumberArray addObject:speedUpgradSlotThree];
    [speedUpgradeNumberArray addObject:speedUpgradSlotFour];
    [speedUpgradeNumberArray addObject:speedUpgradSlotFive];
    
    [self setUpSpeed];
}

-(void)setUpSpeed{
    int speedUpgradedSlots = [[MGWU objectForKey:@"speedUpgradedSlots"] intValue];
    
    [self setUpSlots:speedUpgradedSlots :speedUpgradeNumberArray];
    
    NSString *description = [[NSString alloc] init];
    
    if (speedUpgradedSlots == 0) {
        description = @"INCREASE PUMP SPEED TO 0.25 \n(currently 0.3)";
        speedUpgradePrice = 25;
    }else if(speedUpgradedSlots == 1){
        description = @"INCREASE PUMP SPEED TO 0.2 \n(currently 0.25)";
        speedUpgradePrice = 100;
    }else if(speedUpgradedSlots == 2){
        description = @"INCREASE PUMP SPEED TO 0.15 \n(currently 0.2)";
        speedUpgradePrice = 250;
    }else if(speedUpgradedSlots == 3){
        description = @"INCREASE PUMP SPEED TO 0.125 \n(currently 0.15)";
        speedUpgradePrice = 500;
    }else if(speedUpgradedSlots == 4){
        description = @"INCREASE PUMP SPEED TO 0.1 \n(currently 0.125)";
        speedUpgradePrice = 1000;
    }else if (speedUpgradedSlots == 5){
        description = @"MAX\n(currently 0.1)";
        speedUpgradePrice = 0;
    }
    if (speedUpgradePrice != 0) {
        speedUpgradePriceLabel.string = [NSString stringWithFormat:@"%i  coins", speedUpgradePrice];
    }else{
        speedUpgradePriceLabel.string = [NSString stringWithFormat:@"MAX"];
    }
    speedDescriptionLabel.string = description;
}


#pragma TimeUpgrade
-(void)setUptimeUpgrade:(int)UpgradedSlots{
    timeUpgradeNumberArray = [NSMutableArray array];
    [timeUpgradeNumberArray addObject:timeUpgradSlotOne];
    [timeUpgradeNumberArray addObject:timeUpgradSlotTwo];
    [timeUpgradeNumberArray addObject:timeUpgradSlotThree];
    [timeUpgradeNumberArray addObject:timeUpgradSlotFour];
    [timeUpgradeNumberArray addObject:timeUpgradSlotFive];
    
    [self setUpTime];
}

-(void)setUpTime{
    int timeUpgradedSlots = [[MGWU objectForKey:@"timeUpgradedSlots"] intValue];
    
    [self setUpSlots:timeUpgradedSlots :timeUpgradeNumberArray];
    
    NSString *description = [[NSString alloc] init];
    
    if (timeUpgradedSlots == 0) {
        description = @"DECREASE TIME PENALTY BY 1 \n(currently 10)";
        timeUpgradePrice = 25;
    }else if(timeUpgradedSlots == 1){
        description = @"DECREASE TIME PENALTY BY 1 \n(currently 9)";
        timeUpgradePrice = 100;
    }else if(timeUpgradedSlots == 2){
        description = @"DECREASE TIME PENALTY BY 1 \n(currently 8)";
        timeUpgradePrice = 250;
    }else if(timeUpgradedSlots == 3){
        description = @"DECREASE TIME PENALTY BY 1 \n(currently 7)";
        timeUpgradePrice = 500;
    }else if(timeUpgradedSlots == 4){
        description = @"DECREASE TIME PENALTY BY 1 \n(currently 6)";
        timeUpgradePrice = 1000;
    }else if (timeUpgradedSlots == 5){
        description = @"MAX\n(currently 5)";
        timeUpgradePrice = 0;
    }
    if (timeUpgradePrice != 0) {
        timeUpgradePriceLabel.string = [NSString stringWithFormat:@"%i  coins", timeUpgradePrice];
    }else{
        timeUpgradePriceLabel.string = [NSString stringWithFormat:@"MAX"];
    }
    timeDescriptionLabel.string = description;
}

#pragma starttimeUpgrade
-(void)setUpstarttimeUpgrade:(int)UpgradedSlots{
    starttimeUpgradeNumberArray = [NSMutableArray array];
    [starttimeUpgradeNumberArray addObject:starttimeUpgradSlotOne];
    [starttimeUpgradeNumberArray addObject:starttimeUpgradSlotTwo];
    [starttimeUpgradeNumberArray addObject:starttimeUpgradSlotThree];
    [starttimeUpgradeNumberArray addObject:starttimeUpgradSlotFour];
    [starttimeUpgradeNumberArray addObject:starttimeUpgradSlotFive];
    
    [self setUpstarttime];
}

-(void)setUpstarttime{
    int starttimeUpgradedSlots = [[MGWU objectForKey:@"starttimeUpgradedSlots"] intValue];
    
    [self setUpSlots:starttimeUpgradedSlots :starttimeUpgradeNumberArray];
    
    NSString *description = [[NSString alloc] init];
    
    if (starttimeUpgradedSlots == 0) {
        description = @"INCREASE START TIME BY 1 \n(currently 3)";
        starttimeUpgradePrice = 25;
    }else if(starttimeUpgradedSlots == 1){
        description = @"INCREASE START TIME BY 1 \n(currently 4)";
        starttimeUpgradePrice = 100;
    }else if(starttimeUpgradedSlots == 2){
        description = @"INCREASE START TIME BY 1 \n(currently 5)";
        starttimeUpgradePrice = 250;
    }else if(starttimeUpgradedSlots == 3){
        description = @"INCREASE START TIME BY 1 \n(currently 6)";
        starttimeUpgradePrice = 500;
    }else if(starttimeUpgradedSlots == 4){
        description = @"INCREASE START TIME BY 1 \n(currently 7)";
        starttimeUpgradePrice = 1000;
    }else if (starttimeUpgradedSlots == 5){
        description = @"MAX\n(currently 8)";
        starttimeUpgradePrice = 0;
    }
    if (starttimeUpgradePrice != 0) {
    starttimeUpgradePriceLabel.string = [NSString stringWithFormat:@"%i  coins", starttimeUpgradePrice];
    }else{
        starttimeUpgradePriceLabel.string = [NSString stringWithFormat:@"MAX"];
    }
    starttimeDescriptionLabel.string = description;
}

-(void)setUpSlots:(int)UpgradedSlots :(NSMutableArray*)SlotArray{
    for (int i = 0; i < 5; i++) {
        CCSprite *currentSlot = [[[SlotArray objectAtIndex:i] children] objectAtIndex:0];
        if (UpgradedSlots > i) {
            currentSlot.opacity = 1;
        }else{
            currentSlot.opacity = 0;
        }
    }
}

-(void)upgradeCoinValue{
    int currentCoinsInGame = [[MGWU objectForKey:@"coins"] intValue];
    currentCoinsInGame = currentCoinsInGame - coinValueUpgradePrice;
    int coinValueUpgradedSlots = [[MGWU objectForKey:@"coinValueUpgradedSlots"] intValue];
    
    if (currentCoinsInGame >= 0 && coinValueUpgradedSlots != 5) {
        [MGWU setObject:[NSNumber numberWithInt:currentCoinsInGame] forKey:@"coins"];
        coinValueUpgradedSlots++;
        [MGWU setObject:[NSNumber numberWithInt:coinValueUpgradedSlots] forKey:@"coinValueUpgradedSlots"];
        moneyLabel.string = [NSString stringWithFormat:@"%@",[fmt stringFromNumber:@(currentCoinsInGame)]];
        [self setUpCoins];
    }else{
        [self openPurchaseStore];
    }
    [self playButtonSound];
}

-(void)upgradeSpeed{
    int currentCoinsInGame = [[MGWU objectForKey:@"coins"] intValue];
    currentCoinsInGame = currentCoinsInGame - speedUpgradePrice;
    int speedUpgradedSlots = [[MGWU objectForKey:@"speedUpgradedSlots"] intValue];
    
    if (currentCoinsInGame >= 0 && speedUpgradedSlots != 5) {
        [MGWU setObject:[NSNumber numberWithInt:currentCoinsInGame] forKey:@"coins"];
        speedUpgradedSlots++;
        [MGWU setObject:[NSNumber numberWithInt:speedUpgradedSlots] forKey:@"speedUpgradedSlots"];
        moneyLabel.string = [NSString stringWithFormat:@"%@",[fmt stringFromNumber:@(currentCoinsInGame)]];
        [self setUpSpeed];
    }else{
        [self openPurchaseStore];
    }
    [self playButtonSound];
}

-(void)upgradeTime{
    int currentCoinsInGame = [[MGWU objectForKey:@"coins"] intValue];
    currentCoinsInGame = currentCoinsInGame - timeUpgradePrice;
    int timeUpgradedSlots = [[MGWU objectForKey:@"timeUpgradedSlots"] intValue];
    
    if (currentCoinsInGame >= 0 && timeUpgradedSlots != 5) {
        [MGWU setObject:[NSNumber numberWithInt:currentCoinsInGame] forKey:@"coins"];
        timeUpgradedSlots++;
        [MGWU setObject:[NSNumber numberWithInt:timeUpgradedSlots] forKey:@"timeUpgradedSlots"];
        moneyLabel.string = [NSString stringWithFormat:@"%@",[fmt stringFromNumber:@(currentCoinsInGame)]];
        [self setUpTime];
    }else{
        [self openPurchaseStore];
    }
    [self playButtonSound];
}

-(void)upgradeStartTime{
    int currentCoinsInGame = [[MGWU objectForKey:@"coins"] intValue];
    currentCoinsInGame = currentCoinsInGame - starttimeUpgradePrice;
    int starttimeUpgradedSlots = [[MGWU objectForKey:@"starttimeUpgradedSlots"] intValue];
    
    if (currentCoinsInGame >= 0 && starttimeUpgradedSlots != 5) {
        [MGWU setObject:[NSNumber numberWithInt:currentCoinsInGame] forKey:@"coins"];
        starttimeUpgradedSlots++;
        [MGWU setObject:[NSNumber numberWithInt:starttimeUpgradedSlots] forKey:@"starttimeUpgradedSlots"];
        moneyLabel.string = [NSString stringWithFormat:@"%@",[fmt stringFromNumber:@(currentCoinsInGame)]];        [self setUpstarttime];
    }else{
        [self openPurchaseStore];
    }
    [self playButtonSound];
}

-(void)ExitStore{
    CCTransition *transition = [CCTransition transitionMoveInWithDirection:CCTransitionDirectionDown duration:0.2];
    CCScene *MainScene = [CCBReader loadAsScene:@"MainScene"];
    [[CCDirector sharedDirector] replaceScene:MainScene withTransition:transition];
    [self unscheduleAllSelectors];
    [self playButtonSound];
}

-(void)playButtonSound{
    bool sound = [[MGWU objectForKey:@"sound"] boolValue];
    
    if (sound) {
        // access audio object
        OALSimpleAudio *audio = [OALSimpleAudio sharedInstance];
        // play sound effect in a loop
        [audio playEffect:@"buttonFX.wav" loop:NO];
    }else{
        // access audio object
        OALSimpleAudio *audio = [OALSimpleAudio sharedInstance];
        // play sound effect in a loop
                [audio stopAllEffects];
        [audio stopEverything];
    }
}


-(void)openPurchaseStore{
    [purchaseCoinScroll runAction:[CCActionMoveTo actionWithDuration:0.2 position:ccp(0.5,0.5)]];
}

-(void)updateCoins:(NSNotification *)notification{
    int currentCoinsInGame = [[MGWU objectForKey:@"coins"] intValue];
    moneyLabel.string = [NSString stringWithFormat:@"%@",[fmt stringFromNumber:@(currentCoinsInGame)]];
}
@end
