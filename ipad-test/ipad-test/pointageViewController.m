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
@property (weak, nonatomic) IBOutlet UILabel *JoueurPosition;

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
@synthesize arrayMeneurParticipants;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Initialisation des parametres
    self.clockDisplay.text = @"00 : 00 : 000";
    start = false;
    
    participantItem = nil;
    
   arrayMeneurParticipants = [[NSMutableArray alloc] init];
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
            self.runtimePenaltyCount.text = [NSString stringWithFormat:@"Penalite: + %u secondes", penaltyCountVar*30];
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
    
    if([self.arrayNextParticipants objectAtIndex:0] != nil){
        
        if(DidNotFinish)
        {
            DidNotFinish = false;
            participantItem.itemTime = participantItem.itemTime + 56000;
            participantItem.itemMinutes += floor(participantItem.itemTime / 60);
            
        }
        else{
            double ns = participantItem.itemTime;
            
            participantItem.itemTime = (double)officialTime + (double)(penaltyCountVar * 30)+ ns;
            participantItem.itemMinutes += floor(participantItem.itemTime / 60);
        }
        
       // participantItem.itemTime = officialTime;
//        NSLog(@"Temps enregistre: %lf", participantItem.itemTime);
        
        // Logique du tableau a faire dans arrayMeneur
        [self orderWinnersParticipantArray];
      
        
        
        if(participantItem.itemTour == 2)
        {
            [self.arrayNextParticipants removeObjectAtIndex:0];
        }
        else
        {
            ParticipantItem* part = [self.arrayNextParticipants objectAtIndex:0];
            [self.arrayNextParticipants removeObjectAtIndex:0];
            [self.arrayNextParticipants insertObject:part atIndex:[self.arrayNextParticipants count]];
        }
        
        // Afficher gagnant lorsque liste participant est vide
        if(self.arrayNextParticipants.count == 0){
            [self afficherGagnant];
        }
        
        [self.nextParticipants reloadData];
        
    }
    
}

-(void)orderWinnersParticipantArray
{
    
    
   if(self.arrayMeneurParticipants.count != 0)
   {
       //remove twins
       for(int j = 0; j< self.arrayMeneurParticipants.count; j++)
       {
           ParticipantItem *part = [arrayMeneurParticipants objectAtIndex:j];
          
           if(participantItem.itemNumero == part.itemNumero)
           {
               
               [self.arrayMeneurParticipants removeObjectAtIndex:j];
               
           }
       }
       
       if(arrayMeneurParticipants.count == 0)
       {
            [self.arrayMeneurParticipants addObject:participantItem];
       }
       else
       {
       
       //pour la taille de l'array inserer...
       for(int i =0; i < self.arrayMeneurParticipants.count; i++)
       {
            ParticipantItem *part = [self.arrayMeneurParticipants objectAtIndex:i];
           
            if((participantItem.itemTime + (double)(participantItem.itemMinutes *60)) < (part.itemTime + (double)(part.itemMinutes *60)))
            {
                //if(i<2)
               // {
                    [self.arrayMeneurParticipants insertObject:participantItem atIndex:i];
             //   }
                
               
                break;
            }
            else if( i == (self.arrayMeneurParticipants.count -1))
            {
                [self.arrayMeneurParticipants insertObject:participantItem atIndex:(i+1)];
                break;
            }
           
        }
       }
       
       
   }
   else
   {
       [self.arrayMeneurParticipants addObject:participantItem];
   }
    
   [self.meneursParticipants reloadData];
    
   [self UpdateParticipantPosition];
    
    self.JoueurPosition.text = participantItem.itemPosition;
}

-(void)UpdateParticipantPosition
{
    if(arrayMeneurParticipants.count !=0)
    {
        for(int i =0 ; i < arrayMeneurParticipants.count; i++)
        {
            ParticipantItem* part = [arrayMeneurParticipants objectAtIndex:i];
            part.itemPosition = [NSString stringWithFormat:@"%U", i+1];

        }
    }
}


-(void)selectCurrentParticipant
{
    participantItem = [self.arrayNextParticipants objectAtIndex:0];
    
    NSLog(@"Dossard: %@", participantItem.itemNumero);
    
    // Affichage du joueur selectionne
    self.JoueurDossard.text = participantItem.itemNumero;
    self.JoueurDrapeauImg.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png",participantItem.itemPays]];
    self.JoueurDrapeauNom.text = participantItem.itemPays;
    self.JoueurPrenomNom.text = [NSString stringWithFormat:@"%@ %@", participantItem.itemPrenom, participantItem.itemNomFamille];
    self.JoueurPosition.text = participantItem.itemPosition;
    
    participantItem.itemTour ++;
}

