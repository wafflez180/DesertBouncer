//
//  cobblestone.m
//  ballpumpGame
//
//  Created by Arthur Araujo on 1/14/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "cobblestone.h"

@implementation cobblestone{
    CCSprite *mossyLeafTop;
    CCSprite *mossyLeafBottom;
    CCSprite *stoneOne;
    CCSprite *stoneTwo;
    CCSprite *stoneThree;
    CCSprite *stoneFour;
    CCSprite *stoneFive;
    CCSprite *stoneSix;
    
    CCColor *colorOne;
    CCColor *colorTwo;
    CCColor *colorThree;
    CCColor *colorFour;
    
    CCNodeColor *stoneContainer;
    
    CCNode *collisionDetector;
}

-(void)didLoadFromCCB{
    int randomMossyLeaf = arc4random_uniform(6);
    
    colorOne = stoneOne.color;
    colorTwo = stoneTwo.color;
    colorThree = stoneThree.color;
    colorFour = stoneFour.color;

    mossyLeafTop.visible = false;
    mossyLeafBottom.visible = false;
    
    if (randomMossyLeaf == 1) {
        mossyLeafTop.visible = true;
    }
    if (randomMossyLeaf == 2) {
        mossyLeafBottom.visible = true;
    }
    
    for (int i = 0; stoneContainer.children.count > i; i++) {
        int randomColor = arc4random_uniform(4);
        if (randomColor == 1) {
            [stoneContainer.children[i] setColorRGBA:colorOne];
        }else if(randomColor == 2) {
            [stoneContainer.children[i] setColorRGBA:colorTwo];
        }else if(randomColor == 3) {
            [stoneContainer.children[i] setColorRGBA:colorThree];
        }else if(randomColor == 4) {
            [stoneContainer.children[i] setColorRGBA:colorFour];
        }
    }
}

@end
