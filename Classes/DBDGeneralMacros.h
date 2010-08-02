//
//  DBDGeneralMacros.h
//  iTheeWed
//
//  Created by Mark Lorenz on 7-Mar-2010.
//  Copyright 2010 Dapple Before Dawn. All rights reserved.
//
// Revision history at the bottom of this file

#define DBDLocalizedString(format, ...) NSLocalizedString([NSString stringWithFormat:format, ## __VA_ARGS__], [NSString stringWithCString:object_getClassName(self)])



/* -- Revision History --
 v0.0	7-Mar-2010	Change Points: New File
 
*/
