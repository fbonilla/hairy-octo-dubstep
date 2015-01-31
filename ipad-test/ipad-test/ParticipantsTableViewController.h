  //
//  ParticipantsTableViewController.h
//  ipad-test
//
//  Created by Fredy Alexander Bonilla on 2015-01-26.
//  Copyright (c) 2015 Fredy Alexander Bonilla. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "pointageViewController.h"

@protocol ParticipantsTableViewControllerDelegate

-(void)passMutableArray:(NSMutableArray*)arrayParticipants;

@end

@interface ParticipantsTableViewController : UITableViewController

@property(nonatomic, retain) NSMutableArray *arrayParticipants;
@property(nonatomic, retain) id<ParticipantsTableViewControllerDelegate> delegate;

- (IBAction)unwindToList:(UIStoryboardSegue *)segue;


@end
