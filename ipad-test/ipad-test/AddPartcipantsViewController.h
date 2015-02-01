//
//  AddPartcipantsViewController.h
//  ipad-test
//
//  Created by Fredy Alexander Bonilla on 2015-01-26.
//  Copyright (c) 2015 Fredy Alexander Bonilla. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ParticipantItem.h"

@interface AddPartcipantsViewController : UIViewController <UIPickerViewDelegate, UIPickerViewDataSource>
@property (weak, nonatomic) IBOutlet UIPickerView *picker;

@property ParticipantItem *participantItem;
@property (strong, nonatomic) NSArray *countryNames;
@property (weak, nonatomic) IBOutlet UIImageView *drapeau;

@end
