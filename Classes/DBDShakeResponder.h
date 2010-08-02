//
//  DBDShakeResponder.h
//  aMakeupMatchup
//
//  Created by Mark Lorenz on 29-Apr-2010.
//  Copyright 2010 Dapple Before Dawn. All rights reserved.
//
// Revision history at the bottom of this file

#import <Foundation/Foundation.h>

#define ML_DEBUG(x) ;  // "ML_DEBUG(x) ;"  -sliences dealloc logging  "ML_DEBUG(x) (x)" activates dealloc logging

@protocol DBDShakeResponderObserver
@optional
-(void) deviceShaken;
@end

@interface DBDShakeResponder : UIView {
	id _observer;
}
@property (nonatomic, assign, getter=observer, setter=setObserver) id _observer;

-(id) initWithSuperView:(UIView*)superView observer:(id)observer;
@end

/* -- Revision History --
 v0.0	29-Apr-2010	Change Points: New File
 
*/
