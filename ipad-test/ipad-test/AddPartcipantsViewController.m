//
//  AddPartcipantsViewController.m
//  ipad-test
//
//  Created by Fredy Alexander Bonilla on 2015-01-26.
//  Copyright (c) 2015 Fredy Alexander Bonilla. All rights reserved.
//

#import "AddPartcipantsViewController.h"

@interface AddPartcipantsViewController ()

@property (weak, nonatomic) IBOutlet UITextField *Prenom;
@property (weak, nonatomic) IBOutlet UITextField *NomFamille;
@property (weak, nonatomic) IBOutlet UITextField *Pays;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *saveButton;


@end

@implementation AddPartcipantsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if (sender != self.saveButton) return;

    if(self.Prenom.text.length > 0 && self.NomFamille.text.length >0 && self.Pays.text.length >0){
    
        self.participantItem = [[ParticipantItem alloc] init];
        self.participantItem.itemPrenom = self.Prenom.text;
        self.participantItem.itemNomFamille = self.NomFamille.text;
        self.participantItem.itemPays = self.Pays.text;
        
    }
    else{
    
        //Message d'erreur
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Certaines informations manquantes"message:[[NSString alloc]initWithFormat:@"Veuillez remplir entrez toutes les informations du participant"] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert show];
    }
}

@end
