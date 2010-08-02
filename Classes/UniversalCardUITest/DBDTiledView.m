//
//  DBDTiledView.m
//  UniversalCardUITest
//
//  Created by Mark Lorenz on 12/8/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "DBDTiledView.h"


@implementation DBDTiledView
@synthesize dataSource;
@synthesize tileElementWidth;
@synthesize synchronizedSlaves;
@synthesize observers;
@synthesize tiles;
@synthesize tileBackgroundImage;
@synthesize tileForegroundImage;

- (void)dealloc {
	[synchronizedSlaves release];
	[synchronizedMasters release];
	[syncPointerFixatives release];
	[mastersInitialContentOffset release];
	[tiles release];
	[observers release];
	[tileBackgroundImage release];
	[backgroundViews release];
	[tileForegroundImage release];
	[foregroundViews release];
	
    [super dealloc];
}

- (void)awakeFromNib{
	[super awakeFromNib];
	synchronizedMasters = [[NSMutableDictionary alloc] init];
	mastersInitialContentOffset = [[NSMutableDictionary alloc] init];
	syncPointerFixatives = [[NSMutableDictionary alloc] init];
	synchronizedSlaves = [[NSMutableSet alloc] init];
	observers = [[NSMutableSet alloc] init];
	tiles = [[NSMutableArray alloc] init];
	self.tileElementWidth = 0.0; //default value;
	self.delegate = self;
	backgroundViews = nil;
	tileBackgroundImage = nil;
	foregroundViews = nil;
	tileForegroundImage = nil;
//	self.contentSize = tileElementSize;
	[self refreshContentSize];
	self.userInteractionEnabled = YES;
	
}

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
		synchronizedMasters = [[NSMutableDictionary alloc] init];
		mastersInitialContentOffset = [[NSMutableDictionary alloc] init];
		syncPointerFixatives = [[NSMutableDictionary alloc] init];
		synchronizedSlaves = [[NSMutableSet alloc] init];
		observers = [[NSMutableSet alloc] init];
		tiles = [[NSMutableArray alloc] init];
		self.tileElementWidth = 0.0; //default value;
		self.contentSize = tileElementSize;
		self.delegate = self;
		backgroundViews = nil;	
		tileBackgroundImage = nil;
		foregroundViews = nil;
		tileForegroundImage = nil;
		[self refreshContentSize];
		self.userInteractionEnabled = YES;
	}
    return self;
}

-(void) setTileElementWidth:(CGFloat)width{
	
	tileElementSize = CGSizeMake(width, self.frame.size.height- kDBDTiledViewBumper) ;
	tileElementWidth = width;
}

-(void) insertTileAtEnd:(UIView*)tileView{
	if (tileElementWidth == 0){
		[self setTileElementWidth:tileView.bounds.size.width];
	}
//	CGRect lastTileRect = [[tiles lastObject] frame];
	CGFloat tileYCenter = self.bounds.size.height/2.0; //[self convertPoint:self.center fromView:self.superview].y;
//	CGRect newTileRect = CGRectMake(lastTileRect.origin.x + lastTileRect.size.width + kDBDTiledViewBumper, kDBDTiledViewBumper, tileElementSize.width, tileElementSize.height - kDBDTiledViewBumper);  //depredcated, because setting the frame causes rotation trouble
//	tileView.frame = newTileRect;
	UIView *previousView = [tiles lastObject];
//	tileView.bounds = CGRectMake(0.0, 0.0, tileElementSize.width, tileElementSize.height - kDBDTiledViewBumper);
	tileView.bounds = CGRectMake(0.0, 0.0, tileElementSize.width, tileView.bounds.size.height);
	
	tileView.center = CGPointMake(previousView.center.x + previousView.bounds.size.width/2 + tileView.bounds.size.width/2 + kDBDTiledViewBumper, tileYCenter);
	
	[tiles addObject:tileView];
	[self applyBackgroundViewAtIndex:[tiles indexOfObject:tileView]];
	[self addSubview:tileView];
	[self applyForegroundViewAtIndex:[tiles indexOfObject:tileView]];
	[self viewAppearAnimation:tileView];
	[self refreshContentSize];
	
	//!!! This is total insanity, but having this log here keeps the tiles on the left endge where they belong!...uncomment it, and load your view twice.  On the second load you will see each view shifted on space to the right.
	[MLPrimitives NSLogCGPoint:tileView.frame.origin withMessage:nil];
	
	for(id observer in observers)
		if([observer respondsToSelector:@selector(tileView:addedTile:atIndex:)])
			[observer tileView:self addedTile:tileView atIndex:tiles.count];
}

