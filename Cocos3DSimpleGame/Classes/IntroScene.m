//
//  IntroScene.m
//  Cocos3DSimpleGame
//
//  Created by Chandrashekar on 05/03/14.
//  Copyright com.chandrashekars 2014. All rights reserved.
//
// -----------------------------------------------------------------------

// Import the interfaces
#import "IntroScene.h"
#import "HelloWorldScene.h"
#import "NewtonScene.h"
#import "CrazyNinjaScene.h"

// -----------------------------------------------------------------------
#pragma mark - IntroScene
// -----------------------------------------------------------------------

@implementation IntroScene

// -----------------------------------------------------------------------
#pragma mark - Create & Destroy
// -----------------------------------------------------------------------

+ (IntroScene *)scene
{
	return [[self alloc] init];
}

// -----------------------------------------------------------------------

- (id)init
{
    // Apple recommend assigning self with supers return value
    self = [super init];
    if (!self) return(nil);
    
    // Create a colored background (Dark Grey)
    CCNodeColor *background = [CCNodeColor nodeWithColor:[CCColor colorWithRed:0.2f green:0.2f blue:0.2f alpha:1.0f]];
    [self addChild:background];
    
    // Hello world
    CCLabelTTF *label = [CCLabelTTF labelWithString:@"Hello World" fontName:@"Chalkduster" fontSize:36.0f];
    label.positionType = CCPositionTypeNormalized;
    label.color = [CCColor redColor];
    label.position = ccp(0.5f, 0.7f); // Middle of screen
    [self addChild:label];
    
    // Spinning scene button
    CCButton *spinningButton = [CCButton buttonWithTitle:@"[ Simple Sprite ]" fontName:@"Verdana-Bold" fontSize:18.0f];
    spinningButton.positionType = CCPositionTypeNormalized;
    spinningButton.position = ccp(0.5f, 0.5f);
    [spinningButton setTarget:self selector:@selector(onSpinningClicked:)];
    [self addChild:spinningButton];

    // Next scene button
    CCButton *newtonButton = [CCButton buttonWithTitle:@"[ Newton Physics ]" fontName:@"Verdana-Bold" fontSize:18.0f];
    newtonButton.positionType = CCPositionTypeNormalized;
    newtonButton.position = ccp(0.5f, 0.35f);
    [newtonButton setTarget:self selector:@selector(onNewtonClicked:)];
    [self addChild:newtonButton];
    
    //CrazyNinja button
    CCButton *crazyNinjaButton = [CCButton buttonWithTitle:@"[ Crazy Ninjas ]" fontName:@"Verdana-Bold" fontSize:18.0f];
    crazyNinjaButton.positionType = CCPositionTypeNormalized;
	crazyNinjaButton.position = ccp(0.5f, 0.25f);
    [crazyNinjaButton setTarget:self selector:@selector(onCrazyNinjaClicked:)];
    [self addChild:crazyNinjaButton];
    // done
	return self;
}

// -----------------------------------------------------------------------
#pragma mark - Button Callbacks
// -----------------------------------------------------------------------

- (void)onSpinningClicked:(id)sender
{
    // start spinning scene with transition
    [[CCDirector sharedDirector] replaceScene:[HelloWorldScene scene]
                               withTransition:[CCTransition transitionPushWithDirection:CCTransitionDirectionLeft duration:1.0f]];
}

- (void)onNewtonClicked:(id)sender
{
    // start newton scene with transition
    // the current scene is pushed, and thus needs popping to be brought back. This is done in the newton scene, when pressing back (upper left corner)
    [[CCDirector sharedDirector] pushScene:[NewtonScene scene]
                            withTransition:[CCTransition transitionPushWithDirection:CCTransitionDirectionLeft duration:1.0f]];
}

- (void) onCrazyNinjaClicked:(id)sender
{
    [[CCDirector sharedDirector] pushScene:[CrazyNinjaScene scene]
                            withTransition:[CCTransition transitionPushWithDirection:CCTransitionDirectionLeft duration:1.0f]];
}

// -----------------------------------------------------------------------
@end
