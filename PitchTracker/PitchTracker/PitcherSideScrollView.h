//
//  PitcherSideScrollView.h
//  PitchTracker
//
//  Created by Tanner Young-Schultz on 2016-04-30.
//  Copyright © 2016 UofTBaseball. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PitcherSideView.h"
#import "LocalPitcherDatabase.h"

@interface PitcherSideScrollView : UIScrollView

-(void) changeTeam: (TeamNames) team;
-(void) clearContents;
-(void) addPitchersToView: (NSArray *) pitchers;

@end