-(void) insertTile:(UIView*)tileView AtIndex:(NSUInteger)index{
	if (index >= tiles.count){//a little robustness
		[self insertTileAtEnd:tileView];
		return; 
	}
	if (tileView){ // inserting nil into the array will cause a crash
	//	CGRect priorTileFrame = [[tiles objectAtIndex:index-1] frame];
		CGFloat tileYCenter = self.bounds.size.height/2.0;
	//	CGRect newTileRect = CGRectMake(priorTileFrame.origin.x + priorTileFrame.size.width + kDBDTiledViewBumper, kDBDTiledViewBumper, tileElementSize.width, tileElementSize.height - kDBDTiledViewBumper);  //depredcated, because setting the frame causes rotation trouble
	//	tileView.frame = newTileRect;
		UIView *previousView;
		if (index)
			previousView = [tiles objectAtIndex:index-1];
		else
			previousView = nil;

	//	tileView.bounds = CGRectMake(0.0, 0.0, tileElementSize.width, tileElementSize.height - kDBDTiledViewBumper);
		tileView.bounds = CGRectMake(0.0, 0.0, tileElementSize.width, tileView.bounds.size.height);
		tileView.center = CGPointMake(previousView.center.x + previousView.bounds.size.width/2 + tileView.bounds.size.width/2 + kDBDTiledViewBumper, tileYCenter);
		[tiles insertObject:tileView atIndex:index];
		[self applyBackgroundViewAtIndex:[tiles indexOfObject:tileView]];
		[self addSubview:tileView];
		[self applyForegroundViewAtIndex:[tiles indexOfObject:tileView]];
		[self bumpTilesAfterIndex:index distance:(tileElementWidth + kDBDTiledViewBumper)];
		[self viewAppearAnimation:tileView];
		[self refreshContentSize];
		
		for(id observer in observers)
			if([observer respondsToSelector:@selector(tileView:addedTile:atIndex:)])
				[observer tileView:self addedTile:tileView atIndex:index];
	}
}

-(void) removeTileAtIndex:(NSUInteger)index{
	UIView *tileToRemove = [tiles objectAtIndex:index];
	
	for (id synchronizedSlave in synchronizedSlaves){ //need to do some clean up if the slave is looking at us
		CGPoint syncPointerCenterPointInSelf =  [self convertPoint:[synchronizedSlave syncPointerForMaster:self].center fromView:[synchronizedSlave syncPointerForMaster:self].superview] ;
		CGPoint tileToRemoveCenterPointInSelf = tileToRemove.center;
		if(syncPointerCenterPointInSelf.x == tileToRemoveCenterPointInSelf.x){
			[synchronizedSlave slideInVerticallyAnimationed];
		}
	}
			
	[self bumpTilesAfterIndex:index distance:-(tileElementWidth + kDBDTiledViewBumper)];
	[self viewDisappearAnimation:tileToRemove];
	
	[self removeBackgroundViewAtIndex:index];
	[self removeForegroundViewAtIndex:index];
	[tiles removeObjectAtIndex:index];
			//[tileToRemove removeFromSuperview]; handeled in the animation
	
	for(id observer in observers)
		if([observer respondsToSelector:@selector(tileView:removedTile:atIndex:)])
			[observer tileView:self removedTile:tileToRemove atIndex:index];
}

-(void) removeTile:(UIView*)tile animated:(BOOL)animated{
	if(animated)
		[self removeTileAtIndex:[tiles indexOfObject:tile]];
	else 
		[self removeTileAtIndexHidden:[tiles indexOfObject:tile]];
}


