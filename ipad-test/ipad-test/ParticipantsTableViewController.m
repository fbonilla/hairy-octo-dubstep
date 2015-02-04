//
//  ParticipantsTableViewController.m
//  ipad-test
//
//  Created by Fredy Alexander Bonilla on 2015-01-26.
//  Copyright (c) 2015 Fredy Alexander Bonilla. All rights reserved.
//

#import "ParticipantsTableViewController.h"
#import "ParticipantItem.h"
#import "AddPartcipantsViewController.h"
#import "pointageViewController.h"

@interface ParticipantsTableViewController ()

@property (strong, nonatomic) IBOutlet UIBarButtonItem *demarrer;

@end

@implementation ParticipantsTableViewController
@synthesize arrayParticipants;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.arrayParticipants = [[NSMutableArray alloc] init];
    
   // [self loadInitialData];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    // Return the number of rows in the section.
    return [self.arrayParticipants count];
}

//Methode qui permet de retourner a la table en cliquant sur cancel.
- (IBAction)unwindToList:(UIStoryboardSegue *)segue{
    
    AddPartcipantsViewController *source = [segue sourceViewController];
    ParticipantItem *participant = source.participantItem;
    
    if(participant != nil){
        
        [self.arrayParticipants addObject:participant];
        
        [self.tableView reloadData];
        
    }
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ListPrototypeCell" forIndexPath:indexPath];
    
    // Configure the cell
    ParticipantItem *participantItem = [self.arrayParticipants objectAtIndex:indexPath.row];
    cell.backgroundColor = [UIColor clearColor];
    
    //On combine le prenom et nom du participant.
    cell.textLabel.text = [NSString stringWithFormat:@"%@ %@", participantItem.itemPrenom, participantItem.itemNomFamille];
    
    // Le numero de dossard ira dans la section detail
    cell.detailTextLabel.text = [NSString stringWithFormat:@"#%@", participantItem.itemNumero];
    
    // Rajouter le drapeau du pays
    cell.imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png", participantItem.itemPays]];

    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark - Navigation

//In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if(sender != self.demarrer) return;
    
    if([[segue identifier] isEqualToString:@"envoieInfo"]){
       if(arrayParticipants.count > 2){
           pointageViewController *pointage = [segue destinationViewController];
           pointage.arrayNextParticipants = arrayParticipants;
           NSLog(@"Bouton activee");
       }
       //Affiche un message d'erreur si l'on essaie d'envoyer un array vide.
       else{
           UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Participants manquants"message:[[NSString alloc]initWithFormat:@"Veuillez ajouter des participants avant de commencer la compétition"] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
           [alert show];
       }
    }
}
@end
