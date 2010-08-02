//
//  DBDTiledView.m
//  UniversalCardUITest
//
//  Created by Mark Lorenz on 12/8/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "DBDInteractiveTileView.h"


@implementation DBDInteractiveTileView
@synthesize cursorView;
@synthesize acceptRemovedTileViews;

- (void)dealloc {
	[wiggleAnimation release];
	[cursorView release];
	[acceptRemovedTileViews release];
	
    [super dealloc];
}

- (void)awakeFromNib{
	[super awakeFromNib];
	[self defineWiggleAnimation];
	[self setupCursorView];
	acceptRemovedTileViews = [[NSMutableSet alloc] init];
	self.clipsToBounds = NO;
	lastRemovedTileIndex = -1;
}

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
		[self defineWiggleAnimation];
		[self setupCursorView];
		acceptRemovedTileViews = [[NSMutableSet alloc] init];	
		self.clipsToBounds = NO;
		lastRemovedTileIndex = -1;
	}
    return self;
}


/*
- (void)drawRect:(CGRect)rect {
    // Drawing code
} */

-(void) transferTile:(DBDMovableView*)tile hitPoint:(CGPoint)point{
	for (UIView *view in acceptRemovedTileViews)
		if([view pointInside:[view convertPoint:point fromView:self] withEvent:nil]){
			[view addSubview:tile];
			tile.center = [self convertPoint:point toView:view];
			break;
		}
	
	if (tile.superview == self) { //then the view didn't actually get transfered anywhere
		[self insertTile:tile AtIndex:lastRemovedTileIndex];
	}
	
	for(id observer in observers)
		if([observer respondsToSelector:@selector(tileView:transferedTile:)])
			[observer tileView:self transferedTile:tile];
}
-(void) removeTileAtIndex:(NSUInteger)index newSuperView:(UIView*)newSuperView newCenter:(CGPoint)newCenter{ //need to overload the superview, because in this case, we will be transfering the view to another view, as opposed to must making it disappear.
	UIView *tileToRemove = [tiles objectAtIndex:index];
	
	[self bumpTilesAfterIndex:index distance:-(tileElementWidth + kDBDTiledViewBumper)];
	[self viewDisappearAnimation:tileToRemove];
	
	[self removeBackgroundViewAtIndex:index];
	[self removeForegroundViewAtInxdex:index];
	[tiles removeObjectAtIndex:index];

	for(id observer in observers)
		if([observer respondsToSelector:@selector(tileView:removedTile:atIndex:)])
			[observer tileView:self removedTile:tileToRemove atIndex:index];
}


#pragma mark -- Super Class Methds, Disallowing Object Move--
-(void) insertTileAtEnd:(DBDMovableView*)tileView{
	if([tileView respondsToSelector:@selector(setAllowObjectMove:)])
		tileView.allowObjectMove = NO;
	[super insertTileAtEnd:tileView];
}
-(void) insertTile:(DBDMovableView*)tileView AtIndex:(NSUInteger)index{
	if([tileView respondsToSelector:@selector(setAllowObjectMove:)])
		tileView.allowObjectMove = NO;
	[super insertTile:tileView AtIndex:index];
}
-(void) addTilesFromArray:(NSArray*)array{
	for (DBDMovableView *view in array)
		if([view respondsToSelector:@selector(setAllowObjectMove:)])
		view.allowObjectMove = NO;
	[super addTilesFromArray:array];
}

@end


@implementation  DBDInteractiveTileView (DBDInteractiveTileView_hidden)
#pragma mark --Methods From Delegates--

-(void) touchesBegan:(NSSet*)touches forMovableView:(DBDMovableView*)view event:(UIEvent*)event{
	UIView *inView = view.superview;
	if (CGRectIntersectsRect([self convertRect:view.frame fromView:inView], self.bounds) && self.alpha > 0.1){
		view.allowObjectMove = NO;
	}
}

-(void) movableView:(DBDMovableView*)view didMoveCenterTo:(CGPoint)point inView:(UIView*)inView{
//	if (view.touchCurrentlyHeld && CGRectIntersectsRect([self convertRect:view.frame fromView:inView], self.frame)){
	if (CGRectIntersectsRect([self convertRect:view.frame fromView:inView], self.bounds) && self.alpha > 0.1){
		[self addSubview:cursorView];
		CGPoint inViewPoint = [self convertPoint:point fromView:inView];
		CGFloat scrollViewOffset; //blessedly this will always be 0, becuase the scroll view moves it's coordinates.
		CGFloat index = round(inViewPoint.x / (self.tileElementWidth + kDBDTiledViewBumper));
		[cursorView setCenterX:index * (self.tileElementWidth + kDBDTiledViewBumper) + scrollViewOffset];
	}
	else if(!CGRectIntersectsRect([self convertRect:view.frame fromView:inView], self.frame))
		[cursorView removeFromSuperview];

}

