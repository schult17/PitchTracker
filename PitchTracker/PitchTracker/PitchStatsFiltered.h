//
//  PitchStatsFiltered.h
//  PitchTracker
//
//  Created by Tanner Young-Schultz on 2016-05-22.
//  Copyright © 2016 UofTBaseball. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PitchStats.h"

@interface PitchStatsFiltered : NSObject

@property PitchStats *stats;
@property StatTypes statsFilters;
@property PitchTypes pitchFilters;

@end
