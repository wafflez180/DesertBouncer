//
//  Scroll.m
//  ballpumpGame
//
//  Created by Arthur Araujo on 1/18/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "Scroll.h"

@implementation Scroll{
    CCLabelTTF *scoreLabel;
    CCLabelTTF *highscoreLabel;
    bool clickedTryAgain;
}

-(void)didLoadFromCCB{
    //PUT IN THE NSUSERDEFAULTS AND THE HIGHSCORE
    clickedTryAgain = false;
}

-(void)setScoreLabel:(int)score{
    int highscore = [[MGWU objectForKey:@"highscore"] intValue];

    NSString *scoreString = [NSString stringWithFormat:@"%d%@", score, @"s"];
    scoreLabel.string = scoreString;
    highscoreLabel.string = [NSString stringWithFormat:@"%d%@", highscore, @"s"];
}

-(void)tryagain{
    if (clickedTryAgain == false) {
        clickedTryAgain = true;
        if (self.tryAgainButton.enabled != false || self.scale != 0) {
            _tryAgainButton.enabled = false;
            [[NSNotificationCenter defaultCenter] postNotificationName:@"TryAgain" object:nil userInfo:nil];
        }
    }
}

@end
