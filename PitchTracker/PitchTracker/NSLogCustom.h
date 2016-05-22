//
//  NSLogCustom.h
//  PitchTracker
//
//  Created by Tanner Young-Schultz on 2016-05-22.
//  Copyright © 2016 UofTBaseball. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Globals.h"

#if __DEBUGLEVEL__ != DEBUG_SILENT
#define NSLog(level, args...) NSLogCustom(level, args);
#else
#define NSLog(level, args...)
#endif

void NSLogCustom(int debug_level, NSString *format, ...);
