//
//  NSLogCustom.m
//  PitchTracker
//
//  Created by Tanner Young-Schultz on 2016-05-22.
//  Copyright © 2016 UofTBaseball. All rights reserved.
//

#import "NSLogCustom.h"

void NSLogCustom(int debug_level, NSString *format, ...)
{
    if( __DEBUGLEVEL__ != DEBUG_SILENT )
    {
        if( __DEBUGLEVEL__ >= debug_level )
        {
            // Type to hold information about variable arguments.
            va_list ap;
            
            // Initialize a variable argument list.
            va_start (ap, format);
            
            // NSLog only adds a newline to the end of the NSLog format if
            // one is not already there.
            if (![format hasSuffix: @"\n"])
                format = [format stringByAppendingString: @"\n"];
            
            NSString *body = [[NSString alloc] initWithFormat:format arguments:ap];
            
            // End using variable argument list.
            va_end (ap);
            
            fprintf(stderr, "%s", [body UTF8String] );
        }
    }
}
