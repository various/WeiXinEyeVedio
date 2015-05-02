//
//  LMRefreshControl.m
//  LMPullToRefresh
//
//  Created by Tim Geng on 3/25/15.
//  Copyright (c) 2015 GF. All rights reserved.
//

#import "LMEyeVedioControl.h"

static const CGFloat EyeBeginHeight = 44;
static const CGFloat EyeBallShowHeight = 66;

static const CGFloat EyeCircleBegin = 75;
static const CGFloat EyeCircleEnd = 80;

static const CGFloat EyeOrbitalBegin = 84;
static const CGFloat EyeOrbitalEnd = 105;

static const CGFloat EyeBecomeToWhiteColor = 110;

static const CGFloat EyeOrbitalMaskHeight = 45;

static const CGFloat EyeVedioShowHeight = 150;

#define EyeColor [UIColor colorWithRed:158/255.0 green:153/255.0 blue:150/255.0 alpha:1.0]

@interface LMEyeVedioControl ()<UIScrollViewDelegate>

@property(nonatomic,strong) UIScrollView *scrollView;
@property(nonatomic,strong) NSMutableArray *loadingImages;
@property(nonatomic,strong) NSMutableArray *dropDownImages;

@property(nonatomic,assign) CGFloat pullingPercent;
@property(nonatomic,weak) id target;
@property(nonatomic,assign) BOOL isDragging;
@property(nonatomic,assign) SEL targetAction;
@property(nonatomic,strong) CAShapeLayer *eyeLayer;
@property(nonatomic,strong) CAShapeLayer *circleLayer;
@property(nonatomic,strong) UIBezierPath *circlePath;
@property(nonatomic,strong) UIBezierPath *eyePath;

@property(nonatomic,strong) CAShapeLayer *orbitalLayer;
@property(nonatomic,strong) UIBezierPath *orbitalPath;
@property(nonatomic,strong) CALayer *orbitalMaskLayer;

@property(nonatomic,strong) CAShapeLayer *orbitalDownLayer;
@property(nonatomic,strong) UIBezierPath *orbitalDownPath;
@property(nonatomic,strong) CALayer *orbitalMaskDownLayer;

@property(nonatomic,weak) IBOutlet UIView *eyeView;

@property(nonatomic,assign) BOOL hasShowVideo;

@end


@implementation LMEyeVedioControl

