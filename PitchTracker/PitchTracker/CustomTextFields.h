//
//  CustomTextFields.h
//  PitchTracker
//
//  Created by Tanner Young-Schultz on 2016-04-30.
//  Copyright © 2016 UofTBaseball. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomTextFields : UITextField

-(id) init;
-(id) initWithFrame:(CGRect)frame;
-(id) initWithFrameAndString:(CGRect)frame with: (NSString *)place_text;
-(void) setAttributes;

@end