-(void) removeTileAtIndexHidden:(NSUInteger)index{
	UIView *tileToRemove = [tiles objectAtIndex:index];
	[self removeBackgroundViewAtIndex:index];
	[self removeForegroundViewAtIndex:index];
	[tiles removeObjectAtIndex:index];
	[tileToRemove removeFromSuperview];
	[self refreshContentSize];
	
	for(id observer in observers)
		if([observer respondsToSelector:@selector(tileView:removedTile:atIndex:)])
			[observer tileView:self removedTile:tileToRemove atIndex:index];
}

-(void) removeAllTiles{
	if(tiles.count){ // protect yourself in case they ask you to remove what you don't have.
		for (int i = tiles.count - 1 ; i >= 0; i--){
			int index = i;
			
			UIView *tileToRemove = [tiles objectAtIndex:index];
			
			[self bumpTilesAfterIndex:index distance:-(tileElementWidth + kDBDTiledViewBumper)];
			[self viewDisappearAnimation:tileToRemove];
			
			[self removeBackgroundViewAtIndex:index];
			[self removeForegroundViewAtIndex:index];
			[tiles removeObjectAtIndex:index];
			[tileToRemove removeFromSuperview];
		}
		[self refreshContentSize];
	}
}

-(void) removeAllTilesHidden{
	if(tiles.count){ // protect yourself in case they ask you to remove what you don't have.
		for (int i = tiles.count - 1 ; i >= 0; i--){
			int index = i;
			
			UIView *tileToRemove = [tiles objectAtIndex:index];
			
			[self removeBackgroundViewAtIndex:index];
			[self removeForegroundViewAtIndex:index];
			[tiles removeObjectAtIndex:index];
			[tileToRemove removeFromSuperview];
		}
		[self refreshContentSize];
	}
}

-(void) addTilesFromArray:(NSArray*)array{
	UIView *tileView;
	for (int i = 0; i < array.count; i++){
		tileView = [array objectAtIndex:i];
		CGRect lastTileRect = [[tiles lastObject] frame];
		CGRect newTileRect = CGRectMake(lastTileRect.origin.x + lastTileRect.size.width + kDBDTiledViewBumper, kDBDTiledViewBumper, tileElementSize.width, tileElementSize.height - kDBDTiledViewBumper);
		tileView.frame = newTileRect;
		[tiles addObject:tileView];
		
		[self applyBackgroundViewAtIndex:[tiles indexOfObject:tileView]];
		[self addSubview:tileView];
		[self applyForegroundViewAtIndex:[tiles indexOfObject:tileView]];
		[self viewAppearAnimation:tileView];
	}
	[self refreshContentSize];
}

#pragma mark --Background and Foreground Methods--
-(void) applyBackgroundViewAtIndex:(NSInteger)index{
	if (!tileBackgroundImage){
		self.tileBackgroundImage = [UIImage imageNamed:@"nil.png"]; //yea cache it  This is important to be able to reorder the views if not every view has a background
															// nil.png is a 1x1 100% transparent image
	}
		
	if (!backgroundViews)
		backgroundViews = [[NSMutableArray alloc] init];
	
	UIView *tileView = [tiles objectAtIndex:index];
	UIImageView *backgroundView = [[UIImageView alloc] initWithImage:tileBackgroundImage];
	backgroundView.center = tileView.center;
	
	[backgroundViews insertObject:backgroundView atIndex:index];
	[self addSubview:backgroundView];
	[backgroundView release];
	
}

-(void) removeBackgroundViewAtIndex:(NSInteger)index{
	if (index < backgroundViews.count){
		[[backgroundViews objectAtIndex:index] removeFromSuperview];
		[backgroundViews removeObjectAtIndex:index];
	}
}

-(void) applyForegroundViewAtIndex:(NSInteger)index{
	if (!tileBackgroundImage){
		self.tileBackgroundImage = [UIImage imageNamed:@"nil.png"]; //yea cache it  This is important to be able to reorder the views if not every view has a background
		// nil.png is a 1x1 100% transparent image
	}
	
	if (!foregroundViews)
		foregroundViews = [[NSMutableArray alloc] init];
	
	UIView *tileView = [tiles objectAtIndex:index];
	UIImageView *foregroundView = [[UIImageView alloc] initWithImage:tileForegroundImage];
	foregroundView.center = tileView.center;
	
	[foregroundViews insertObject:foregroundView atIndex:index];
	
	[self addSubview:foregroundView];
	[foregroundView release];

	
	//based on the operations some of the views may be shifted to the back. so lets bring them all forward
	for (UIView *view in foregroundViews)
		[self bringSubviewToFront:view];
}

