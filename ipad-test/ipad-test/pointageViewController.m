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

- (IBAction)buttonDisplay:(id)sender;
- (IBAction)buttonPenality:(id)sender;
- (IBAction)buttonDNF:(id)sender;

@property (weak, nonatomic) IBOutlet UILabel *clockDisplay;
@property (weak, nonatomic) IBOutlet UILabel *finishTimeNoPenalty;
@property (weak, nonatomic) IBOutlet UILabel *penaltyCount;
@property (weak, nonatomic) IBOutlet UILabel *finalTimeWithPenalty;
@property (weak, nonatomic) IBOutlet UILabel *runtimePenaltyCount;
@property (weak, nonatomic) IBOutlet UIButton *editStartButton;
@property (weak, nonatomic) IBOutlet UIButton *editDNFButton;

@property (weak, nonatomic) IBOutlet UILabel *JoueurDossard;
@property (weak, nonatomic) IBOutlet UIImageView *JoueurDrapeauImg;
@property (weak, nonatomic) IBOutlet UILabel *JoueurPrenomNom;
@property (weak, nonatomic) IBOutlet UILabel *JoueurDrapeauNom;

- (void)configureView;

@end

@implementation pointageViewController{
    
    bool start;
    bool DidNotFinish;
    NSTimeInterval timeInterval;
    NSTimeInterval officialTime;
    int minutes;
    int seconds;
    int milliseconds;
    int penaltyCountVar;
    int rowNo;
    ParticipantItem *participantItem;
    
}

@synthesize arrayNextParticipants;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Initialisation des parametres
    self.clockDisplay.text = @"00 : 00 : 000";
    start = false;
    
    participantItem = nil;

}

- (void) update{
    
    if(start == false)
    {
        return;
    }
    
    // Verification de penalites
    if(penaltyCountVar > 0)
    {
        if(penaltyCountVar > 2)
        {
            DidNotFinish = true;
            self.runtimePenaltyCount.text = @"-";
            [self endPerfomanceDNF];
        }
        else
        {
            self.runtimePenaltyCount.text = [NSString stringWithFormat:@"%u", penaltyCountVar*30];
        }
        
    }
    
    // Parametres de chronometre
    NSTimeInterval currentTime = [NSDate timeIntervalSinceReferenceDate];
    NSTimeInterval elapsedTime = currentTime - timeInterval;
    officialTime = elapsedTime;
    
    minutes         = (int)(elapsedTime / 60.0);
    seconds         = (int)(elapsedTime = elapsedTime - (minutes * 60.0));
    milliseconds    = (elapsedTime - seconds)*1000;
    
    // Affichage du chronometre avec delai de 0.01
    self.clockDisplay.text = [NSString stringWithFormat:@"%02u : %02u : %03u", minutes, seconds, milliseconds];
    [self performSelector:@selector(update) withObject:(self) afterDelay:0.01];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)saveTime {
    
    // Enregistre temps officiel
    participantItem.itemTime = officialTime + participantItem.itemTime;
    NSLog(@"Temps enregistre: %lf", participantItem.itemTime);
    
    // Logique du tableau a faire dans arrayMeneur
    
    // Si 1er place inferieur ou null
    // Ecrase cellule
    
    // Si 2e place inferieur ou null
    // Ecrase
    
    // Si 3e
    // Ecrase
    
    // Incremente tour
    participantItem.itemTour ++;
    NSLog(@"Tours: %d", participantItem.itemTour);
    
    // Effacer cellule du participant au deuxieme tour
    if((int)participantItem.itemTour == 2)
        [self.arrayNextParticipants removeObjectAtIndex:rowNo];
    
    [self.nextParticipants reloadData];
    
}

