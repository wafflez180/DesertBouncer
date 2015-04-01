#import "MainScene.h"
#import "thePump.h"
#import "cobblestone.h"
#import "Scroll.h"
#import "coin.h"
#import "ALInterstitialAd.h"
#import "ALAdDisplayDelegate.h"
#import "ALInterstitialAd.h"
#import "ALAdService.h"
#import "ABGameKitHelper.h"
#import <Social/Social.h>
#import <Twitter/Twitter.h>

@implementation MainScene{
    CCSprite *ball;
    CCSprite *eyeWhites;
    CCSprite *eyeColor;
    CCSprite *eyeTint;
    CCSprite *timeIcon;
    CCSprite *coinIcon;
    CCSprite *singletapHand;
    CCSprite *normalHand;
    CCSprite *background;
    CCSprite *sun;
    CCSprite *moon;
    CCNodeColor *obstacleLine;
    CCNodeColor *darknessColorNode;
    CCNodeGradient *sunsetGradient;
    CCPhysicsNode *physicsNode;
    CCLabelTTF *timerLabel;
    CCLabelTTF *coinLabel;
    CCLabelTTF *tapToStartLabel;
    CCLabelTTF *titleLabel;
    CCLabelTTF *tutorialReadyLabel;
    CCLabelTTF *optionLabelButton;
    CCLabelTTF *leaderboardLabelButton;
    thePump *pumpBottom;
    thePump *pumpTop;
    bool ballOnBottomPump;
    bool ballOnTopPump;
    bool canTap;
    bool hitLine;
    bool endOfSpeedUp;
    bool movingAfterHit;
    bool white;
    float timer;
    float overallTimer;
    float gameStartTime;
    float gameEndTime;
    float lineSpeedRate;
    float lineSpeedUpCounter;
    float speed;
    float time;
    float BallSpeed;
    float spawnBarRate;
    float oldBarSpeed;
    float oldSpeed;
    CGPoint ballTopPosition;
    CGPoint ballBottomPosition;
    bool timing;
    bool changingEyeColor;
    bool canSpawnSpace;
    bool spawningBars;
    bool tutorial;
    bool newstage;
    int spaceLength;
    int originalSpaceLength;
    int cobblestoneLength;
    int currentCoinsInGame;
    int coinValue;
    int spawnCounter;
    int oldSpawnCounter;
    int scoreToShare;
    int tutorialCobblestoneCounter;
    
    CCNodeColor *colorOne;
    CCNodeColor *colorTwo;
    CCNodeColor *colorThree;
    CCNodeColor *colorFour;
    CCNodeColor *colorFive;
    CCNodeColor *colorOneDark;
    CCNodeColor *colorTwoDark;
    CCNodeColor *colorThreeDark;
    CCNodeColor *colorFourDark;
    CCNodeColor *colorFiveDark;
    
    Scroll *loseScroll;
    
    CCButton *BeginGameButton;
    CCButton *optionButton;
    CCButton *leaderboardButton;
    
    int coinValueUpgradedSlots;
    int speedUpgradedSlots;
    
    NSNumberFormatter *fmt;
}