-(void) touchesEnded:(NSSet*)touches forMovableView:(DBDMovableView*)view event:(UIEvent*)event{
	if (view.touchCurrentlyHeld || ![tiles containsObject:view]){
		UIView *inView = view.superview;
		CGPoint point = view.center;
		CGPoint inViewPoint = [self convertPoint:point fromView:inView];
		CGFloat index = round(inViewPoint.x / (self.tileElementWidth + kDBDTiledViewBumper));
		if (CGRectIntersectsRect([self convertRect:view.frame fromView:inView], self.bounds) && self.alpha > 0.1 ){
			[self insertTile:view AtIndex:index];
//			[self refreshContentSize];
			view.allowObjectMove = NO;
		}
		else if (view.superview == self){ 
			[self transferTile:view hitPoint:inViewPoint];
			view.allowObjectMove = YES;
			}
		[self setReorderingView:nil];
		[cursorView removeFromSuperview];
		self.scrollEnabled = YES;
		lastRemovedTileIndex = -1;
	}
}
-(void) touchesCancelled:(NSSet*)touches forMovableView:(DBDMovableView*)view event:(UIEvent*)event{
	//[cursorView removeFromSuperview];
	//self.scrollEnabled = YES;
	NSLog(@"touch cancelled");
	[self touchesEnded:touches forMovableView:view event:event];
}

//-(void) touchesHeld:(NSSet*)touches forMovableView:(DBDMovableView*)view event:(UIEvent*)event{
-(void) touchesHeld:(NSSet*)touches forMovableView:(DBDMovableView*)view event:(UIEvent*)event{
	view.allowObjectMove = YES;
	// find index for representation
	if ([tiles containsObject:view]){
		[self setReorderingView:view];
	
		//remove from scroll view  (don't worry, it won't really be removed untill touches are released, and then we will re-assign it)
		int index = [tiles indexOfObject:view];
		[self bumpTilesAfterIndex:index distance:-(tileElementWidth + kDBDTiledViewBumper)];	
		lastRemovedTileIndex = index;
		[self removeBackgroundViewAtIndex:index];
		[self removeForegroundViewAtIndex:index];
		[tiles removeObjectAtIndex:index];
	
		[self bringSubviewToFront:reordingView];

		self.scrollEnabled = NO;
	}
}

-(void) setReorderingView:(UIView*)view{
//	[view retain];
//	
//	//if nil, the should do the clean up
//	if (!view){
//		for (UIView *makeWiggleView in backgroundViews)
//			[makeWiggleView.layer removeAnimationForKey:@"Dance F*ker"];
//		for (UIView *makeWiggleView in tiles)
//			[makeWiggleView.layer removeAnimationForKey:@"Dance F*ker"];
//		for (UIView *makeWiggleView in foregroundViews)
//			[makeWiggleView.layer removeAnimationForKey:@"Dance F*ker"];
//		
//		[reordingView.layer  removeAnimationForKey:@"Dance F*ker"];
//	}
//
//	[reordingView release];
//	reordingView = view;
//	
//	//should make the other views wiggle.
//	if (view){
//		for (UIView *makeWiggleView in backgroundViews)		
//			[makeWiggleView.layer addAnimation:wiggleAnimation forKey:@"Dance F*ker"];
//		for (UIView *makeWiggleView in tiles)		
//			[makeWiggleView.layer addAnimation:wiggleAnimation forKey:@"Dance F*ker"];
//		for (UIView *makeWiggleView in foregroundViews)		
//			[makeWiggleView.layer addAnimation:wiggleAnimation forKey:@"Dance F*ker"];
//	}
	[AVAudioPlayer playResouce:@"click reverse" ofType:@"wav"];
}														 

-(void) defineWiggleAnimation{
	wiggleAnimation = [[CABasicAnimation animationWithKeyPath:@"transform"] retain];
	//wiggleAnimation = [CABasicAnimation animationWithKeyPath:@"position"];
	wiggleAnimation.duration = 0.1;
	wiggleAnimation.repeatCount = 1e100f;
	wiggleAnimation.autoreverses = YES;
	wiggleAnimation.toValue = [NSValue valueWithCATransform3D:CATransform3DRotate(CATransform3DIdentity,0.5, 1.0 ,1.0 , 1.0)];	
//	wiggleAnimation.toValue = [NSValue valueWithCATransform3D:CATransform3DRotate(CATransform3DIdentity,0.5, 1.0 ,1.0 , 0.0)];	
//	wiggleAnimation.fromValue = [NSValue valueWithCGPoint:CGPointMake(layer.position.x-2, layer.position.y)];
//	wiggleAnimation.toValue =[NSValue valueWithCGPoint:CGPointMake(layer.position.x+2, layer.position.y)];
}

-(void) setupCursorView{
	UIImage *cursorRawImage = [UIImage imageNamed:@"CursorBar.png"];
	UIImage *cursorImage = [cursorRawImage stretchableImageWithLeftCapWidth:0 topCapHeight:cursorRawImage.size.height/2.0];
	self.cursorView = [[[UIImageView alloc] initWithImage:cursorImage] autorelease];
	[cursorView setFrameHeight:self.frame.size.height];
}

@end