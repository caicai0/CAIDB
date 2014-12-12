//
//  ViewController.m
//  pro
//
//  Created by liyufeng on 14/12/12.
//  Copyright (c) 2014年 liyufeng. All rights reserved.
//

#import "ViewController.h"
#import "pro.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString * dic = [pro sqlStringCreatTable:@"abc" class:[UIView class]];
    NSLog(@"%@",dic);
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
