//
//  ViewController.m
//  LMPullToRefresh
//
//  Created by Tim Geng on 3/25/15.
//  Copyright (c) 2015 GF. All rights reserved.
//

#import "ViewController.h"
#import "LMRefreshControl.h"
#import "VedioRecordViewController.h"
@interface ViewController ()

@property(nonatomic,strong) LMRefreshControl *refreshControl;
@property(nonatomic,strong) id <UIViewControllerContextTransitioning> transitionContext;

@end

@implementation ViewController

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext{
    UIViewController *src = (UIViewController *)[transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *dest = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    CGRect f = src.view.frame;
    CGRect originalSourceRect = src.view.frame;
    f.origin.y = f.size.height;
    
    [UIView animateWithDuration:0.5 animations:^{
        src.view.frame = f;
        
    } completion:^(BOOL finished){
        src.view.alpha = 0;
        dest.view.frame = f;
        dest.view.alpha = 0.0f;
        [[src.view superview] addSubview:dest.view];
        [UIView animateWithDuration:0.5 animations:^{
            
            dest.view.frame = originalSourceRect;
            dest.view.alpha = 1.0f;
        } completion:^(BOOL finished) {
            
            //[dest.view removeFromSuperview];
            src.view.alpha = 1.0f;
            [transitionContext completeTransition:YES];
        }];
    }];
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
    self.refreshControl = [LMRefreshControl initRefreshControl:self targetAction:@selector(startLoading) scrollView:self.tableView];

    
    

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
