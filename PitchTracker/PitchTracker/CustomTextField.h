//
//  CustomTextFields.h
//  PitchTracker
//
//  Created by Tanner Young-Schultz on 2016-04-30.
//  Copyright © 2016 UofTBaseball. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomTextField : UITextField

-(id) init;
-(id) initWithFrame:(CGRect)frame;
-(id) initWithString:(NSString*)place_text;
-(id) initWithFrameAndString:(CGRect)frame with: (NSString *)place_text;
-(void) setAttributes;


@end
