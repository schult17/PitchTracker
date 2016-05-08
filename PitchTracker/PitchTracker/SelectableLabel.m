//
//  SelectableLabel.m
//  PitchTracker
//
//  Created by Tanner Young-Schultz on 2016-04-30.
//  Copyright © 2016 UofTBaseball. All rights reserved.
//

#import "SelectableLabel.h"

@implementation SelectableLabel

@synthesize selected = _selected;

-(id) init
{
    self = [ super init ];
    [ self setAttributes:@"" ];
    
    return self;
}

-(id) initWithStr:(NSString *)text
{
    self = [ super init ];
    [ self setAttributes:text ];
    
    return self;
}

-(void) setAttributes:(NSString *)text
{
    UIFont *font = self.font;
    font = [ font fontWithSize:30 ];
    self.font = font;
    _selected = false;
    self.text = text;
    self.textColor = [ UIColor lightTextColor ];
    self.numberOfLines = 1;
    self.adjustsFontSizeToFitWidth = YES;
    self.textAlignment = NSTextAlignmentCenter;
}

-(void) toggleSelected
{
    _selected = !_selected;
    self.textColor = _selected ? [UIColor greenColor] : [UIColor lightTextColor];
}

-(void)setSelect:(bool)selected
{
    _selected = selected;
    self.textColor = _selected ? [UIColor greenColor] : [UIColor lightTextColor];
}

@end
