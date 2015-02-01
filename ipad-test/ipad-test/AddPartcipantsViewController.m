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
@property (weak, nonatomic) IBOutlet UITextField *Dossard;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *saveButton;

@end

@implementation AddPartcipantsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Definir pays pour picker view
    self.countryNames = @[@"Afghanistan", @"Albania", @"Algeria", @"Andorra", @"Antigua-and-Barbuda",
                          @"Argentina", @"Armenia", @"Australia", @"Austria", @"Azerbaijan", @"Bahamas",
                          @"Bahrain", @"Bangladesh", @"Barbados", @"Belarus", @"Belgium", @"Belize",
                          @"Benin", @"Bhutan", @"Bolivia", @"Bosnia-and-Herzegovina", @"Botswana",
                          @"Brazil", @"Brunei", @"Bulgaria", @"Burkina-Faso", @"Burundi", @"Cambodia",
                          @"Cameroon", @"Canada", @"Cape-Verde", @"Central-African-Republic", @"Chad", @"Chile",
                          @"China", @"Colombia", @"Comoros", @"Congo-(Democratic)", @"Congo-(Republic)",
                          @"Costa-Rica", @"Cote-d'Ivoire", @"Croatia", @"Cuba", @"Cyprus", @"Czech-Republic",
                          @"Denmark", @"Djibouti", @"Dominica", @"Dominican-Republic", @"East-Timor",
                          @"Ecuador", @"Egypt", @"El-Salvador", @"Equatorial-Guinea", @"Eritrea", @"Estonia",
                          @"Ethiopia", @"f.txt", @"Fiji", @"Finland", @"France", @"Gabon", @"Gambia",
                          @"Georgia", @"Germany", @"Ghana", @"Grecee", @"Grenada", @"Guatemala", @"Guinea-Bissau",
                          @"Guinea", @"Guyana", @"Haiti", @"Honduras", @"Hungary", @"Iceland", @"India",
                          @"Indonesia", @"Iran", @"Iraq", @"Ireland", @"Israel", @"Italy", @"Jamaica",
                          @"Japan", @"Jordan", @"Kazakhstan", @"Kenya", @"Kiribati", @"Korea,-North",
                          @"Korea,-South", @"Kosovo", @"Kuwait", @"Kyrgyzstan", @"Laos", @"Latvia",
                          @"Lebanon", @"Lesotho", @"Liberia", @"Libya", @"Liechtenstein", @"Lithuania",
                          @"Luxembourg", @"Macedonia", @"Madagascar", @"Malawi", @"Malaysia", @"Maldives",
                          @"Mali", @"Malta", @"Marshall-Islands", @"Mauritania", @"Mauritius", @"Mexico",
                          @"Micronesia-(Federated)", @"Moldova", @"Monaco", @"Mongolia", @"Montenegro",
                          @"Morocco", @"Mozambique", @"Myanmar", @"Namibia", @"Nauru", @"Nepal",
                          @"Netherlands", @"New-Zealand", @"Nicaragua", @"Niger", @"Nigeria",
                          @"Norway", @"Oman", @"Pakistan", @"Palau", @"Panama", @"Papua-New-Guinea",
                          @"Paraguay", @"Peru", @"Philippines", @"Poland", @"Portugal", @"Qatar",
                          @"Romania", @"Russia", @"Rwanda", @"Saint-Kitts-and-Nevis", @"Saint-Lucia",
                          @"Saint-Vincent-and-the-Grenadines", @"Samoa", @"San-Marino",
                          @"Sao-Tome-and-Principe", @"Saudi-Arabia", @"Senegal", @"Serbia",
                          @"Seychelles", @"Sierra-Leone", @"Singapore", @"Slovakia", @"Slovenia", 
                          @"Solomon-Islands", @"Somalia", @"South-Africa", @"South-Sudan", 
                          @"Spain", @"Sri-Lanka", @"Sudan", @"Suriname", @"Swaziland", @"Sweden", 
                          @"Switzerland", @"Syria", @"Taiwan", @"Tajikistan", @"Tanzania", 
                          @"Thailand", @"Togo", @"Tonga", @"Trinidad-and-Tobago", @"Tunisia", 
                          @"Turkey", @"Turkmenistan", @"Tuvalu", @"Uganda", @"Ukraine", 
                          @"United-Arab-Emirates", @"United-Kingdom", @"United-States-of-America", 
                          @"Uruguay", @"Uzbekistan", @"Vanuatu", @"Vatican-City", @"Venezuela", 
                          @"Vietnam", @"Yemen", @"Zambia", @"Zimbabwe"];

    // Connecter les donnees
    self.picker.dataSource = self;
    self.picker.delegate = self;
    
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
        
        if(self.Dossard.text.length == 0){
            self.Dossard.text = [NSString stringWithFormat:@"%u", arc4random_uniform(101)];
            NSLog(@"Dossard genere: %@", self.Dossard.text);
        }
    
        self.participantItem                = [[ParticipantItem alloc] init];
        self.participantItem.itemPrenom     = self.Prenom.text;
        self.participantItem.itemNomFamille = self.NomFamille.text;
        self.participantItem.itemPays       = self.Pays.text;
        self.participantItem.itemNumero     = self.Dossard.text;
        
    }
    else{
    
        //Message d'erreur
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Certaines informations manquantes"message:[[NSString alloc]initWithFormat:@"Veuillez remplir entrez toutes les informations du participant"] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert show];
    }
}

#pragma mark -
#pragma mark PickerView DataSource

- (NSInteger)numberOfComponentsInPickerView:
(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView
numberOfRowsInComponent:(NSInteger)component
{
    return self.countryNames.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView
             titleForRow:(NSInteger)row
            forComponent:(NSInteger)component
{
    return self.countryNames[row];
}

#pragma mark -
#pragma mark PickerView Delegate
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row
      inComponent:(NSInteger)component
{
    // Mettre a jour le texte avec pays correspondant
    self.Pays.text = self.countryNames[row];
    self.drapeau.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png", self.Pays.text]];
}

@end
