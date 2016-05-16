//
//  MyGMSMarker.m
//  Maps-Google
//
//  Created by Emiko Clark on 5/12/16.
//  Copyright © 2016 Aditya Narayan. All rights reserved.
//

#import "MyGMSMarker.h"

@implementation MyGMSMarker

-(id)init {
    
    if(self = [super init]) {
        return self;
    }
    return nil;
}

-(NSString *)description {
    
    return [NSString stringWithFormat:@">>:title:%@, address:%@, phoneNo:%@\nposition:%f, %f \nwebsite:%@  \n Animation:%u, placeID:%@\nobjectID:%@",
        self.title, self.address, self.phoneNumber, self.position.latitude, self.position.longitude, self.website, self.appearAnimation,self.placeID, self.objectID];
}

-(BOOL) isEqual:(id)object {
    
    MyGMSMarker *myMarker = (MyGMSMarker *)object;
    
    if (self.objectID == myMarker.objectID) {
        return YES;
    }
    return NO;
}

-(NSUInteger)hash {
    return [self.objectID hash];
}
@end