-(void) removeForegroundViewAtIndex:(NSInteger)index{
	if (index < foregroundViews.count){
		[[foregroundViews objectAtIndex:index] removeFromSuperview];
		[foregroundViews removeObjectAtIndex:index];
	}
}


#pragma mark -- Sync Slave Methods--
-(void) initializeSyncPoint:(CGPoint)point forSynchronziedView:(DBDTiledView*)view{
	CGPoint contentOffsetPoint = view.contentOffset;
	NSValue *offset = [NSValue valueWithCGPoint:contentOffsetPoint];
	
	for (NSValue *ptrValue in [mastersInitialContentOffset allKeys]) {//need to check to make sure that it's not already in there
		if ([ptrValue isEqualToValue:[NSValue valueWithNonretainedObject:view]]){
			[mastersInitialContentOffset setObject:offset forKey:ptrValue];
			//[self setSyncPoint:point forSynchronziedView:view];
			
			NSValue *ptrViewKey;
			for (NSValue *ptrValue in [synchronizedMasters allKeys])  //find the pointer view
				if ([ptrValue isEqualToValue:[NSValue valueWithPointer:view]])
					ptrViewKey = ptrValue;
			
			UIView *syncPointerView = [synchronizedMasters objectForKey:ptrViewKey];
			CGPoint inViewPoint = [self convertPoint:point fromView:view];
			[syncPointerView setCenterX:inViewPoint.x];
			//[self zeroOffsetForMaster:view];
			return;
		}
	}	
	
	NSValue *key = [NSValue valueWithPointer:view];
	[mastersInitialContentOffset setObject:offset forKey:key];
	//[self setSyncPoint:point forSynchronziedView:view];
	
	NSValue *ptrViewKey;
	for (NSValue *ptrValue in [synchronizedMasters allKeys])  //find the pointer view
		if ([ptrValue isEqualToValue:[NSValue valueWithPointer:view]])
			ptrViewKey = ptrValue;
	
	UIView *syncPointerView = [synchronizedMasters objectForKey:ptrViewKey];
	CGPoint inViewPoint = [self convertPoint:point fromView:view];
	[syncPointerView setCenterX:inViewPoint.x];
	//[self zeroOffsetForMaster:view];
}


-(void) updateOffset:(CGPoint)contentOffsetPoint forMaster:(DBDTiledView*)view{
	NSValue *offset = [NSValue valueWithCGPoint:contentOffsetPoint];
	
	for (NSValue *ptrValue in [mastersInitialContentOffset allKeys]) {//need to check to make sure that it's not already in there
		if ([ptrValue isEqualToValue:[NSValue valueWithNonretainedObject:view]]){
			[mastersInitialContentOffset setObject:offset forKey:ptrValue];			
			return;
		}
	}	
	NSValue *key = [NSValue valueWithPointer:view];
	[mastersInitialContentOffset setObject:offset forKey:key];
}

-(void) setSyncPoint:(CGPoint)point forSynchronziedView:(DBDTiledView*)view{
	NSValue *ptrViewKey;
	for (NSValue *ptrValue in [synchronizedMasters allKeys])  //find the pointer view
		if ([ptrValue isEqualToValue:[NSValue valueWithPointer:view]])
			ptrViewKey = ptrValue;
		
	UIView *syncPointerView = [synchronizedMasters objectForKey:ptrViewKey];
	
	NSValue *contentOffsetKey;
	for (NSValue *ptrValue in [mastersInitialContentOffset allKeys])  //find the pointer view
		if ([ptrValue isEqualToValue:[NSValue valueWithPointer:view]])
			contentOffsetKey = ptrValue;
	
	NSValue *offsetValue = [mastersInitialContentOffset objectForKey:contentOffsetKey];
	CGPoint offsetPoint = [offsetValue CGPointValue];
	
//	CGPoint inViewPoint = [self convertPoint:point fromView:view];
//	CGPoint inViewOffset = [self convertPoint:offsetPoint fromView:view];
	CGPoint inViewPoint = point;
	CGPoint inViewOffset = offsetPoint;

	CGPoint diffPoint = CGPointMake(abs(inViewPoint.x) - abs(inViewOffset.x), abs(inViewPoint.y) - abs(inViewOffset.y));

	[syncPointerView setCenterX:syncPointerView.center.x - diffPoint.x];
	[self updateOffset:point forMaster:view];
}

