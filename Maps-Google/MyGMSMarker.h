//
//  MyGMSMarker.h
//  Maps-Google
//
//  Created by Emiko Clark on 5/12/16.
//  Copyright © 2016 Aditya Narayan. All rights reserved.
//

#import <GoogleMaps/GoogleMaps.h>

@interface MyGMSMarker : GMSMarker

@property (nonatomic) NSString *objectID;
@property (nonatomic) NSString *placeID;
@property (nonatomic) NSString *address;
@property (nonatomic) NSString *website;

@property (nonatomic) UIImage *infoWindowIcon;
@property (nonatomic) NSString *phoneNumber;

-(BOOL) isEqual:(id)object;
-(NSUInteger)hash;
-(NSString*)description;

@end
