//
//  aMMHiddenCombinationDelegate.m
//  aMakeupMatchup
//
//  Created by Mark Lorenz on 13-May-2010.
//  Copyright 2010 Dapple Before Dawn. All rights reserved.
//

#import "aMMHiddenCombinationDelegate.h"


@implementation aMMHiddenCombinationDelegate

-(void)dealloc{
	[images release];
	
	ML_DEBUG(NSLog(@"Class dealloc: %@", [NSString stringWithCString:object_getClassName(self)]));
	[super dealloc];
}

-(id) init{
	if (self = [super init]){
		NSMutableArray *mutableImagesArray = [[NSMutableArray alloc] init];
		for (NSString *fileName in [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"product" ofType:@"plist"]]){
			UIImage *image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:fileName ofType:@"png"]];
			[mutableImagesArray addObject:image];
		}
		images = [mutableImagesArray copy];
		[mutableImagesArray release];
	}
	return self;
}
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{return 3;}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{return images.count;}

//- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{:}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{return [(UIImage*)[images objectAtIndex:component] size].height;}

//- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{:}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
	return [[[UIImageView alloc] initWithImage:[images objectAtIndex:row]] autorelease];
}

//- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component{;}
@end

@implementation aMMHiddenCombinationDelegate (aMMHiddenCombinationDelegate_hidden)

@end