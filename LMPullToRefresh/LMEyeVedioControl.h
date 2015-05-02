//
//  LMRefreshControl.h
//  LMPullToRefresh
//
//  Created by Tim Geng on 3/25/15.
//  Copyright (c) 2015 GF. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LMEyeVedioControl : UIView

+(LMEyeVedioControl *)initRefreshControl:(id)target targetAction:(SEL)targetAction scrollView:(UIScrollView *)scrollView;

- (void)endRefresh;

-(void)initialEyeLayer;

@property(nonatomic,copy) void(^beginShowVideo)();

@end
