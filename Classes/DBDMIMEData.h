//
//  DBDMIMEData.h
//  iTheeWed
//
//  Created by Mark Lorenz on 2/16/10.
//  Copyright 2010 Dapple Before Dawn. All rights reserved.
//

#import <Foundation/Foundation.h>

#define ML_DEBUG(x) ;  // "ML_DEBUG(x) ;"  -sliences dealloc logging  "ML_DEBUG(x) (x)" activates dealloc logging

//@protocol <#protocol#>
//
//<#methods#>
//
//@end

@interface DBDMIMEData : NSObject {
	NSStringEncoding encoding;
	NSString *boundary;
	NSMutableDictionary *_instanceStorage;
}

@property (nonatomic, assign) NSStringEncoding encoding;
@property (nonatomic, retain) NSString *boundary;

+(id) MIMEDataWithFormDictionary:(NSDictionary*)dictionary;

-(void) appendMIMEFormValue:(NSString*)value forField:(NSString*)field;				//for form-type data just pass NSString as value, and NSString as field
-(void) appendMIMEDataValue:(NSData*)value withExtendedInformation:(NSArray*)info;	//for image or other type pass NSData as the object and an array structured as:
																					//fieldname, filename, content-type for the info
-(NSData*) MIMEdata;
-(NSString*)description;

@end

@interface DBDMIMEData (DBDMIMEData_hidden)
-(void) generateBoundary;
-(NSData*) compileMIMEData;

@end