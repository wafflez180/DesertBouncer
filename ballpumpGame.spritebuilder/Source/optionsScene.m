//
//  optionsScene.m
//  ballpumpGame
//
//  Created by Arthur Araujo on 2/16/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "optionsScene.h"

@implementation optionsScene{
    CCSprite *volumeONbutton;
    CCSprite *volumeOFFbutton;
}

-(void)didLoadFromCCB{
    bool sound =  [[MGWU objectForKey:@"sound"] boolValue];
    if (!sound) {
        volumeONbutton.visible = FALSE;
        volumeOFFbutton.visible = true;
    }else{
        volumeONbutton.visible = true;
        volumeOFFbutton.visible = false;
    }
}

-(void)changeVolume{
    if (volumeONbutton.visible != true) {
        [MGWU setObject:[NSNumber numberWithBool:YES] forKey:@"sound"];
        volumeONbutton.visible = true;
        volumeOFFbutton.visible = false;
        // access audio object
        OALSimpleAudio *audio = [OALSimpleAudio sharedInstance];
        // play sound effect in a loop
        [audio playBg:@"mainmenumusic.mp3" loop:YES];
    }else{
        [MGWU setObject:[NSNumber numberWithBool:NO] forKey:@"sound"];
        volumeONbutton.visible = false;
        volumeOFFbutton.visible = true;
        OALSimpleAudio *audio = [OALSimpleAudio sharedInstance];
        // play sound effect in a loop
        [audio stopAllEffects];
        [audio stopEverything];
    }
    [self playButtonSound];
}

-(void)tutorial{
    [MGWU setObject:[NSNumber numberWithBool:YES] forKey:@"tutorial"];
    [self exitOptions];
}

-(void)orbivore{
    NSString *AppstoreLink = @"https://itunes.apple.com/us/app/orbivore/id914284583?mt=8";
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:AppstoreLink]];
    [self playButtonSound];
}

-(void)hackeroutbreak{
    NSString *AppstoreLink = @"https://itunes.apple.com/us/app/hacker-outbreak/id909745334?mt=8";
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:AppstoreLink]];
    [self playButtonSound];
}

-(void)exitOptions{
    CCTransition *transition = [CCTransition transitionCrossFadeWithDuration:0.2];
    CCScene *MainScene = [CCBReader loadAsScene:@"MainScene"];
    [[CCDirector sharedDirector] replaceScene:MainScene withTransition:transition];
    [self playButtonSound];
    [self unscheduleAllSelectors];
    NSLog(@"Exited optionsScene");
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
@end
