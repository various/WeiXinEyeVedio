//
//  ViewController.m
//  LMPullToRefresh
//
//  Created by Tim Geng on 3/25/15.
//  Copyright (c) 2015 GF. All rights reserved.
//

#import "ViewController.h"
#import "LMEyeVedioControl.h"
#import "VedioRecordViewController.h"
@interface ViewController ()

@property(nonatomic,strong) LMEyeVedioControl *refreshControl;
@property(nonatomic,strong) id <UIViewControllerContextTransitioning> transitionContext;

@end

@implementation ViewController

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    CGFloat y = [[UIScreen mainScreen] bounds].size.height;
//    [self.tableView setContentOffset:CGPointMake(0, -y) animated:YES];
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext{
    
    if ([[transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey] isKindOfClass:[ViewController class]]) {
        UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
        ViewController *srcVC = (ViewController *)[transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
        // 2. Set init frame for toVC
        CGRect screenBounds = [[UIScreen mainScreen] bounds];
        CGRect finalFrame = [transitionContext finalFrameForViewController:toVC];
        toVC.view.frame = CGRectOffset(finalFrame, 0, screenBounds.size.height);
        
        // 3. Add toVC's view to containerView
        UIView *containerView = [transitionContext containerView];
        
        
        [srcVC.tableView setContentOffset:CGPointMake(0, -400) animated:YES];
        [containerView addSubview:toVC.view];
        // 4. Do animate now
        NSTimeInterval duration = [self transitionDuration:transitionContext];
        
        [UIView animateWithDuration:duration
                              delay:0.0
             usingSpringWithDamping:0.6
              initialSpringVelocity:0.0
                            options:UIViewAnimationOptionCurveLinear
                         animations:^{
                             
                             
                             
                         } completion:^(BOOL finished) {
                             // 5. Tell context that we completed.
                             toVC.view.frame = finalFrame;
                             
                             [transitionContext completeTransition:YES];
                         }];
//        double delayInSeconds = 2.0;
//        //创建一个调度时间,相对于默认时钟或修改现有的调度时间。
//        dispatch_time_t delayInNanoSeconds =dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
//        //推迟两纳秒执行
//        dispatch_queue_t concurrentQueue =dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
//        dispatch_after(delayInNanoSeconds, concurrentQueue, ^(void){
//            NSLog(@"Grand Center Dispatch!");
//        });
        
        
        
    

    }else{
        ViewController *toVC = (ViewController *)[transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
        UIViewController *srcVC = (UIViewController *)[transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
        // 2. Set init frame for toVC
        CGRect screenBounds = [[UIScreen mainScreen] bounds];
        CGRect finalFrame = [transitionContext finalFrameForViewController:toVC];
        toVC.view.frame = CGRectOffset(finalFrame, 0, screenBounds.size.height);
        
        // 3. Add toVC's view to containerView
        UIView *containerView = [transitionContext containerView];
        [containerView addSubview:toVC.view];
        
        // 4. Do animate now
        NSTimeInterval duration = [self transitionDuration:transitionContext];
        [toVC.tableView setContentOffset:CGPointMake(0, -[[UIScreen mainScreen] bounds].size.height) animated:NO];

        [UIView animateWithDuration:duration
                              delay:0.0
             usingSpringWithDamping:0.6
              initialSpringVelocity:0.0
                            options:UIViewAnimationOptionCurveLinear
                         animations:^{
                             
                             [self.tableView setContentOffset:CGPointMake(0, 0) animated:YES];
                             
                         } completion:^(BOOL finished) {
                             // 5. Tell context that we completed.
                             toVC.view.frame = finalFrame;
                             
                             [transitionContext completeTransition:YES];
                         }];
    }
   

}


- (id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source{
    return self;
}

- (id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed{
    return self;
}

- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext{
    return 1;
}

- (id <UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                   animationControllerForOperation:(UINavigationControllerOperation)operation
                                                fromViewController:(UIViewController *)fromVC
                                                  toViewController:(UIViewController *)toVC  NS_AVAILABLE_IOS(7_0){
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.refreshControl = [LMEyeVedioControl initRefreshControl:self targetAction:@selector(startLoading) scrollView:self.tableView];

    


    VedioRecordViewController *vedioController = [[VedioRecordViewController alloc] initWithNibName:@"VedioRecordViewController" bundle:nil];
    __weak typeof(self) weakSelf = self;
    vedioController.transitioningDelegate = self;
    self.transitioningDelegate = self;
    self.navigationController.delegate = self;
    self.refreshControl.beginShowVideo = ^void(){
        weakSelf.navigationController.delegate = weakSelf;

        [weakSelf.navigationController pushViewController:vedioController animated:YES];
     //   [weakSelf presentViewController:vedioController animated:YES completion:nil];
    };
    // Do any additional setup after loading the view, typically from a nib.
}

-(void)startLoading{
    [self performSelector:@selector(endLoading) withObject:self afterDelay:3];
}

-(void)endLoading{
    [self.refreshControl endRefresh];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10;
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"cellIdentifier";
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    cell.backgroundColor = [UIColor greenColor];
    return cell;
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
