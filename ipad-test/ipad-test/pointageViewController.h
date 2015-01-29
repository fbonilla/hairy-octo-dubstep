//
//  pointageViewController.h
//  ipad-test
//
//  Created by Fredy Alexander Bonilla on 2015-01-28.
//  Copyright (c) 2015 Fredy Alexander Bonilla. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface pointageViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) IBOutlet UITableView *nextParticipants;
@property (strong, nonatomic) IBOutlet UITableView *meneursParticipants;

@property NSMutableArray *arraySourceParticipants;
@property NSMutableArray *arrayNextParticipants;

@property NSMutableArray *arrayTest;


@end