- (IBAction)buttonDisplay:(id)sender {
    
    if (start == false) {
       
        
        if(self.arrayNextParticipants.count == 0)
        {
            //Message d'erreur
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Il n'y a pas assez de participant prêt"message:[[NSString alloc]initWithFormat:@"Veuillez ajouter des participants a la competition + ou appuyer sur Begin"] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            [alert show];
            return;
        }
        else
        {
            DidNotFinish = false;
            start = true;
            minutes = 0;
            seconds = 0;
            penaltyCountVar = 0;
            [self selectCurrentParticipant];
            
        }
        
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
        
//         Enregistre le resultat
        if(arrayNextParticipants.count !=0 )
        {
             [self saveTime];
        }
       
        
        [sender setTitle:@"Start" forState: UIControlStateNormal];
        [sender setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
    }

}

- (void) endPerfomanceDNF{
    
    start = false;
    self.finishTimeNoPenalty.text = @"DNF";
    self.finalTimeWithPenalty.text = @"DNF";
    if(penaltyCountVar < 3)
        self.penaltyCount.text = [NSString stringWithFormat:@"%u x 30 s.", penaltyCountVar];
    else
        self.penaltyCount.text = @"DSQ";
    
    // Enregistre le resultat
    if(arrayNextParticipants.count !=0)
    {
        [self saveTime];
    }
    
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
    
    if(DidNotFinish == false && arrayNextParticipants.count != 0 && start == true)
    {
        DidNotFinish =true;
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
    if(tableView == self.meneursParticipants)
        return [self.arrayMeneurParticipants count];
    else
    {
        return [self.arrayNextParticipants count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
   
    UITableViewCell *cell=nil;
    
    if(tableView == self.meneursParticipants)
    {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"meneursParticipants"];
        
        // Configure the cell
        ParticipantItem *participantIt = [self.arrayMeneurParticipants objectAtIndex:indexPath.row];
        
        cell.backgroundColor = [UIColor clearColor];
        cell.contentView.backgroundColor = [UIColor clearColor];
        
        //On combine le prenom et nom du participant.
        cell.textLabel.text = [NSString stringWithFormat:@"%@ %@", participantIt.itemPrenom, participantIt.itemNomFamille];
        int minutesF = 0;
        int minutesC = 0;
        int secondsF = 0;
        int millisecondsF = 0;
        
         minutesF        = (int)(participantIt.itemTime / 60.0);
         minutesC        = participantIt.itemMinutes;
         secondsF        = (int)(participantIt.itemTime = participantIt.itemTime - (minutesF * 60.0));
         millisecondsF   = (participantIt.itemTime - secondsF)*1000;
        
        // Le numero de dossard ira dans la section detail
        if(minutesC == 933)
        {
             cell.detailTextLabel.text = [NSString stringWithFormat:@"DNF #%@", participantIt.itemNumero];
        }
        else
        {
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%02u : %02u : %03u", minutesC , secondsF, millisecondsF];
        }
        
        // Rajouter le drapeau du pays
        cell.imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png", participantIt.itemPays]];
        
        return cell;
    }
    else if(arrayNextParticipants.count != 0)
    {
    cell = [tableView dequeueReusableCellWithIdentifier:@"nextParticipants"];
    // Configure the cell
    participantItem = [self.arrayNextParticipants objectAtIndex:indexPath.row];
    cell.backgroundColor = [UIColor clearColor];
    cell.contentView.backgroundColor = [UIColor clearColor];
    
    //On combine le prenom, nom et pays du participant.
    //ParticipantItem *participant = [arrayNextParticipants objectAtIndex:0];
    NSLog(@"Prenom: %@",participantItem.itemPrenom);
    
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
    }
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

/*
 * Affichage de gagnant
 * P.S: Code affreusement optimise -- Manque de temps
 */
-(void) afficherGagnant
{
    
    ParticipantItem *premier 	= [self.arrayMeneurParticipants objectAtIndex:0];
    ParticipantItem *deuxieme 	= [self.arrayMeneurParticipants objectAtIndex:1];
    ParticipantItem *troisieme 	= [self.arrayMeneurParticipants objectAtIndex:2];
    
    NSString *ligne1;
    NSString *ligne2;
    NSString *ligne3;
    
    // Initialise lignes
    // ligne1 = @"1er: Pays | Prenom Nom (#) | Temps"
    
    ligne1 = [NSString stringWithFormat: @"1ere place: %@ | %@ %@ (%@)",
              premier.itemPays,
              premier.itemPrenom,
              premier.itemNomFamille,
              premier.itemNumero];
    ligne2 = [NSString stringWithFormat: @"2e place: %@ | %@ %@ (%@)",
              deuxieme.itemPays,
              deuxieme.itemPrenom,
              deuxieme.itemNomFamille,
              deuxieme.itemNumero];
    ligne3 = [NSString stringWithFormat: @"3e place: %@ | %@ %@ (%@)",
              troisieme.itemPays,
              troisieme.itemPrenom,
              troisieme.itemNomFamille,
              troisieme.itemNumero];
    
    // Verifie positions identiques
    if ( premier.itemPosition == deuxieme.itemPosition )
        ligne2 = [NSString stringWithFormat: @"1ere place: %@ | %@ %@ (%@)",
                  deuxieme.itemPays,
                  deuxieme.itemPrenom,
                  deuxieme.itemNomFamille,
                  deuxieme.itemNumero];
    else if( deuxieme.itemPosition == troisieme.itemPosition )
        ligne3 = [NSString stringWithFormat: @"1ere place: %@ | %@ %@ (%@)",
                  troisieme.itemPays,
                  troisieme.itemPrenom,
                  troisieme.itemNomFamille,
                  troisieme.itemNumero];
    
    if( deuxieme.itemPosition == troisieme.itemPosition )
        ligne3 = [NSString stringWithFormat: @"2e place: %@ | %@ %@ (%@)",
                  troisieme.itemPays,
                  troisieme.itemPrenom,
                  troisieme.itemNomFamille,
                  troisieme.itemNumero];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Gagnants de la competition"
                                                    message:[[NSString alloc]initWithFormat:@"%@\n%@\n%@", ligne1, ligne2, ligne3 ]
                                                   delegate:self 
                                          cancelButtonTitle:@"Ok" 
                                          otherButtonTitles:nil];
    [alert show];
    
}

@end
