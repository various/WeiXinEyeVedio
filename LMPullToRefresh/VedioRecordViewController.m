//
//  VedioRecordViewController.m
//  LMPullToRefresh
//
//  Created by Tim Geng on 4/30/15.
//  Copyright (c) 2015 GF. All rights reserved.
//

#import "VedioRecordViewController.h"

@interface VedioRecordViewController ()

@end

@implementation VedioRecordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setBarStyle:UIBarStyleBlack];
//    self.navigationController.navigationBar.barTintColor = [UIColor blackColor];
//    self.navigationController.navigationBar.translucent = NO;
    
    UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancel)];
    [left setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,nil] forState:UIControlStateNormal];
    self.navigationItem.leftBarButtonItem = left;

}

-(void)cancel{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar setBarStyle:UIBarStyleDefault];

//    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
//    self.navigationController.navigationBar.translucent = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
