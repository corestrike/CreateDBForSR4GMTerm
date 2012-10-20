//
//  ViewController.m
//  CreateDatabaseForSR4GMTerm
//
//  Created by corestrike on 2012/10/20.
//  Copyright (c) 2012年 corestrikelab. All rights reserved.
//

#import "ViewController.h"
#import "SqliteDB.h"
#import "DocumentReader.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    /* database */
    SqliteDB* db = [[SqliteDB alloc] init];
    [db initializeDatabaseIfNeeded];
    [db release];
    
    [DocumentReader insertInitialData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
