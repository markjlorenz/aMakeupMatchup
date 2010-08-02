//
//  AVAudioPlayer_DBDAdditions.m
//  iTheeWed
//
//  Created by Mark Lorenz on 28-Mar-2010.
//  Copyright 2010 Dapple Before Dawn. All rights reserved.
//

#import "AVAudioPlayer_DBDAdditions.h"

@implementation AVAudioPlayer (AVAudioPlayer_DBDAdditions)

+(void) playResouce:(NSString*)name ofType:(NSString*)type{
	NSURL *fileURL = [[NSURL alloc] initFileURLWithPath:[[NSBundle mainBundle] pathForResource:name ofType:type]];
	
    // Create a system sound object representing the sound file
	SystemSoundID _soundID;
    AudioServicesCreateSystemSoundID ((CFURLRef)fileURL ,&_soundID);
	AudioServicesPlaySystemSound (_soundID);
	AudioServicesAddSystemSoundCompletion(_soundID, NULL, NULL, audioServicesSystemSoundCompletionProc, NULL);
	[fileURL release];
}

void audioServicesSystemSoundCompletionProc (SystemSoundID  ssID, void *clientData){
	AudioServicesDisposeSystemSoundID (ssID);
}
	
@end