- (IBAction)buttonDisplay:(id)sender {
    
    if (start == false) {
        DidNotFinish = false;
        start = true;
        minutes = 0;
        seconds = 0;
        penaltyCountVar = 0;
        
        timeInterval = [NSDate timeIntervalSinceReferenceDate];
        
        [sender setTitle:@"Stop" forState:UIControlStateNormal];
        
        [sender setTitleColor:[UIColor yellowColor] forState:UIControlStateNormal];
        
        self.runtimePenaltyCount.text = [NSString stringWithFormat:@"-"];
        
        [self update];
    }
    else if(start == true){
        
        start = false;
        
        self.finishTimeNoPenalty.text = self.clockDisplay.text;
        
        
        if(penaltyCountVar > 0)
        {
            
            self.penaltyCount.text = [NSString stringWithFormat:@"%u x 30s", penaltyCountVar];
            
            if(penaltyCountVar == 1)
            {
                seconds = seconds + 30;
                self.finalTimeWithPenalty.text = [NSString stringWithFormat:@"%02u : %02u : %03u", minutes, seconds, milliseconds];
            }
            else if(penaltyCountVar == 2)
            {
                minutes = minutes + 1;
                self.finalTimeWithPenalty.text = [NSString stringWithFormat:@"%02u : %02u : %03u", minutes, seconds, milliseconds];
            }
        }
        else
        {
            self.penaltyCount.text = [NSString stringWithFormat:@"-"];
            self.finalTimeWithPenalty.text = self.clockDisplay.text;
        }
        
        // Afficher le resultat final
        self.clockDisplay.text = self.finalTimeWithPenalty.text;
        
        // Enregistre le resultat
        [self saveTime];
        
        [sender setTitle:@"Start" forState: UIControlStateNormal];
        [sender setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
    }

}

- (void) endPerfomanceDNF{
    
    start = false;
    DidNotFinish = false;
    self.finishTimeNoPenalty.text = @"DNF";
    self.finalTimeWithPenalty.text = @"DNF";
    if(penaltyCountVar < 3)
        self.penaltyCount.text = [NSString stringWithFormat:@"%u x 30 s.", penaltyCountVar];
    else
        self.penaltyCount.text = @"DSQ";
    
    // Enregistre le resultat
    [self saveTime];
    
    [self.editStartButton setTitle:@"Start" forState: UIControlStateNormal];
    [self.editStartButton  setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
}

- (IBAction)buttonPenality:(id)sender {
    
    if(start == true)
    {
        penaltyCountVar = penaltyCountVar + 1;
    }
}

- (IBAction)buttonDNF:(id)sender {
    
    if(DidNotFinish == false)
    {
        [self endPerfomanceDNF];
    }
}

- (void) configureView{
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
//    if(tableView == self.meneursParticipants)
//        return 3;
//    else
        return [self.arrayNextParticipants count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"nextParticipants"];
    // Configure the cell
    participantItem = [self.arrayNextParticipants objectAtIndex:indexPath.row];
    
    //On combine le prenom, nom et pays du participant.
    //ParticipantItem *participant = [arrayNextParticipants objectAtIndex:0];
    NSLog(@"Prenom%@",participantItem.itemPrenom);
    
    NSString *infoParticipant = [NSString stringWithFormat:@"%@ %@", participantItem.itemPrenom, participantItem.itemNomFamille];
    
    if(infoParticipant.length){
        cell.textLabel.text = infoParticipant;
        cell.detailTextLabel.text = [NSString stringWithFormat:@"#%@", participantItem.itemNumero];
        cell.imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png", participantItem.itemPays]];
    }
    else{
        cell.textLabel.text = @"";
        cell.detailTextLabel.text = @"";
        cell.imageView.image = [UIImage imageNamed:@"blank.png"];
    }
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    rowNo = (int)indexPath.row;
    
    participantItem = [self.arrayNextParticipants objectAtIndex:indexPath.row];
    
    NSLog(@"%@", participantItem.itemNumero);
    
    // Affichage du joueur selectionne
    self.JoueurDossard.text = participantItem.itemNumero;
    self.JoueurDrapeauImg.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png",participantItem.itemPays]];
    self.JoueurDrapeauNom.text = participantItem.itemPays;
    self.JoueurPrenomNom.text = [NSString stringWithFormat:@"%@ %@", participantItem.itemPrenom, participantItem.itemNomFamille];

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

@end