-(void)didLoadFromCCB{
    NSString *rank = @"0";
    NSDate *lastRead    = (NSDate *)[[NSUserDefaults standardUserDefaults] objectForKey:rank];
    if (lastRead == nil)     // App first run: set up user defaults.
    {
        NSDictionary *appDefaults  = [NSDictionary dictionaryWithObjectsAndKeys:[NSDate date], rank, nil];
        
        // do any other initialization you want to do here - e.g. the starting default values.
        // [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"should_play_sounds"];
        
        [MGWU setObject:[NSNumber numberWithInt:0] forKey:@"highscore"];
        [MGWU setObject:[NSNumber numberWithInt:0] forKey:@"coins"];
        [MGWU setObject:[NSNumber numberWithInt:0] forKey:@"coinValueUpgradedSlots"];
        [MGWU setObject:[NSNumber numberWithInt:0] forKey:@"speedUpgradedSlots"];
        [MGWU setObject:[NSNumber numberWithInt:0] forKey:@"timeUpgradedSlots"];
        [MGWU setObject:[NSNumber numberWithInt:0] forKey:@"starttimeUpgradedSlots"];
        [MGWU setObject:[NSNumber numberWithBool:YES] forKey:@"tutorial"];
        [MGWU setObject:[NSNumber numberWithBool:NO] forKey:@"RemovedAds"];
        [MGWU setObject:[NSNumber numberWithBool:YES] forKey:@"sound"];
        
        // sync the defaults to disk
        [[NSUserDefaults standardUserDefaults] registerDefaults:appDefaults];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:rank];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(startNewGame:) name:@"TryAgain" object:nil];
    // Optional: Assign delegates.
    [ALInterstitialAd shared].adLoadDelegate = self;
    [ALInterstitialAd shared].adDisplayDelegate = self;
    colorOne.visible = false;
    colorTwo.visible = false;
    colorThree.visible = false;
    colorFour.visible = false;
    colorFour.visible = false;
    colorFive.visible = false;
    colorOneDark.visible = false;
    colorTwoDark.visible = false;
    colorThreeDark.visible = false;
    colorFourDark.visible = false;
    colorFiveDark.visible = false;
    singletapHand.visible = false;
    normalHand.visible = false;
    leaderboardButton.visible = false;
    leaderboardLabelButton.visible = false;
    changingEyeColor = true;
    tutorialReadyLabel.visible = false;
    speed = 1.5;
    spaceLength = 0;
    cobblestoneLength = 0;
    spawnBarRate = 0.06;
    canSpawnSpace = false;
    currentCoinsInGame = [[MGWU objectForKey:@"coins"] intValue];
    tutorial = false;
    coinValueUpgradedSlots = [[MGWU objectForKey:@"coinValueUpgradedSlots"] intValue];
    speedUpgradedSlots = [[MGWU objectForKey:@"speedUpgradedSlots"] intValue];
    
    fmt = [[NSNumberFormatter alloc] init];
    [fmt setNumberStyle:NSNumberFormatterDecimalStyle]; // to get commas (or locale equivalent)
    [fmt setMaximumFractionDigits:0]; // to avoid any decimal
    
    coinLabel.string = [NSString stringWithFormat:@"%@",[fmt stringFromNumber:@(currentCoinsInGame)]];    coinValue = 1;
    
    loseScroll.visible = true;
    self.userInteractionEnabled = true;
    physicsNode.collisionDelegate = self;
    
    ballTopPosition = ccp(0.5,(1 - 0.195) - (ball.contentSizeInPoints.height / self.contentSizeInPoints.height));
    
    ballBottomPosition = ccp(0.5,0.195);
    
    NSLog(@"MainScene opened");
    ball.position = ballBottomPosition;
    ballOnBottomPump = true;
    canTap = true;
    int starttimeUpgradedSlots = [[MGWU objectForKey:@"starttimeUpgradedSlots"] intValue];
    timer = 4 + starttimeUpgradedSlots;
    timerLabel.string = [NSString stringWithFormat:@"%d", (int)timer];
    lineSpeedUpCounter = 0;
    
    loseScroll.scale = 0;
    [loseScroll.animationManager runAnimationsForSequenceNamed:@"CloseScrollTimeline"];
    
    titleLabel.opacity = 1;
    tapToStartLabel.opacity = 1;
    white = true;
    [self pulseTapToStart];
    
    bool sound = [[MGWU objectForKey:@"sound"] boolValue];
    
    if (sound) {
        // access audio object
        OALSimpleAudio *audio = [OALSimpleAudio sharedInstance];
        // play sound effect in a loop
        [audio playBg:@"mainmenumusic.mp3" loop:YES];
    }else{
        // access audio object
        OALSimpleAudio *audio = [OALSimpleAudio sharedInstance];
        // play sound effect in a loop
        [audio stopAllEffects];
        [audio stopEverything];
    }
    [ABGameKitHelper sharedHelper];
    [darknessColorNode stopAllActions];
    [background stopAllActions];
    [sunsetGradient stopAllActions];
    [sun stopAllActions];
    [moon stopAllActions];
    [darknessColorNode runAction:[CCActionFadeTo actionWithDuration:0 opacity:0]];//Starts with 0.0
    [background runAction:[CCActionFadeTo actionWithDuration:0 opacity:1]];//Starts with 1.0
    [sunsetGradient runAction:[CCActionFadeTo actionWithDuration:0 opacity:0]];//Starts with 0.0
    [sun runAction:[CCActionMoveTo actionWithDuration:0 position:ccp(.119,0.945)]];//Starts with
    id goDown = [CCActionMoveTo actionWithDuration:0 position:ccp(0.119,-0.10)];
    [moon runAction:[CCActionSequence actions:goDown, nil]];
}

-(void)pulseTapToStart{
    if (!timing && !tutorial) {
        if (white){
            [tapToStartLabel runAction:[CCActionFadeIn actionWithDuration:1]];
            white = false;
        }else{
            [tapToStartLabel runAction:[CCActionFadeOut actionWithDuration:1]];
            white = true;
        }
        [self performSelector:@selector(pulseTapToStart) withObject:nil afterDelay:1.5];
    }
}

-(void)options{
    [self playButtonSound];
    if (!timing) {
        CCTransition *transition = [CCTransition transitionCrossFadeWithDuration:0.2];
        CCScene *TheOptionsScene = [CCBReader loadAsScene:@"optionsScene"];
        [[CCDirector sharedDirector] replaceScene:TheOptionsScene withTransition:transition];
        [self unscheduleAllSelectors];
    }
}

-(void)leaderboard{
    [[ABGameKitHelper sharedHelper] showLeaderboard:@"com.DesertBouncer.leaderboardID"];
}

-(void)share{
    [self playButtonSound];
    
    int scoreShare= scoreToShare;
    
    if (scoreToShare > 0) {
        scoreShare = scoreShare;
    }else{
        scoreShare = 0;
    }
    
    NSString *message = [NSString stringWithFormat:@"OMG! I got %i seconds on Desert Bouncer! #desertbouncer https://itunes.apple.com/us/app/desert-bouncer/id968104999?ls=1&mt=8", scoreToShare];
    
    UIImage *screen = [self captureScreen];
    
    UIActivityViewController *activityViewController = [[UIActivityViewController alloc]initWithActivityItems:[NSArray arrayWithObjects:message,screen,nil] applicationActivities:nil];
    
    if ([UIPopoverPresentationController class] != nil) {
        UIPopoverPresentationController *popover = activityViewController.popoverPresentationController;
        if (popover)
        {
            popover.sourceView = [CCDirector sharedDirector].view;
            //popover.sourceRect = sender.bounds;
            popover.permittedArrowDirections = UIPopoverArrowDirectionAny;
        }
    }
    
    [[CCDirector sharedDirector] presentViewController:activityViewController animated:YES completion:nil];
}

- (UIImage *) captureScreen {
    UIGraphicsBeginImageContextWithOptions([CCDirector sharedDirector].view.bounds.size, NO, [UIScreen mainScreen].scale);
    
    [[CCDirector sharedDirector].view drawViewHierarchyInRect:[CCDirector sharedDirector].view.bounds afterScreenUpdates:YES];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}



