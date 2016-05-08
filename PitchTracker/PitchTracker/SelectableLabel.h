//
//  SelectableLabel.h
//  PitchTracker
//
//  Created by Tanner Young-Schultz on 2016-04-30.
//  Copyright © 2016 UofTBaseball. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SelectableLabel : UILabel

@property bool selected;

-(id)init;
-(id)initWithStr:(NSString*)text;
-(void)setAttributes:(NSString*)text;
-(void)toggleSelected;
-(void)setSelect:(bool)selected;

@end