-(void) setPointerImage:(UIImage*)image forSynchronizedMasterView:(DBDTiledView*)view{
	UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
	NSValue *key;
	for (NSValue *ptrValue in [synchronizedMasters allKeys]) {//need to check to make sure that it's not already in there
		if ([ptrValue isEqualToValue:[NSValue valueWithNonretainedObject:view]]){
			NSLog(@"that view is already severing as a sync master");
			return;
		}
	}
	key = [NSValue valueWithPointer:view];
	
	[synchronizedMasters setObject:imageView forKey:key];
	[view.synchronizedSlaves addObject:self];
	[imageView release];
	[imageView setFrameOrigin:CGPointMake(-imageView.bounds.size.width*10, -imageView.bounds.size.height)];
	[self addSubview:imageView];
}

-(void) removePointerImageForSynchronizedView:(DBDTiledView*)view{
	NSValue *key;
	for (NSValue *ptrValue in [synchronizedMasters allKeys])
		if ([ptrValue isEqualToValue:[NSValue valueWithPointer:view]])
			key = ptrValue;
	[synchronizedMasters removeObjectForKey:key];
}

-(UIImageView*)syncPointerForMaster:(DBDTiledView*)master{
	NSValue *key;
	for (NSValue *ptrValue in [synchronizedMasters allKeys]) 
		if ([ptrValue isEqualToValue:[NSValue valueWithPointer:master]])
			key = ptrValue;
	
	return [synchronizedMasters objectForKey:key];
}

#pragma mark -- Sync Master Methods--
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
	for (DBDTiledView *view in synchronizedSlaves){
		CGPoint reverseContentOffset = CGPointMake(-scrollView.contentOffset.x, scrollView.contentOffset.y);
//		reverseContentOffset = [scrollView convertPoint:reverseContentOffset fromView:view];
		[view setSyncPoint:reverseContentOffset forSynchronziedView:self];
	}
	
	//keep the pointers in this view from scolling along
	for (NSValue *pointerViewValue in [syncPointerFixatives allKeys]){//we don't want the view that are in our frame to move.
		NSValue *centerPointAsValue = [syncPointerFixatives objectForKey:pointerViewValue];
		CGPoint centerPoint = [centerPointAsValue CGPointValue];
		UIView *pointerView = (UIView*)[pointerViewValue pointerValue];
		CGPoint diffPoint =  CGPointMake(abs(centerPoint.x)-abs(scrollView.contentOffset.x), abs(centerPoint.y)-abs(scrollView.contentOffset.y));
		[pointerView setCenterX:pointerView.center.x - diffPoint.x];
		[MLPrimitives NSLogCGPoint:pointerView.center withMessage:nil];
	}
	[syncPointerFixatives removeAllObjects];
	for (UIView *pointerView in [synchronizedMasters allValues]){
		[syncPointerFixatives setObject:[NSValue valueWithCGPoint:scrollView.contentOffset] forKey:[NSValue valueWithPointer:pointerView]];
	}
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{ //implemented to keep any pointers housed in this view from moving
	for (UIView *pointerView in [synchronizedMasters allValues])
		[syncPointerFixatives setObject:[NSValue valueWithCGPoint:scrollView.contentOffset] forKey:[NSValue valueWithPointer:pointerView]];
}

