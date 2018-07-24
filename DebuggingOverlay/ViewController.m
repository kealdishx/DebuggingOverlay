//
//  ViewController.m
//  DebuggingOverlay
//
//  Created by iCeBlink on 2018/7/24.
//  Copyright © 2018年 zakariyyasv. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view, typically from a nib.
}

- (IBAction)buttonClickEvent:(UIButton *)sender {
  id cls = NSClassFromString(@"DebuggingOverlay");
  [cls performSelector:NSSelectorFromString(@"toggleOverlay")];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}


@end
