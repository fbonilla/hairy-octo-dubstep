//
//  ParticipantItem.h
//  ipad-test
//
//  Created by Fredy Alexander Bonilla on 2015-01-26.
//  Copyright (c) 2015 Fredy Alexander Bonilla. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ParticipantItem : NSObject

//Attributs d'un participants: Prenom, nom de famille et le pays qu'il represente
@property NSString *itemPrenom;
@property NSString *itemNomFamille;
@property NSString *itemPays;
@property NSString *infoComplete;
@property NSString *itemPosition;

//Numero de dossard
@property NSString *itemNumero;

//Temps cumulatif
@property double itemTime;
@property int itemMinutes;

//Nombre de tours
@property int itemTour;

@end