#pragma mark --Animation Methods--
-(void) slideInVerticallyAnimationed{
	[UIView beginAnimations:@"tileViewSlideIn" context:nil];
	[UIView setAnimationDuration:kDBDTiledViewSildeInOutAnimationTime];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:context:)];
		[self setFrameOriginY:self.frame.origin.y-self.frame.size.height];
		self.alpha = 0.0;
	[UIView	 commitAnimations];
}
-(void) slideOutVerticallyAnimated{
	[self.superview bringSubviewToFront:self];
	
	[UIView beginAnimations:@"tileViewSlideIn" context:nil];
	[UIView setAnimationDuration:kDBDTiledViewSildeInOutAnimationTime];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:context:)];
		[self setFrameOriginY:self.frame.origin.y+self.frame.size.height];
		self.alpha = 1.0;
	[UIView	 commitAnimations];
}

- (void)animationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context{
	if(self.alpha)
		;
	else
		[self.superview sendSubviewToBack:self];
}
/*
- (void)drawRect:(CGRect)rect {
    // Drawing code
} */


@end




@implementation  DBDTiledView (DBDTiledView_hidden)
-(void) changeToState:(DBDTiledViewState)state{}
-(void) viewAppearAnimation:(UIView*)view{
	view.alpha = 0.0;
	NSTimeInterval animationDuration = 0.2;
	
	[UIView beginAnimations:@"viewAppearAnimation" context:nil];
	[UIView setAnimationDuration:animationDuration];
		view.alpha = 1.0;
	[UIView commitAnimations];
	[NSTimer scheduledTimerWithTimeInterval:animationDuration target:self selector:@selector(refreshContentSize) userInfo:nil repeats:NO];
}

-(void) viewDisappearAnimation:(UIView*)view{
	view.alpha = 1.0;
	NSTimeInterval animationDuration = 0.2;
	
	[UIView beginAnimations:@"viewDisappearAnimation" context:nil];
	[UIView setAnimationDuration:animationDuration];
	view.alpha = 0.0;
	[UIView commitAnimations];
	[NSTimer scheduledTimerWithTimeInterval:animationDuration target:self selector:@selector(removeViewAfterTimer:) userInfo:view repeats:NO];
}

-(void) bumpTilesAfterIndex:(NSUInteger)index distance:(CGFloat)distance{
	NSTimeInterval animationDuration = 0.2;
	
	[UIView beginAnimations:@"tileBumpAnimation" context:nil];
	[UIView setAnimationDuration:animationDuration];
	for(int i = index + 1; i < tiles.count; i++){
		CGFloat startX = [[tiles objectAtIndex:i] frame].origin.x;
		[[tiles objectAtIndex:i] setFrameOriginX:startX + distance];
		if (backgroundViews.count > i)  //the never ending fight against over addressing an array
			((UIView*)[backgroundViews objectAtIndex:i]).center = ((UIView*)[tiles objectAtIndex:i]).center;
		if (foregroundViews.count > i)
			((UIView*)[foregroundViews objectAtIndex:i]).center = ((UIView*)[tiles objectAtIndex:i]).center;
	}
	[UIView commitAnimations];
	[NSTimer scheduledTimerWithTimeInterval:animationDuration target:self selector:@selector(refreshContentSize) userInfo:nil repeats:NO];
}

-(void) scaleTileToAspectFit:(UIView*)view{
	CGFloat width = tileElementWidth;
	CGPoint center = view.center;
	CGFloat startingWidth = view.frame.size.width;
	CGFloat startingHeight = view.frame.size.height;
	CGFloat height = width * startingHeight / startingWidth;
	view.bounds = CGRectMake(0.0, 0.0, width, height);
	view.center = center;	
}

-(void) removeViewAfterTimer:(NSTimer*)timer{[(UIView*)timer.userInfo removeFromSuperview];}
-(void) refreshContentSize{
	CGFloat sumWidths = 0.0;
	CGFloat maxHeight = 0.0;
	for (UIView *tile in tiles){
		maxHeight = maxHeight > tile.bounds.size.height ? maxHeight : tile.bounds.size.height;
		sumWidths += tile.bounds.size.width;
	}
	self.contentSize = CGSizeMake(sumWidths + tiles.count * kDBDTiledViewBumper + kDBDTiledViewBumper, self.contentSize.height);
}
@end