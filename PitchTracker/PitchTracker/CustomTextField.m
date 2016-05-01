//
//  CustomTextFields.m
//  PitchTracker
//
//  Created by Tanner Young-Schultz on 2016-04-30.
//  Copyright © 2016 UofTBaseball. All rights reserved.
//

#import "CustomTextField.h"

@implementation CustomTextField

-(id) init
{
    self = [ super init ];
    [ self setAttributes ];
    return self;
}

-(id) initWithFrame:(CGRect)frame
{
    self = [ super initWithFrame:frame ];
    [ self setAttributes ];
    return self;
}

-(id) initWithString:(NSString*)place_text
{
    self = [ super  init ];
    [ self setAttributes ];
    [ self setPlaceholder:place_text ];
    
    return self;
}

-(id) initWithFrameAndString:(CGRect)frame with: (NSString *)place_text
{
    self = [ super initWithFrame:frame ];
    [ self setAttributes ];
    [ self setPlaceholder:place_text ];
    return self;
}

-(void) setAttributes
{
    [ self setBackgroundColor:[ UIColor whiteColor ] ];
    [ self.layer setCornerRadius:5.0f ];
    [ self.layer setBorderColor:[ UIColor grayColor ].CGColor ];
    [ self.layer setBorderWidth:1.0f ];
    self.textAlignment = NSTextAlignmentCenter;
}

@end
