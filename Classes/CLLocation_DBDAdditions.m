//
//  CLLocation_DBDAdditions.m
//  iTheeWed
//
//  Created by Mark Lorenz on 3-Mar-2010.
//  Copyright 2010 Dapple Before Dawn. All rights reserved.
//

#import "CLLocation_DBDAdditions.h"

@implementation CLLocation (CLLocation_DBDAdditions)

CLLocationCoordinate2D CLLocationCoordinateNAN(void){
	CLLocationCoordinate2D coord;
	coord.latitude = 361.0; coord.longitude = 361.0;
	return coord;
}

bool CLLocationCoordiante2DEqualToLocationCoordiante2D (CLLocationCoordinate2D coord1, CLLocationCoordinate2D coord2){
	return (coord1.longitude == coord2.longitude) ? ((coord1.latitude == coord2.latitude) ? YES : NO) :  NO;
}

+(void) NSLogCLLocationCoordinate2D:(CLLocationCoordinate2D)coordinate message:(NSString*)message{NSLog(@"%@ \n longitude: %f \n latitude: %f", message, coordinate.longitude, coordinate.latitude);}
@end
