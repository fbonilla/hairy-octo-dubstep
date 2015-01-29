//
//  ParticipantsTableViewController.h
//  ipad-test
//
//  Created by Fredy Alexander Bonilla on 2015-01-26.
//  Copyright (c) 2015 Fredy Alexander Bonilla. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "pointageViewController.h"

@interface ParticipantsTableViewController : UITableViewController

@property NSMutableArray *arrayParticipants;

- (IBAction)unwindToList:(UIStoryboardSegue *)segue;

- (IBAction)envoyerDonnees:(id)sender;

@end
