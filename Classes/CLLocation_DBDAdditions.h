//
//  CLLocation_DBDAdditions.h
//  iTheeWed
//
//  Created by Mark Lorenz on 3-Mar-2010.
//  Copyright 2010 Dapple Before Dawn. All rights reserved.
//
// Revision history at the bottom of this file

#import <CoreLocation/CoreLocation.h>

@interface CLLocation (CLLocation_DBDAdditions)

CLLocationCoordinate2D CLLocationCoordinateNAN(void);
bool CLLocationCoordiante2DEqualToLocationCoordiante2D (CLLocationCoordinate2D coord1, CLLocationCoordinate2D coord2);

+(void) NSLogCLLocationCoordinate2D:(CLLocationCoordinate2D)coordinate message:(NSString*)message;
@end
/* -- Revision History --
 v0.0	3-Mar-2010	Change Points: New File
 
*/
