//
//  ViewController.h
//  Maps-Google
//
//  Created by Aditya Narayan on 5/4/16.
//  Copyright © 2016 Aditya Narayan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WebViewController.h"
#import "CustomInfoWindow.h"
#import "GoogleMaps/GoogleMaps.h"

@interface ViewController : UIViewController <GMSMapViewDelegate, CLLocationManagerDelegate, UISearchBarDelegate>

@property (retain, nonatomic) WebViewController *webVC;
@property (strong, nonatomic) CustomInfoWindow *viewController;

@property (nonatomic) CLLocationManager *locationManager;
@property (nonatomic) CLLocation *location;

@property (strong, nonatomic) NSMutableSet *markersNSSet;
@property (strong, nonatomic) NSMutableArray  *markerArray;

@property (weak, nonatomic) IBOutlet GMSMapView *mapView;
@property ( nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UISegmentedControl *mapType;

//Location Methods
-(void) getUsersCurrentLocation;

// Search Bar Tapped Methods
- (void) searchBarSearchButtonClicked:(UISearchBar *)searchBar;

// Marker Methods
-(void) initializeMapWithMyMarkers;
-(void) createMarkerObjectsWithJson:(NSDictionary *)json;

//Map Type Method
- (IBAction) mapTypeTapped:(UISegmentedControl *)sender;


@end

