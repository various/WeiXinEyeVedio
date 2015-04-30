//
//  EyeView.h
//  LMPullToRefresh
//
//  Created by Tim Geng on 4/30/15.
//  Copyright (c) 2015 GF. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EyeView : UIView

@property(nonatomic,copy) void(^drawEye)(float percent);

@end
