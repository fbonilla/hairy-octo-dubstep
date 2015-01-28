//
//  pointageViewController.m
//  ipad-test
//
//  Created by Fredy Alexander Bonilla on 2015-01-28.
//  Copyright (c) 2015 Fredy Alexander Bonilla. All rights reserved.
//

#import "pointageViewController.h"
#import "ParticipantsTableViewController.h"
#import "ParticipantItem.h"

@interface pointageViewController ()

- (void)configureView;

@end

@implementation pointageViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) configureView{
    
    //ParticipantsTableViewController *sourceTable =[[ParticipantsTableViewController alloc]init];
    
    //self.arrayNextParticipants = sourceTable.arrayParticipants;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.arrayNextParticipants count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"nextParticipants"];
    // Configure the cell
    ParticipantItem *participantItem = [self.arrayNextParticipants objectAtIndex:indexPath.row];
    
    //On combine le prenom, nom et pays du participant.
    
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@ %@, %@", participantItem.itemPrenom, participantItem.itemNomFamille, participantItem.itemPays];
    
    return cell;
    
}

@end
