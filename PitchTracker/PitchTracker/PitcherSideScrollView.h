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

#define PLAYERVIEW_HEIGHT 80
#define SCROLL_INSET 12

@interface PitcherSideScrollView : UIScrollView

-(void) changeTeam: (TeamNames) team;
-(void) clearContents;
-(void) addPitchersToView: (NSArray *) pitchers;

@end
