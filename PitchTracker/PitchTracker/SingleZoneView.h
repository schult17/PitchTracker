//
//  SingleZoneView.h
//  PitchTracker
//
//  Created by Tanner Young-Schultz on 2016-05-12.
//  Copyright © 2016 UofTBaseball. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Globals.h"

@interface SingleZoneView : UIView

@property ZoneType type;
@property PitchLocation X;
@property PitchLocation Y;

@end
