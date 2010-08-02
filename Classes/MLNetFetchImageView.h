//
//  MLNetFetchImageView.h
//  
//
//  Created by Mark Lorenz on 9/16/09.
//  Copyright 2009 Black Box Technology. All rights reserved.
//
//	This software is realsed under GPLv3.0.  Please distribute it to others, add it to your projects, make changes to it.
//	Any changes you make to this header file and it's  .m must also be released under GPL
//  Additionally, any changes you make must be submitted back to Black Box Technology.
//  You can reach us (me) at: markjlorenz@black-box-technology.com or markjlorenz@gmail.com
//	for more information on the GPL see: http://www.gnu.org/copyleft/gpl.html
//
// The saved data is an NSArray, structured like:
//	objectAtIndex:0 = image file name (NSString)
//	objectAtIndex:1 = image data (UIImage)
//	and named using ident (user supplied).  The file on the server must be named <ident>.png
//
// A good example of the PHP to interact with this class would be:
/*
 
 <?php
 $identifier = $_POST["ident"];
 $appname = $_POST["appname"];
 $iPhoneFileModification = $_POST["filemodification"];  //should be epoch time
 $imgName = $identifier . ".png";
 
 if (filemtime($imgName) >  $iPhoneFileModification){
 
 header('Content-Type: image/png');
 
 $img = imagecreatefrompng($imgName);
 imageAlphaBlending($img, true);
 imageSaveAlpha($img, true);
 
 imagepng($img);
 imagedestroy($img);
 }
 
 ?>
 
*/

#import <UIKit/UIKit.h>
#define MIN_IMAGE_SIZE (1024) // number of bytes the image must be larger than.
//#define ML_DEBUG(x) (x)  // flip this bit to do the error logging
#define ML_DEBUG(x) ; // flip this bit to silence
//ML_DEBUG(NSLog(@"Class dealloc: %@", [NSString stringWithCString:object_getClassName(self)]));

@interface MLNetFetchImageView : UIImageView {
	NSMutableData *responseData;
	NSString *identifier;
}


- (id)initWithFetchURL:(NSString*)URL identifier:(NSString*)ident bootStrapImage:(UIImage*)bootStrap;

#pragma mark -- Private --
- (NSString *)dataFilePath;
-(NSDate*) getFileModificationDate;
-(void) asnychronousImageFetch:(NSURL*)fetchURL;

@end
