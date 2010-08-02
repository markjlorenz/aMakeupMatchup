//
//  DBDTiledView.h
//  UniversalCardUITest
//
//  Created by Mark Lorenz on 12/8/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//  v1.1 see bottom for rev history

#import <UIKit/UIKit.h>
#import "DBDUIViewTools.h"
#import "MLPrimitives.h"

#define kDBDTiledViewBumper (5.0)
#define kDBDTiledViewEditModeScrollSpeed (1.0)
#define kDBDTiledViewSildeInOutAnimationTime (0.5)

typedef enum DBDTiledViewState {
	DBDTiledViewStateNone,
	DBDTiledViewStateScroll,
	DBDTiledViewStateEdit,
	DBDTiledViewStateToggle
} DBDTiledViewState;

@protocol DBDTiledViewDataSource 
	
@end

@interface DBDTiledView : UIScrollView <UIScrollViewDelegate> {
	NSMutableSet *synchronizedSlaves; //going to broadcast my changes to these guys
	NSMutableDictionary *synchronizedMasters; //a dictionary of synchPointerImages keyed by view
	NSMutableDictionary *mastersInitialContentOffset; //a dictionary of in content offset, started when touchesbegan.
	NSMutableDictionary *syncPointerFixatives;// a dictionary of pointers to views, that also has the center point for those views before the move.  this dictionary is not intended to be refreence, just accessed and interated
	NSMutableArray *tiles; //the array of tiles, in display order
	id dataSource;
	CGFloat tileElementWidth;
	CGSize tileElementSize;
	CGSize displaySize; //the size of the view when It's intended to be displayed
	NSMutableSet *observers;
	
	//extended for background image
	UIImage *tileBackgroundImage;
	NSMutableArray *backgroundViews;
	
	//extended for background image
	UIImage *tileForegroundImage;
	NSMutableArray *foregroundViews;
}
@property (nonatomic, assign) id dataSource;
@property (nonatomic, assign) CGFloat tileElementWidth;
@property (nonatomic, retain) NSMutableSet *synchronizedSlaves;
@property (nonatomic, retain) NSMutableSet *observers;
@property (nonatomic, readonly) NSMutableArray *tiles;
@property (nonatomic, retain) UIImage *tileBackgroundImage;
@property (nonatomic, retain) UIImage *tileForegroundImage;

-(void) insertTileAtEnd:(UIView*)tileView;
-(void) insertTile:(UIView*)tileView AtIndex:(NSUInteger)index;
-(void) removeTileAtIndex:(NSUInteger)index;  //due to animation this method may actually remove the tile from the destination view!
-(void) removeTileAtIndexHidden:(NSUInteger)index;
-(void) removeTile:(UIView*)tile animated:(BOOL)animated;
-(void) removeAllTiles;
-(void) removeAllTilesHidden;
-(void) addTilesFromArray:(NSArray*)array;

#pragma mark --Background and Foreground Methods--
-(void) applyBackgroundViewAtIndex:(NSInteger)index;
-(void) removeBackgroundViewAtIndex:(NSInteger)index;
-(void) applyForegroundViewAtIndex:(NSInteger)index;
-(void) removeForegroundViewAtIndex:(NSInteger)index;

#pragma mark -- Sync Slave Methods--
-(void) initializeSyncPoint:(CGPoint)point forSynchronziedView:(DBDTiledView*)view;////the initializer for the synchronization service.  Automatically adds self to the slave views of the view
-(void) setPointerImage:(UIImage*)image forSynchronizedMasterView:(DBDTiledView*)view; 
-(void) setSyncPoint:(CGPoint)point forSynchronziedView:(DBDTiledView*)view; //syncPoint is the points location in the superview
-(void) removePointerImageForSynchronizedView:(DBDTiledView*)view;
-(UIImageView*)syncPointerForMaster:(DBDTiledView*)master;
#pragma mark -- Sync Master Methods--
- (void)scrollViewDidScroll:(UIScrollView *)scrollView;
	
#pragma mark -- Animation Methods --
-(void) slideInVerticallyAnimationed;
-(void) slideOutVerticallyAnimated;
@end

@protocol DBDTiledViewObserver
-(void)tileView:(DBDTiledView*)view addedTile:(UIView*)tile atIndex:(NSUInteger)index;
-(void)tileView:(DBDTiledView*)view removedTile:(UIView*)tile atIndex:(NSUInteger)index;
@end


@interface DBDTiledView (DBDTiledView_hidden)
-(void) changeToState:(DBDTiledViewState)state;
-(void) viewAppearAnimation:(UIView*)view;
-(void) viewDisappearAnimation:(UIView*)view;
-(void) bumpTilesAfterIndex:(NSUInteger)index distance:(CGFloat)distance;
	
-(void) removeViewAfterTimer:(NSTimer*)timer;
-(void) refreshContentSize;

@end

/* -- Revision History --

v1.0 new file
v1.1 forcing of tileElementSize removed.

*/