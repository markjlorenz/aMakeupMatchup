//
//  DBDTiledView.h
//  UniversalCardUITest
//
//  Created by Mark Lorenz on 12/8/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//  does not accept new tiles if alpha < 0.1
// does not accept tiles if it's not a registered tile observer

#import <UIKit/UIKit.h>
#import "DBDTiledView.h"
#import <QuartzCore/QuartzCore.h>
#import "DBDMovableView.h"

#import "AVAudioPlayer_DBDAdditions.h"

@interface DBDInteractiveTileView : DBDTiledView <DBDMovableViewObserver>{
	UIView *reordingView;
	UIImageView *cursorView;
	NSMutableSet *acceptRemovedTileViews;
	NSInteger lastRemovedTileIndex;
	
	CABasicAnimation *wiggleAnimation;
}
@property (nonatomic, retain) UIImageView *cursorView;
@property (nonatomic, retain) NSMutableSet *acceptRemovedTileViews;

-(void) removeTileAtIndex:(NSUInteger)index newSuperView:(UIView*)newSuperView newCenter:(CGPoint)newCenter;
-(void) transferTile:(DBDMovableView*)tile hitPoint:(CGPoint)point;

@end

@protocol DBDInteractiveTileViewObserver
-(void) tileView:(DBDInteractiveTileView*)view transferedTile:(DBDMovableView*)tile;
@end

@interface DBDInteractiveTileView (DBDInteractiveTileView_hidden)
-(void) setReorderingView:(UIView*)view; // this method retains the view.  This is also used as the trigger to start view reordering mode;
-(void) defineWiggleAnimation;
	
#pragma mark --Methods From Delegates--

-(void) setupCursorView;
@end