-(void)BeginGame{
    if (titleLabel.opacity != 0) {
        [titleLabel runAction:[CCActionFadeOut actionWithDuration:0.5]];
    }
    [tapToStartLabel stopAllActions];
    [tapToStartLabel runAction:[CCActionFadeOut actionWithDuration:0.5]];
    [self.animationManager runAnimationsForSequenceNamed:@"HidingButtonsTimeline"];

    BeginGameButton.enabled = false;
    BeginGameButton.visible = false;
    
    bool boolTutorial =[[MGWU objectForKey:@"tutorial"] boolValue];
    if (boolTutorial) {
        [self startTutorial];
    }else{
        tutorial = false;
        [singletapHand runAction:[CCActionFadeOut actionWithDuration:0.5]];
        [normalHand runAction:[CCActionFadeOut actionWithDuration:0.5]];
        [tutorialReadyLabel runAction:[CCActionFadeOut actionWithDuration:0.5]];
        [self startGame];
        [self performSelector:@selector(spawnBar) withObject:nil afterDelay:1];
    }
}

-(void)startGame{
    if (!timing) {
        [darknessColorNode stopAllActions];
        [background stopAllActions];
        [sunsetGradient stopAllActions];
        [sun stopAllActions];
        [moon stopAllActions];
        [darknessColorNode runAction:[CCActionFadeTo actionWithDuration:120 opacity:0.3]];//Starts with 0.0
        [background runAction:[CCActionFadeTo actionWithDuration:120 opacity:0.5]];//Starts with 1.0
        [sunsetGradient runAction:[CCActionFadeTo actionWithDuration:120 opacity:0.5]];//Starts with 0.0
        [sun runAction:[CCActionMoveTo actionWithDuration:80 position:ccp(.119,-0.10)]];//Starts with
        id wait = [CCActionDelay actionWithDuration:80];
        id goUp = [CCActionMoveTo actionWithDuration:40 position:ccp(0.119,0.80)];
        [moon runAction:[CCActionSequence actions:wait,goUp, nil]];
        //  x: 11.9 y: 94.2
        self.userInteractionEnabled = true;
        timing = true;
        gameStartTime = overallTimer;
        speed = 1.5;
        coinValue = 1;
        spaceLength = 0;
        cobblestoneLength = 0;
        canSpawnSpace = false;
        oldSpeed = 0;
        changingEyeColor = true;
        currentCoinsInGame = [[MGWU objectForKey:@"coins"] intValue];
        [self.animationManager runAnimationsForSequenceNamed:@"HidingButtonsTimeline"];
        coinValueUpgradedSlots = [[MGWU objectForKey:@"coinValueUpgradedSlots"] intValue];
        speedUpgradedSlots = [[MGWU objectForKey:@"speedUpgradedSlots"] intValue];
        if (speedUpgradedSlots == 0) {
            BallSpeed = 0.3;
        }else if(speedUpgradedSlots == 1){
            BallSpeed = 0.25;
        }else if(speedUpgradedSlots == 2){
            BallSpeed = 0.2;
        }else if(speedUpgradedSlots == 3){
            BallSpeed = 0.15;
        }else if(speedUpgradedSlots == 4){
            BallSpeed = 0.125;
        }else if(speedUpgradedSlots == 5){
            BallSpeed = 0.1;
        }
        int starttimeUpgradedSlots = [[MGWU objectForKey:@"starttimeUpgradedSlots"] intValue];
        timer = 4 + starttimeUpgradedSlots;
        bool sound = [[MGWU objectForKey:@"sound"] boolValue];
        [self performSelector:@selector(checkSpawning) withObject:nil afterDelay:2];
        
        if (sound) {
            // access audio object
            OALSimpleAudio *audio = [OALSimpleAudio sharedInstance];
            // play sound effect in a loop
            [audio playBg:@"gamemusic.mp3" loop:YES];
        }else{
            // access audio object
            OALSimpleAudio *audio = [OALSimpleAudio sharedInstance];
            // play sound effect in a loop
            [audio stopAllEffects];
            [audio stopEverything];
        }
    }
}

-(void)endGame{
    [darknessColorNode stopAllActions];
    [background stopAllActions];
    [sunsetGradient stopAllActions];
    [sun stopAllActions];
    [moon stopAllActions];
    [darknessColorNode runAction:[CCActionFadeTo actionWithDuration:.5 opacity:0]];//Starts with 0.0
    [background runAction:[CCActionFadeTo actionWithDuration:.5 opacity:1]];//Starts with 1.0
    [sunsetGradient runAction:[CCActionFadeTo actionWithDuration:.5 opacity:0]];//Starts with 0.0
    [sun runAction:[CCActionMoveTo actionWithDuration:.5 position:ccp(.119,0.945)]];//Starts with
    id goDown = [CCActionMoveTo actionWithDuration:.5 position:ccp(0.119,-0.10)];
    [moon runAction:[CCActionSequence actions:goDown, nil]];
    leaderboardButton.visible = true;
    leaderboardLabelButton.visible = true;
    optionButton.enabled = false;
    optionButton.visible = false;
    optionLabelButton.visible = false;
    coinValue = 1;
    speed = 1.5;
    oldSpeed = 0;
    spaceLength = 0;
    cobblestoneLength = 0;
    canSpawnSpace = false;
    self.userInteractionEnabled = false;
    timing = false;
    [self stopAllActions];
    [loseScroll runAction:[CCActionScaleTo actionWithDuration:0.25 scale:1]];
    int gameTime = [self getGameTime];
    [self performSelector:@selector(openScroll) withObject:nil afterDelay:0.3];
    loseScroll.tryAgainButton.enabled = false;
    scoreToShare = gameTime;
    int highscore = [[MGWU objectForKey:@"highscore"] intValue];
    if (gameTime > highscore) {
        [MGWU setObject:[NSNumber numberWithInt:gameTime] forKey:@"highscore"];
        [[ABGameKitHelper sharedHelper] reportScore:gameTime forLeaderboard:@"com.DesertBouncer.leaderboardID"];
    }
    [MGWU setObject:[NSNumber numberWithInt:currentCoinsInGame] forKey:@"coins"];
    [loseScroll setScoreLabel:gameTime];
    changingEyeColor = false;
    currentCoinsInGame = [[MGWU objectForKey:@"coins"] intValue];
    [self.animationManager runAnimationsForSequenceNamed:@"DisplayingButtonsTimeline"];
    bool sound = [[MGWU objectForKey:@"sound"] boolValue];
    if (sound) {
        // access audio object
        OALSimpleAudio *audio = [OALSimpleAudio sharedInstance];
        // play sound effect in a loop
        [audio playBg:@"mainmenumusic.mp3" loop:YES];
    }else{
        // access audio object
        OALSimpleAudio *audio = [OALSimpleAudio sharedInstance];
        // play sound effect in a loop
        [audio stopAllEffects];
        [audio stopEverything];
    }
    timer = 0;
    timerLabel.string = [NSString stringWithFormat:@"%d", (int)timer];
    int randomChanceAD = arc4random_uniform(4);
    bool removedAds = [[MGWU objectForKey:@"RemovedAds"] boolValue];
    
    if([ALInterstitialAd shared].isReadyForDisplay && randomChanceAD == 1 && removedAds == NO && !timing){
        
        [ALInterstitialAd show];
    }
    else{
        if (randomChanceAD != 1) {
            NSLog(@"Random chance did not display");
        }else if(removedAds){
            NSLog(@"Player has removed ads");
        }else{
            NSLog(@"No interstitial ad is currently available.");
        }
    }
}

