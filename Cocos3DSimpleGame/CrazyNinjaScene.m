//
//  CrazyNinjaScene.m
//  Cocos3DSimpleGame
//
//  Created by Chandrashekar on 06/03/14.
//  Copyright 2014 com.chandrashekars. All rights reserved.
//

#import "CrazyNinjaScene.h"
#import "IntroScene.h"
#import "OALSimpleAudio.h"

@implementation CrazyNinjaScene
{
    CCSprite *_player;
    NSMutableArray * _monsters;
    NSMutableArray * _projectiles;
}

#pragma mark - Create and Destroy

- (id) init
{
    self = [super init];
    if(!self) return nil;
    
    // Enable touch handling on scene node
    self.userInteractionEnabled = YES;
    
    _monsters = [[NSMutableArray alloc] init];
    _projectiles = [[NSMutableArray alloc] init];
    
    [[OALSimpleAudio sharedInstance] playBg:@"background-music-aac.caf"];
    
    CCNodeColor *backgroundColor = [CCNodeColor nodeWithColor:[CCColor whiteColor]];
    [self addChild:backgroundColor];
    
    _player = [CCSprite spriteWithImageNamed:@"player.png"];
    _player.position = ccp(_player.contentSize.width/2, self.contentSize.height/2);
    [self addChild:_player];

    CCButton *backButton = [CCButton buttonWithTitle:@"[Back]" fontName:@"Verdana Font" fontSize:18.0f];
    backButton.color = [CCColor blackColor];
    backButton.positionType = CCPositionTypeNormalized;
    backButton.position = ccp(0.85f, 0.95f);
    [backButton setTarget:self selector:@selector(backButtonTouched:)];
    [self addChild:backButton];
    
    [self schedule:@selector(gameLogic:) interval:1.0];
    [self schedule:@selector(update:) interval:0.1];
    return self;
}

+ (CrazyNinjaScene *) scene
{
    return [[self alloc] init];
}

#pragma mark - CCNode required overrides

- (void) onEnter
{
    [super onEnter];
}


- (void) onExit
{
    [super onExit];
}

#pragma mark - touch handler

- (void) touchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
    /*CCActionMoveTo *moveToAction = [[CCActionMoveTo alloc] initWithDuration:1.5f position:[touch locationInNode:self]];
    [_player runAction:moveToAction];*/
}

#pragma mark - button touch handler

- (void) backButtonTouched:(id) sender
{
    [[CCDirector sharedDirector] replaceScene:[IntroScene scene]
                               withTransition:[CCTransition transitionPushWithDirection:CCTransitionDirectionRight duration:1.0f]];
}

-(void) gameLogic:(CCTime)dt {
    [self addMonster];
}

- (void) addMonster
{
    CCSprite *monster = [CCSprite spriteWithImageNamed:@"monster.png"];
    
    // Determine where to spawn the monster along the Y axis
    CGSize winSize = self.contentSize;
    int minY = monster.contentSize.height / 2;
    int maxY = winSize.height - monster.contentSize.height/2;
    int rangeY = maxY - minY;
    int actualY = (arc4random() % rangeY) + minY;
 
    // Create the monster slightly off-screen along the right edge,
    // and along a random position along the Y axis as calculated above
    monster.position = ccp(winSize.width + monster.contentSize.width/2, actualY);
    [self addChild:monster];
    
    // Determine speed of the monster
    int minDuration = 2.0;
    int maxDuration = 4.0;
    int rangeDuration = maxDuration - minDuration;
    int actualDuration = (arc4random() % rangeDuration) + minDuration;
    
    CCActionMoveTo *actionMove = [CCActionMoveTo actionWithDuration:actualDuration position:ccp(-monster.contentSize.width/2, actualY)];
    CCActionCallBlock *callbackAction = [CCActionCallBlock actionWithBlock:^(void)
    {
        [monster removeFromParentAndCleanup:YES];
        [_monsters removeObject:monster];
    }];
    
    [_monsters addObject:monster];
    
    CCActionSequence *sequence = [CCActionSequence actions:actionMove, callbackAction, nil];
    [monster runAction:sequence];
}

- (void) touchEnded:(UITouch *)touch withEvent:(UIEvent *)event {
    
     [[OALSimpleAudio sharedInstance] playEffect:@"pew-pew-lei.caf"];
    
    // Choose one of the touches to work with
    CGPoint location = [touch locationInNode:self];
    
    // Set up initial location of projectile
    CGSize winSize = self.contentSize;
    CCSprite *projectile = [CCSprite spriteWithImageNamed:@"projectile.png"];
    projectile.position = ccp(20, winSize.height/2);
    
    // Determine offset of location to projectile
    CGPoint offset = ccpSub(location, projectile.position);
    
    // Bail out if you are shooting down or backwards
    if (offset.x <= 0) return;
    
    // Ok to add now - we've double checked position
    [self addChild:projectile];
    
    int realX = winSize.width + (projectile.contentSize.width/2);
    float ratio = (float) offset.y / (float) offset.x;
    int realY = (realX * ratio) + projectile.position.y;
    CGPoint realDest = ccp(realX, realY);
    
    // Determine the length of how far you're shooting
    int offRealX = realX - projectile.position.x;
    int offRealY = realY - projectile.position.y;
    float length = sqrtf((offRealX*offRealX)+(offRealY*offRealY));
    float velocity = 480/1; // 480pixels/1sec
    float realMoveDuration = length/velocity;
    
    [_projectiles addObject:projectile];
    
    // Move projectile to actual endpoint
    CCActionSequence *sequence = [CCActionSequence actions:[CCActionMoveTo actionWithDuration:realMoveDuration position:realDest],[CCActionCallBlock actionWithBlock:^(void) {
        [projectile removeFromParentAndCleanup:YES];
        [_projectiles removeObject:projectile];
    }], nil];
    
    [projectile runAction:sequence];
}

- (void)update:(CCTime)dt {
    
    NSMutableArray *projectilesToDelete = [[NSMutableArray alloc] init];
    for (CCSprite *projectile in _projectiles) {
        
        NSMutableArray *monstersToDelete = [[NSMutableArray alloc] init];
        for (CCSprite *monster in _monsters) {
            
            if (CGRectIntersectsRect(projectile.boundingBox, monster.boundingBox)) {
                [monstersToDelete addObject:monster];
            }
        }
        
        for (CCSprite *monster in monstersToDelete) {
            [_monsters removeObject:monster];
            [self removeChild:monster cleanup:YES];
        }
        
        if (monstersToDelete.count > 0) {
            [projectilesToDelete addObject:projectile];
        }
    }
    
    for (CCSprite *projectile in projectilesToDelete) {
        [_projectiles removeObject:projectile];
        [self removeChild:projectile cleanup:YES];
    }
}

@end