+(LMEyeVedioControl *)initRefreshControl:(id)target targetAction:(SEL)targetAction scrollView:(UIScrollView *)scrollView{
    NSArray *nibViews = [[NSBundle mainBundle] loadNibNamed:@"LMEyeVedioControl" owner:self options:nil];
    LMEyeVedioControl *refreshControl = (LMEyeVedioControl *)[nibViews firstObject];
    refreshControl.scrollView = scrollView;
    refreshControl.frame = CGRectMake(0, 0, refreshControl.scrollView.frame.size.width, 0);
    [refreshControl.scrollView addSubview:refreshControl];
    [refreshControl.scrollView addObserver:refreshControl forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
    refreshControl.target = target;
    refreshControl.targetAction = targetAction;
    refreshControl.loadingImages = [[NSMutableArray alloc] initWithCapacity:3];
    refreshControl.dropDownImages = [[NSMutableArray alloc] initWithCapacity:60];
    scrollView.delegate = refreshControl;
    
    refreshControl.isDragging = NO;
    
    [refreshControl initialEyeLayer];

    return refreshControl;
}

-(void)initialEyeLayer{
    
    self.hasShowVideo = NO;

    self.eyeLayer = [CAShapeLayer layer];
    self.eyeLayer.frame = self.eyeView.bounds;
    self.eyeLayer.backgroundColor = [UIColor clearColor].CGColor;
    [self.eyeView.layer addSublayer:self.eyeLayer];
    self.eyeLayer.fillColor = EyeColor.CGColor;
    self.eyeLayer.lineWidth = 1.0;
    self.eyePath = [[UIBezierPath alloc] init];
    
    self.circleLayer = [CAShapeLayer layer];
    self.circleLayer.frame = self.eyeView.bounds;
    self.circleLayer.backgroundColor = [UIColor clearColor].CGColor;
    [self.eyeView.layer addSublayer:self.circleLayer];
    self.circleLayer.fillColor = [UIColor clearColor].CGColor;

    self.circleLayer.lineWidth = 1.0;
    self.circlePath = [[UIBezierPath alloc] init];
    
    self.orbitalLayer = [CAShapeLayer layer];
    self.orbitalLayer.frame = self.eyeView.bounds;
    self.orbitalLayer.backgroundColor = [UIColor clearColor].CGColor;
    [self.eyeView.layer addSublayer:self.orbitalLayer];
    self.orbitalLayer.fillColor = [UIColor clearColor].CGColor;
    self.orbitalLayer.lineWidth = 1.0;
    self.orbitalPath = [[UIBezierPath alloc] init];
    
    self.orbitalMaskLayer = [CALayer layer];
    self.orbitalMaskLayer.frame = CGRectMake(0, 5, self.eyeView.frame.size.width, 45);
    self.orbitalLayer.mask = self.orbitalMaskLayer;
    self.orbitalMaskLayer.backgroundColor = [UIColor blueColor].CGColor;
    self.orbitalMaskLayer = [CALayer layer];
    self.orbitalMaskLayer.frame = CGRectMake(0, 5, self.eyeView.frame.size.width, 45);
    self.orbitalLayer.mask = self.orbitalMaskLayer;
    self.orbitalMaskLayer.backgroundColor = [UIColor blueColor].CGColor;
    
    self.orbitalDownLayer = [CAShapeLayer layer];
    self.orbitalDownLayer.frame = self.eyeView.bounds;
    self.orbitalDownLayer.backgroundColor = [UIColor clearColor].CGColor;
    [self.eyeView.layer addSublayer:self.orbitalDownLayer];
    self.orbitalDownLayer.fillColor = [UIColor clearColor].CGColor;
    self.orbitalDownLayer.lineWidth = 1.0;
    self.orbitalDownPath = [[UIBezierPath alloc] init];
    
    self.orbitalMaskDownLayer = [CALayer layer];
    self.orbitalMaskDownLayer.frame = CGRectMake(0, 5, self.eyeView.frame.size.width, 45);
    self.orbitalDownLayer.mask = self.orbitalMaskDownLayer;
    self.orbitalMaskDownLayer.backgroundColor = [UIColor blueColor].CGColor;
    self.orbitalMaskDownLayer = [CALayer layer];
    self.orbitalMaskDownLayer.frame = CGRectMake(0, 5, self.eyeView.frame.size.width, 45);
    self.orbitalDownLayer.mask = self.orbitalMaskDownLayer;
    self.orbitalMaskDownLayer.backgroundColor = [UIColor blueColor].CGColor;
    

    [self setStrokeColorToEyeColor];
}

-(void)setStrokeColorToEyeColor{
    self.eyeLayer.strokeColor = EyeColor.CGColor;
    self.orbitalLayer.strokeColor = EyeColor.CGColor;
    self.orbitalDownLayer.strokeColor = EyeColor.CGColor;
    self.circleLayer.strokeColor = EyeColor.CGColor;
}

-(void)setStrokeColorToWhiteColor{
    self.eyeLayer.strokeColor = [UIColor whiteColor].CGColor;
    self.orbitalLayer.strokeColor = [UIColor whiteColor].CGColor;
    self.orbitalDownLayer.strokeColor = [UIColor whiteColor].CGColor;
    self.circleLayer.strokeColor = [UIColor whiteColor].CGColor;
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    self.frame = CGRectMake(0, 0, self.scrollView.frame.size.width, self.scrollView.contentOffset.y);
    CGFloat offsexY = ABS(self.scrollView.contentOffset.y);
    
    self.eyeLayer.path = self.eyePath.CGPath;
    self.circleLayer.path = self.circlePath.CGPath;
    self.orbitalLayer.path = self.orbitalPath.CGPath;
    self.orbitalDownLayer.path = self.orbitalDownPath.CGPath;

    if(  offsexY >= EyeBeginHeight && offsexY <= EyeBallShowHeight){
        float eyeBallShowPercent = (offsexY - EyeBeginHeight) / (EyeBallShowHeight - EyeBeginHeight);
        [self.eyePath moveToPoint:CGPointMake(24, 27)];
        //49,48
        [self.eyePath addArcWithCenter:self.eyeLayer.position radius:13 startAngle:M_PI+0.1 endAngle:M_PI + 0.5 clockwise:YES];
        CGFloat offsetX1 =  30-24;
        CGFloat offsexY1 =   28-27;
        
        CGFloat offsexX2 = 31 - 25;
        CGFloat offsexY2 = 26 - 24;
        
        [self.eyePath addLineToPoint:CGPointMake(25 + offsexX2*eyeBallShowPercent, 26 + offsexY2*eyeBallShowPercent)];
        
        [self.eyePath addLineToPoint:CGPointMake(24+offsetX1*eyeBallShowPercent, 27+offsexY1*eyeBallShowPercent)];
//        [self.eyePath addLineToPoint:CGPointMake(31, 26)];
//        
//        [self.eyePath addLineToPoint:CGPointMake(30, 28)];
        
        [self.eyePath closePath];
        
        CGFloat offsetX3 =  32-28;
        CGFloat offsexY3 =   24-20;
        
        CGFloat offsexX4 = 36 - 35;
        CGFloat offsexY4 = 22 - 15;
        
        
        [self.eyePath moveToPoint:CGPointMake(28, 20)];
        [self.eyePath addArcWithCenter:self.eyeLayer.position radius:13 startAngle:M_PI*1.5-0.7 endAngle:M_PI*1.5-0.1 clockwise:YES];
        [self.eyePath addLineToPoint:CGPointMake(35+ offsexX4 * eyeBallShowPercent, 15+offsexY4*eyeBallShowPercent)];
        [self.eyePath addLineToPoint:CGPointMake(28+offsetX3*eyeBallShowPercent, 20+offsexY3*eyeBallShowPercent)];
//        [self.eyePath addLineToPoint:CGPointMake(36, 22)];
//        [self.eyePath addLineToPoint:CGPointMake(32, 24)];
        
        [self.eyePath closePath];
    }

    if( offsexY >= EyeCircleBegin && offsexY <= EyeCircleEnd){
       // [self.circlePath moveToPoint:CGPointMake(54, 28)];
        self.circleLayer.lineWidth = ((offsexY - EyeCircleBegin)/(EyeCircleEnd-EyeCircleBegin))*1;
        [self.circlePath addArcWithCenter:self.circleLayer.position radius:17 startAngle:0 endAngle:2*M_PI clockwise:YES];
        [self.circlePath closePath];
        
    }
    
    if (offsexY >= EyeOrbitalBegin && offsexY <= EyeOrbitalEnd) {
        
        float eyeOrbitalShowPercent = (offsexY - EyeOrbitalBegin) / (EyeOrbitalEnd - EyeOrbitalBegin);

//        CGFloat offsetX = 68-37;
//        CGFloat offsexY = 29-7;
        self.orbitalPath = [UIBezierPath bezierPath];
//        CGPoint leftPoint = CGPointMake(37 - offsetX * eyeOrbitalShowPercent , 7 + offsexY*eyeOrbitalShowPercent);
//     //   CGPoint leftPoint = CGPointMake(5,28);
//      //  CGPoint rightPoint = CGPointMake(68,29);
//        CGPoint rightPoint = CGPointMake(37 + offsetX * eyeOrbitalShowPercent, 7 + offsexY*eyeOrbitalShowPercent);
       
        [self.orbitalPath moveToPoint:CGPointMake(5, 28)];
        
        [self.orbitalPath addQuadCurveToPoint:CGPointMake(68, 29) controlPoint:CGPointMake(37, -15)];
        [self.orbitalDownPath moveToPoint:CGPointMake(5, 28)];
        
        [self.orbitalDownPath addQuadCurveToPoint:CGPointMake(68, 29) controlPoint:CGPointMake(37, 72)];
       // self.orbitalLayer.mask = nil;
        
        self.orbitalMaskLayer.frame = CGRectMake(0, 6 , self.eyeView.frame.size.width, eyeOrbitalShowPercent * EyeOrbitalMaskHeight/2.0);
        self.orbitalMaskDownLayer.frame = CGRectMake(0, 52 - (52 - 28)*eyeOrbitalShowPercent , self.eyeView.frame.size.width, eyeOrbitalShowPercent * EyeOrbitalMaskHeight/2.0);

        NSLog(@"frame = %@",NSStringFromCGRect(self.orbitalMaskLayer.frame));
    }
    
    if (offsexY >= EyeVedioShowHeight && !self.hasShowVideo) {
        self.hasShowVideo = YES;
        if (self.beginShowVideo) {
            self.beginShowVideo();
        }
    }
    
    if (offsexY >= EyeBecomeToWhiteColor) {
        [self setStrokeColorToWhiteColor];
    }
    
    [self.eyeLayer setNeedsDisplay];
    [self.circleLayer setNeedsDisplay];
    [self.eyeView setNeedsDisplay];
}

- (void)endRefresh{
    [UIView animateWithDuration:1 delay:0 usingSpringWithDamping:0.7 initialSpringVelocity:0.5 options:UIViewAnimationOptionCurveLinear animations:^{
        
       
    } completion:^(BOOL finished){

    }];
}

#pragma uiscrolldelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    self.eyePath.CGPath = [UIBezierPath bezierPath].CGPath;
    self.circlePath.CGPath = [UIBezierPath bezierPath].CGPath;
    self.orbitalPath.CGPath = [UIBezierPath bezierPath].CGPath;
    self.orbitalDownPath.CGPath = [UIBezierPath bezierPath].CGPath;
    [self setStrokeColorToEyeColor];
    self.hasShowVideo = NO;
    [self.scrollView setContentInset:UIEdgeInsetsMake(0, 0, 0, 0)];
    self.isDragging = YES;
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    
   //     [self.scrollView setContentInset:UIEdgeInsetsMake(RefreshControlAnimationHeight, 0, 0, 0)];
        
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [self.target performSelector:self.targetAction withObject:nil];
#pragma clang diagnostic pop
        self.isDragging = NO;
    
}

-(void)dealloc{
    [self removeObserver:self.scrollView forKeyPath:@"contentOffset"];
}

- (void)layoutSubviews{
    [super layoutSubviews];
}

@end
