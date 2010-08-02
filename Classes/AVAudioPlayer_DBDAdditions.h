//
//  AVAudioPlayer_DBDAdditions.h
//  iTheeWed
//
//  Created by Mark Lorenz on 28-Mar-2010.
//  Copyright 2010 Dapple Before Dawn. All rights reserved.
//
// Revision history at the bottom of this file

#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>


@interface AVAudioPlayer (AVAudioPlayer_DBDAdditions)

+(void) playResouce:(NSString*)name ofType:(NSString*)type;
void audioServicesSystemSoundCompletionProc (SystemSoundID  ssID, void *clientData);
@end

/* -- Revision History --
 v0.0	28-Mar-2010	Change Points: New File
 
*/
