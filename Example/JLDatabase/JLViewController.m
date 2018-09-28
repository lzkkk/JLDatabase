//
//  JLViewController.m
//  JLDatabase
//
//  Created by lzkkk on 09/28/2018.
//  Copyright (c) 2018 lzkkk. All rights reserved.
//

#import "JLViewController.h"
#import "JLTestEntity.h"

@interface JLViewController ()

@end

@implementation JLViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSArray *arr = [JLTestEntity queryAllData];
    for (JLTestEntity *entity in arr) {
        NSLog(@"%@", [entity description]);
    }
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