-(void)openScroll{
    [loseScroll.animationManager runAnimationsForSequenceNamed:@"OpenScrollTimeline"];
    loseScroll.tryAgainButton.enabled = true;
}

-(void)closeScroll{
    [loseScroll runAction:[CCActionScaleTo actionWithDuration:0.25 scale:0]];
    loseScroll.tryAgainButton.enabled = true;
}

-(void)startNewGame:(NSNotification *)notification{
    if (!timing) {
        coinValue = 1;
        int starttimeUpgradedSlots = [[MGWU objectForKey:@"starttimeUpgradedSlots"] intValue];
        timer = 4 + starttimeUpgradedSlots;
        [self performSelector:@selector(spawnBar) withObject:nil afterDelay:1];
        timerLabel.string = [NSString stringWithFormat:@"%d", (int)timer];
        lineSpeedUpCounter = 0;
        [self performSelector:@selector(closeScroll) withObject:nil afterDelay:0.3];
        [loseScroll.animationManager runAnimationsForSequenceNamed:@"CloseScrollTimeline"];
        [self startGame];
        loseScroll.tryAgainButton.enabled = false;
        spawnBarRate = 0.06;
        float scalingTime = 0.3;
        
        ball.color = colorOneDark.color;
        [eyeWhites runAction:[CCActionScaleTo actionWithDuration:scalingTime scaleX:eyeWhites.scaleX scaleY:0.9]];
        [ball runAction:[CCActionTintTo actionWithDuration:scalingTime color:colorOneDark.color]];
        [eyeTint runAction:[CCActionTintTo actionWithDuration:scalingTime color:colorOne.color]];
        [eyeColor runAction:[CCActionTintTo actionWithDuration:scalingTime color:colorOne.color]];
        bool sound = [[MGWU objectForKey:@"sound"] boolValue];
        
        if (sound) {
            // access audio object
            OALSimpleAudio *audio = [OALSimpleAudio sharedInstance];
            // play sound effect in a loop
            [audio playBg:@"gamemusic.mp3" loop:YES];
        }else{
            // access audio object
            OALSimpleAudio *audio = [OALSimpleAudio sharedInstance];
            // play sound effect in a loop
            [audio stopAllEffects];
            [audio stopEverything];
        }
        coinValueUpgradedSlots = [[MGWU objectForKey:@"coinValueUpgradedSlots"] intValue];
        speedUpgradedSlots = [[MGWU objectForKey:@"speedUpgradedSlots"] intValue];
        if (speedUpgradedSlots == 0) {
            BallSpeed = 0.3;
        }else if(speedUpgradedSlots == 1){
            BallSpeed = 0.25;
        }else if(speedUpgradedSlots == 2){
            BallSpeed = 0.2;
        }else if(speedUpgradedSlots == 3){
            BallSpeed = 0.15;
        }else if(speedUpgradedSlots == 4){
            BallSpeed = 0.125;
        }else if(speedUpgradedSlots == 5){
            BallSpeed = 0.1;
        }
    }
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(int)getGameTime{
    gameEndTime = overallTimer;
    float gameOverallTime;
    gameOverallTime = gameEndTime - gameStartTime;
    int time = gameOverallTime;
    return time;
}

-(void)update:(CCTime)delta{
    time = (delta / 1000);
    overallTimer = delta + overallTimer;
    if(timing){
        timer = timer - (time + .02);
        timerLabel.string = [NSString stringWithFormat:@"%d", (int)timer];
        if (changingEyeColor) {
            [self performSelector:@selector(changeEyeColor) withObject:nil afterDelay:0.05];
            changingEyeColor = false;
        }
        if (timer <= 0) {
            [self endGame];
        }
        if (timer >= 15.5) {
            timer = 15.5;
        }
    }
    if (timing) {
        float currentTime = overallTimer;
        float gameOverallTime = currentTime - gameStartTime;
        if (gameOverallTime < 8) {
            speed = 1.2;
            if (coinValueUpgradedSlots < 4) {
                coinValue = 1;
            }else if(coinValueUpgradedSlots == 4){
                coinValue = 5;
            }else if(coinValueUpgradedSlots == 5){
                coinValue = 10;
            }
        }else if (gameOverallTime < 15){
            speed = 1.0;
            spawnBarRate = 0.002;
            [self setNewStage];
        }else if (gameOverallTime < 25){
            speed = 0.7;
            spawnBarRate = 0.001;
            if (coinValueUpgradedSlots >= 1 && coinValueUpgradedSlots < 5) {
                coinValue = 5;
            }else if(coinValueUpgradedSlots == 5){
                coinValue = 10;
            }
            [self setNewStage];
        }else if (gameOverallTime < 40){
            speed = 0.7;
            spawnBarRate = 0.001;
            if (coinValueUpgradedSlots >= 2) {
                coinValue = 10;
            }
            [self setNewStage];
        }else if (gameOverallTime < 60){
            speed = 0.5;
            spawnBarRate = 0.001;
            if (coinValueUpgradedSlots >= 2) {
                coinValue = 10;
            }
            [self setNewStage];
        }
    }
}

-(void)changeEyeColor{
    float scalingTime = 0.3;
    
    changingEyeColor = true;
    
    if (timer < 3) {
        [eyeWhites runAction:[CCActionScaleTo actionWithDuration:scalingTime scaleX:eyeWhites.scaleX scaleY:0.9]];
        [ball runAction:[CCActionTintTo actionWithDuration:scalingTime color:colorOneDark.color]];
        [eyeTint runAction:[CCActionTintTo actionWithDuration:scalingTime color:colorOne.color]];
        [eyeColor runAction:[CCActionTintTo actionWithDuration:scalingTime color:colorOne.color]];
    }else if (timer < 6){
        [eyeWhites runAction:[CCActionScaleTo actionWithDuration:scalingTime scaleX:eyeWhites.scaleX scaleY:0.8]];
        [ball runAction:[CCActionTintTo actionWithDuration:scalingTime color:colorTwoDark.color]];
        [eyeTint runAction:[CCActionTintTo actionWithDuration:scalingTime color:colorTwo.color]];
        [eyeColor runAction:[CCActionTintTo actionWithDuration:scalingTime color:colorTwo.color]];
    }else if (timer < 10){
        [eyeWhites runAction:[CCActionScaleTo actionWithDuration:scalingTime scaleX:eyeWhites.scaleX scaleY:0.6]];
        [ball runAction:[CCActionTintTo actionWithDuration:scalingTime color:colorThreeDark.color]];
        [eyeTint runAction:[CCActionTintTo actionWithDuration:scalingTime color:colorThree.color]];
        [eyeColor runAction:[CCActionTintTo actionWithDuration:scalingTime color:colorThree.color]];
    }else if (timer < 15){
        [eyeWhites runAction:[CCActionScaleTo actionWithDuration:scalingTime scaleX:eyeWhites.scaleX scaleY:0.4]];
        [ball runAction:[CCActionTintTo actionWithDuration:scalingTime color:colorFourDark.color]];
        [eyeTint runAction:[CCActionTintTo actionWithDuration:scalingTime color:colorFour.color]];
        [eyeColor runAction:[CCActionTintTo actionWithDuration:scalingTime color:colorFour.color]];
    }else{
        [eyeWhites runAction:[CCActionScaleTo actionWithDuration:scalingTime scaleX:eyeWhites.scaleX scaleY:0]];
        [ball runAction:[CCActionTintTo actionWithDuration:scalingTime color:colorFiveDark.color]];
        [eyeTint runAction:[CCActionTintTo actionWithDuration:scalingTime color:colorFive.color]];
        [eyeColor runAction:[CCActionTintTo actionWithDuration:scalingTime color:colorFive.color]];
    }
}

-(void)spawnBar{
    if (timing) {
        if (newstage) {
            [self performSelector:@selector(spawnBar) withObject:nil afterDelay:1];
            newstage = false;
        }else{
            float barSpeed = speed;
            
            int randomChanceForCobble = arc4random_uniform(2);
            
            if (((randomChanceForCobble != 1 && spaceLength == 0) || cobblestoneLength > 0) || canSpawnSpace == false) {
                canSpawnSpace = true;
                if (cobblestoneLength == 0) {
                    [self setCobbleStoneLength];
                }
                if (cobblestoneLength > 0){
                    cobblestoneLength --;
                }
                
                cobblestone *currentCobblestone = (cobblestone*)[CCBReader load:@"twocobblestone"];
                
                currentCobblestone.positionInPoints = ccp(self.contentSizeInPoints.width + currentCobblestone.contentSizeInPoints.width, self.contentSizeInPoints.height / 2);
                
                [physicsNode addChild:currentCobblestone];
                spawnCounter++;
                
                [currentCobblestone runAction:[CCActionMoveTo actionWithDuration:barSpeed position:ccp(currentCobblestone.contentSizeInPoints.width * -1, currentCobblestone.positionInPoints.y)]];
                
                [self performSelector:@selector(DeleteNode:) withObject:currentCobblestone afterDelay: barSpeed + 0.5];
            }else{
                if (spaceLength == 0) {
                    [self setSpaceLength];
                }
                if(spaceLength > 0){
                    if (spaceLength == 1 || spaceLength == 2 ||spaceLength == 3) {
                        coin *coinObject = (coin*)[CCBReader load:@"coin"];
                        coinObject.positionInPoints = ccp((self.contentSizeInPoints.width + coinObject.contentSizeInPoints.width)+ coinObject.contentSizeInPoints.width, self.contentSizeInPoints.height / 2);
                        
                        CCEffectHue *coinColor;
                        CCEffectBloom *coinBloom;
                        
                        int randomChanceForGreenCoin = arc4random_uniform(25);
                        
                        if (randomChanceForGreenCoin == 2 && coinValueUpgradedSlots > 2) {
                            
                            coinColor = [CCEffectHue effectWithHue:63];
                            coinObject.scale = 1.5;
                            coinObject.thecoin.name = [NSString stringWithFormat:@"%i",100];
                            coinObject.thecoin.effect = coinColor;
                        }else{
                            if (coinValue == 1) {
                                coinColor = [CCEffectHue effectWithHue:0];
                            }else if(coinValue == 5){
                                coinColor = [CCEffectHue effectWithHue:125];
                            }else if (coinValue == 10){
                                coinColor = [CCEffectHue effectWithHue:-75];
                            }
                            
                            coinObject.thecoin.name = [NSString stringWithFormat:@"%i",coinValue];
                            
                            coinObject.thecoin.effect = coinColor;
                        }
                        
                        [physicsNode addChild:coinObject];
                        
                        [coinObject runAction:[CCActionMoveTo actionWithDuration:barSpeed position:ccp((coinObject.contentSizeInPoints.width * -1) + coinObject.contentSizeInPoints.width, coinObject.positionInPoints.y)]];
                        [self performSelector:@selector(DeleteNode:) withObject:coinObject afterDelay: barSpeed];
                    }
                    canSpawnSpace = false;
                }
                
                spaceLength--;
                spawnCounter++;
                
                [self performSelector:@selector(spawnBar) withObject:nil afterDelay:0.4];
            }
        }
    }
}

-(void)setSpaceLength{
    spaceLength = arc4random_uniform(3);
    spaceLength = spaceLength + 3;
    originalSpaceLength = spaceLength;
}

-(void)setCobbleStoneLength{
    cobblestoneLength = arc4random_uniform(10);
    cobblestoneLength = cobblestoneLength + 3;
}

-(void)DeleteNode:(CCNodeColor *)Line{
    [Line removeFromParent];
}

-(void)touchBegan:(CCTouch *)touch withEvent:(CCTouchEvent *)event{
    if (!tutorial && timing) {
        ballTopPosition = ccp(0.5,(1 - 0.195) - (ball.contentSizeInPoints.height / self.contentSizeInPoints.height));
        
        ballBottomPosition = ccp(0.5,0.195);
        
        if (ballOnBottomPump && canTap) {
            hitLine = false;
            canTap = false;
            [self performSelector:@selector(ableToTap) withObject:nil afterDelay:BallSpeed];
            
            [pumpBottom.animationManager runAnimationsForSequenceNamed:@"ShootingTimeline"];
            
            ballOnBottomPump = false;
            ballOnTopPump = true;
            

            id MoveTo = [CCActionJumpTo actionWithDuration:BallSpeed position:ballTopPosition height:0.14 jumps:1];
            [ball runAction:MoveTo];
            
            bool sound = [[MGWU objectForKey:@"sound"] boolValue];
            
            if (sound) {
                // access audio object
                OALSimpleAudio *audio = [OALSimpleAudio sharedInstance];
                // play sound effect in a loop
                [audio playEffect:@"pipemoving.wav" loop:NO];
            }else{
                // access audio object
                OALSimpleAudio *audio = [OALSimpleAudio sharedInstance];
                // play sound effect in a loop
                [audio stopAllEffects];
                [audio stopEverything];
            }
            
        }else if(ballOnTopPump && canTap){
            hitLine = false;
            canTap = false;
            [self performSelector:@selector(ableToTap) withObject:nil afterDelay:BallSpeed];
            
            [pumpTop.animationManager runAnimationsForSequenceNamed:@"ShootingTimeline"];
            
            ballOnBottomPump = true;
            ballOnTopPump = false;
            
            id MoveTo = [CCActionJumpTo actionWithDuration:BallSpeed position:ballBottomPosition height:0.14 jumps:1];
            [ball runAction:MoveTo];
            
            bool sound = [[MGWU objectForKey:@"sound"] boolValue];
            
            if (sound) {
                // access audio object
                OALSimpleAudio *audio = [OALSimpleAudio sharedInstance];
                // play sound effect in a loop
                [audio playEffect:@"pipemoving.wav" loop:NO];
            }else{
                // access audio object
                OALSimpleAudio *audio = [OALSimpleAudio sharedInstance];
                // play sound effect in a loop
                [audio stopAllEffects];
                [audio stopEverything];
            }
        }
    }
}

-(void)ableToTap{
    canTap = true;
    if (hitLine) {
        int timePenalty;
        int timeUpgradedSlots = [[MGWU objectForKey:@"timeUpgradedSlots"] intValue];
        
        timePenalty = 10 - timeUpgradedSlots; //FOR EACH SLOT IT DECREASES PENALTY BY 1
        
        timer = timer - timePenalty;
        timerLabel.string = [NSString stringWithFormat:@"%d", (int)timer];
        hitLine = false;
        canTap = false;
    }else{
        if (timer + 2 >= 15.5) {
            timer = 15.5;
        }else{
            timer = timer + 2;
        }
        timerLabel.string = [NSString stringWithFormat:@"%d", (int)timer];
    }
}

-(void)setTapToTrue{
    canTap = true;
    movingAfterHit = false;
}

-(BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair thecobblestone:(CCNode *)thecobblestone cobbledetector:(CCNodeColor *)cobbledetector {
    
//    [self performSelector:@selector(spawnBar) withObject:nil afterDelay:spawnBarRate];
    [self spawnBar];
    return NO;
}

-(BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair objectCoin:(CCNode *)objectCoin ballObject:(CCSprite *)ballObject {
    
    objectCoin.physicsBody.collisionType = @"";
    
    int theCoinValue = [objectCoin.name intValue];
    
    for (int i = 0; theCoinValue > i; i++) {
        CCSprite *coin = [CCSprite spriteWithImageNamed:@"coinface.png"];
        coin.zOrder = -5;
        coin.anchorPoint = ccp(1, 0.5);
        [physicsNode addChild:coin];
        coin.position = objectCoin.parent.position;
        coin.scale = objectCoin.scale;
        
        float lowerBoundY = coin.positionInPoints.y;
        float upperBoundY = coinIcon.positionInPoints.y;
        float rndValueY = [self randomFloatBetween:lowerBoundY and:upperBoundY];
        
        float lowerBoundX = coin.positionInPoints.x;
        float upperBoundX = coinIcon.positionInPoints.x;
        float rndValueX = [self randomFloatBetween:lowerBoundX and:upperBoundX];
        
        ccBezierConfig bezier;
        bezier.controlPoint_1 = CGPointMake(rndValueX, rndValueY);
        bezier.controlPoint_2 = bezier.controlPoint_1;
        bezier.endPosition = CGPointMake(coinIcon.positionInPoints.x, coinIcon.positionInPoints.y);
        
        [coin runAction:[CCActionScaleTo actionWithDuration:0.25 scale:coinIcon.scale]];
        
        [coin runAction:[CCActionBezierTo actionWithDuration:0.3 bezier:bezier]];
        
        currentCoinsInGame++;
    }
    
    [objectCoin.parent removeFromParent];
    
    [self coinLabelAnimationUpdate];
    
    return NO;
}

-(void)coinLabelAnimationUpdate{
    NSCharacterSet *doNotWant = [NSCharacterSet characterSetWithCharactersInString:@","];
    NSString *coinLabelStr = [[coinLabel.string componentsSeparatedByCharactersInSet: doNotWant] componentsJoinedByString: @""];
    NSString *coins = coinLabelStr;
    int coinLabelint = [coins intValue];
    
    coinLabelint++;
    coinLabel.string = [NSString stringWithFormat:@"%@",[fmt stringFromNumber:@(coinLabelint)]];
    NSString *newcoinLabelStr = [[coinLabel.string componentsSeparatedByCharactersInSet: doNotWant] componentsJoinedByString: @""];
    NSString *newcoins = newcoinLabelStr;
    coinLabelint = [newcoins intValue];
    
    if (coinLabelint < currentCoinsInGame) {
        [self performSelector:@selector(coinLabelAnimationUpdate) withObject:nil afterDelay:0.01];
    }
}

-(BOOL)ccPhysicsCollisionPreSolve:(CCPhysicsCollisionPair *)pair cobblestoneBody:(CCNode *)cobblestoneBody ballObject:(CCSprite *)ballObject {
    
    if (movingAfterHit == false) {
        hitLine = true;
        
        movingAfterHit = true;
        ballTopPosition = ccp(0.5,(1 - 0.195) - (ball.contentSizeInPoints.height / self.contentSizeInPoints.height));
        
        ballBottomPosition = ccp(0.5,0.195);
        
        canTap = false;
        
        if (ballOnBottomPump) {
            [ball stopAllActions];
            [ball runAction:[CCActionMoveTo actionWithDuration:BallSpeed + 0.4 position:ballTopPosition]];
            ballOnTopPump = true;
            ballOnBottomPump = false;
        }else if (ballOnTopPump){
            [ball stopAllActions];
            [ball runAction:[CCActionMoveTo actionWithDuration:BallSpeed + 0.4 position:ballBottomPosition]];
            ballOnTopPump = false;
            ballOnBottomPump = true;
        }
        
        [self ImagePulseRed:timeIcon];
        
        // load particle effect
        CCParticleSystem *explosion = (CCParticleSystem *)[CCBReader load:@"debri"];
        CCParticleSystem *explosionTwo = (CCParticleSystem *)[CCBReader load:@"debri"];
        // make the particle effect clean itself up, once it is completed
        explosion.autoRemoveOnFinish = TRUE;
        explosionTwo.autoRemoveOnFinish = TRUE;
        // add the particle effect to the same node the seal is on
        [physicsNode addChild:explosion];
        [physicsNode addChild:explosionTwo];
        
        explosionTwo.positionInPoints = ballObject.positionInPoints;
        explosion.positionInPoints = cobblestoneBody.positionInPoints;
        
        [explosionTwo runAction:[CCActionMoveTo actionWithDuration:(speed/2) position:ccp(explosion.contentSizeInPoints.width * -1, explosion.positionInPoints.y)]];
        
        [explosion runAction:[CCActionMoveTo actionWithDuration:(speed/2) position:ccp(explosion.contentSizeInPoints.width * -1, explosion.positionInPoints.y)]];
        
        explosion.zOrder = 1;
        explosionTwo.zOrder = 1;
        
        bool sound = [[MGWU objectForKey:@"sound"] boolValue];;
        
        if (sound) {
            // access audio object
            OALSimpleAudio *audio = [OALSimpleAudio sharedInstance];
            // play sound effect in a loop
            [audio playEffect:@"hitcobbleFX.wav" loop:NO];
        }else{
            // access audio object
            OALSimpleAudio *audio = [OALSimpleAudio sharedInstance];
            // play sound effect in a loop
            [audio stopAllEffects];
            [audio stopEverything];
        }
        
        [self performSelector:@selector(setTapToTrue) withObject:nil afterDelay:BallSpeed + 0.4];
    }
    return NO;
}

-(void)ImagePulseRed:(CCSprite *)Image{
    
    CCColor *originalColor = Image.color;
    id fadeRed = [CCActionTintTo actionWithDuration:0.2 color:[CCColor redColor]];
    id fadeBack = [CCActionTintTo actionWithDuration:0.3 color:originalColor];
    
    [Image runAction:[CCActionSequence actions:fadeRed, fadeBack, nil]];
}

- (float)randomFloatBetween:(float)smallNumber and:(float)bigNumber {
    float diff = bigNumber - smallNumber;
    return (((float) (arc4random() % ((unsigned)RAND_MAX + 1)) / RAND_MAX) * diff) + smallNumber;
}

-(void)OpenStore{
    if (!timing) {
        CCTransition *transition = [CCTransition transitionMoveInWithDirection:CCTransitionDirectionUp duration:0.2];
        CCScene *StoreScene = [CCBReader loadAsScene:@"Store"];
        [[CCDirector sharedDirector] replaceScene:StoreScene withTransition:transition];
        [self unscheduleAllSelectors];
    }
    [self playButtonSound];
}

-(void)setNewStage{
    if (timing) {
        if (speed != oldSpeed) {
            oldSpeed = speed;
            newstage = true;
        }
    }
}

-(void)checkSpawning{
    if (timing) {
        if (spawnCounter == oldSpawnCounter) {
            [self spawnBar];
        }
        oldSpawnCounter = spawnCounter; //IF AFTER 2 SECONDS NOTHING SPAWNS, START SPAWNING AGAIN
        [self performSelector:@selector(checkSpawning) withObject:nil afterDelay:2];
    }
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

-(void)startTutorial{
    tutorialCobblestoneCounter = 4;
    normalHand.visible = true;
    [self shootOut2CobblesStone];
    tutorial = true;
    tapToStartLabel.visible = false;
    tutorialReadyLabel.visible = true;
    tutorialReadyLabel.opacity = 0;
    [self performSelector:@selector(ShowBeginGame) withObject:nil afterDelay: 4];
}

-(void)ShowBeginGame{
    BeginGameButton.visible = true;
    BeginGameButton.enabled = true;
    [tutorialReadyLabel runAction:[CCActionFadeIn actionWithDuration:0.4]];
    [MGWU setObject:[NSNumber numberWithBool:NO] forKey:@"tutorial"];
    tutorial = false;
}

-(void)shootOut2CobblesStone{
    if (!timing) {
        if (tutorialCobblestoneCounter > 0) {
            cobblestone *currentCobblestone = (cobblestone*)[CCBReader load:@"twocobblestone"];
            
            currentCobblestone.positionInPoints = ccp(self.contentSizeInPoints.width + currentCobblestone.contentSizeInPoints.width, self.contentSizeInPoints.height / 2);
            
            currentCobblestone.physicsBody.collisionType = @"";
            
            [physicsNode addChild:currentCobblestone];
            spawnCounter++;
            
            [currentCobblestone runAction:[CCActionMoveTo actionWithDuration:1.5 position:ccp(currentCobblestone.contentSizeInPoints.width * -1, currentCobblestone.positionInPoints.y)]];
            
            [self performSelector:@selector(DeleteNode:) withObject:currentCobblestone afterDelay: 1.5];
            [self performSelector:@selector(shootOut2CobblesStone) withObject:nil afterDelay: 0.06];
            tutorialCobblestoneCounter--;
        }else{
            [self performSelector:@selector(shootOut2CobblesStone) withObject:nil afterDelay: 0.7];
            [self performSelector:@selector(tap) withObject:nil afterDelay: 0.8];
            tutorialCobblestoneCounter = 10;
        }
    }
}

-(void)tap{
    singletapHand.visible = true;
    
    ballTopPosition = ccp(0.5,(1 - 0.195) - (ball.contentSizeInPoints.height / self.contentSizeInPoints.height));
    
    ballBottomPosition = ccp(0.5,0.195);
    
    if (ballOnBottomPump && canTap) {
        hitLine = false;
        canTap = false;
        [self performSelector:@selector(ableToTap) withObject:nil afterDelay:0];
        
        [pumpBottom.animationManager runAnimationsForSequenceNamed:@"ShootingTimeline"];
        
        ballOnBottomPump = false;
        ballOnTopPump = true;
        
        id MoveTo = [CCActionJumpTo actionWithDuration:0.2 position:ballTopPosition height:0.14 jumps:1];
        [ball runAction:MoveTo];
        
        bool sound = [[MGWU objectForKey:@"sound"] boolValue];
        
        if (sound) {
            // access audio object
            OALSimpleAudio *audio = [OALSimpleAudio sharedInstance];
            // play sound effect in a loop
            [audio playEffect:@"pipemoving.wav" loop:NO];
        }else{
            // access audio object
            OALSimpleAudio *audio = [OALSimpleAudio sharedInstance];
            // play sound effect in a loop
            [audio stopAllEffects];
            [audio stopEverything];
        }
        
    }else if(ballOnTopPump && canTap){
        hitLine = false;
        canTap = false;
        [self performSelector:@selector(ableToTap) withObject:nil afterDelay:0];
        
        [pumpTop.animationManager runAnimationsForSequenceNamed:@"ShootingTimeline"];
        
        ballOnBottomPump = true;
        ballOnTopPump = false;
        
        id MoveTo = [CCActionJumpTo actionWithDuration:0.2 position:ballBottomPosition height:0.14 jumps:1];
        [ball runAction:MoveTo];
        
        bool sound = [[MGWU objectForKey:@"sound"] boolValue];
        
        if (sound) {
            // access audio object
            OALSimpleAudio *audio = [OALSimpleAudio sharedInstance];
            // play sound effect in a loop
            [audio playEffect:@"pipemoving.wav" loop:NO];
        }else{
            // access audio object
            OALSimpleAudio *audio = [OALSimpleAudio sharedInstance];
            // play sound effect in a loop
            [audio stopAllEffects];
            [audio stopEverything];
        }
    }
    [self performSelector:@selector(removeTap) withObject:nil afterDelay:0.1];
}

-(void)removeTap{
    singletapHand.visible = false;
}

#pragma mark AppLovin delegate implementation (Optional)

-(void) adService:(ALAdService *)adService didLoadAd:(ALAd *)ad
{
    NSLog(@"Interstitial loaded.");
}

-(void) adService:(ALAdService *)adService didFailToLoadAdWithError:(int)code
{
    NSLog(@"Interstitial failed to load.");
}

-(void) ad:(ALAd *)ad wasDisplayedIn:(UIView *)view
{
    NSLog(@"Interstitial displayed.");
}

-(void) ad:(ALAd *)ad wasClickedIn:(UIView *)view
{
    NSLog(@"Interstitial clicked.");
}

-(void) ad:(ALAd *)ad wasHiddenIn:(UIView *)view
{
    NSLog(@"Interstitial hidden.");
}

@end
