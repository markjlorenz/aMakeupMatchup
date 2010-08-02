//
//  DBDPlayingCardView.h
//  UniversalCardUITest
//
//  Created by Mark Lorenz on 11/15/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "DBDUIViewTools.h"
#import "DBDMovableView.h"

#define kDBDCardMovementSensivity (3.0) //in px.
#define kDBDCardMomentumDragCoef (0.95) //lower coeff means more drag
#define kDBDCardMomentumTime (0.05)
#define kMultiTapDelay (0.2)


typedef enum DBDPlayingCardViewVisibleSide {
	DBDPlayingCardViewVisibleNone,
	DBDPlayingCardViewVisibleSideFlip,
	DBDPlayingCardViewVisibleSideObverse,
	DBDPlayingCardViewVisibleSideReverse
} DBDPlayingCardViewVisibleSide;

@class DBDPlayingCardView;
@protocol DBDPlayingCardViewObserver
-(void) momentumAnimationDidStopForCard:(DBDPlayingCardView*)card;
@end

@interface DBDPlayingCardView : DBDMovableView {
	UIImage *obverseImage;
	UIImageView *obverseImageView;
	UIImageView *reverseImageView;
	
	DBDPlayingCardViewVisibleSide visibleSide;
		
	NSArray *previousTouchEvent; //used to satisfy the isEqual: requiremen to cancelPreviousPerformRequestsWithTarget:selector:object:
	BOOL singleTap;
	BOOL _waitingForNextTap;  //internal only!
	CGPoint momentumStopPoint;
	
	NSMutableArray *debugRayTraceViews; //debug only
}

@property (nonatomic, retain)	UIImage *obverseImage;
@property (nonatomic, retain)	UIImageView *obverseImageView;
@property (nonatomic, retain)	UIImageView *reverseImageView;
@property (nonatomic, assign) DBDPlayingCardViewVisibleSide visibleSide;
@property (nonatomic, assign) 	CGPoint momentumStopPoint;

-(void) performMoveEndedAnimationFromEndPoint:(CGPoint)endPoint withPreviousPoint:(CGPoint)previousPoint;
-(void) turnCardToSide:(DBDPlayingCardViewVisibleSide)side;
	
+(DBDPlayingCardView*) alloc;
@end


@interface DBDPlayingCardView (DBDPlayingCardView_Hidden)
-(void)cardFlip;
-(void)turnCardToSideForTouch:(DBDPlayingCardViewVisibleSide)side;
-(CGMutablePathRef)newMomentumPathFrom:(CGPoint)currentPoint previousPoint:(CGPoint)previousPoint resultingPointCount:(NSUInteger*)count;
@end