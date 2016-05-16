//
//  ViewController.m
//  Maps-Google
//
//  Created by Aditya Narayan on 5/4/16.
//  Copyright © 2016 Aditya Narayan. All rights reserved.
//

#import "ViewController.h"
#import "MyGMSMarker.h"
#import "CustomInfoWindow.h"

@interface ViewController () <GMSMapViewDelegate>
@end

@implementation ViewController 

//define my search radius
#define MY_RADIUS 1000

//keys for google API
#define KEY1 @"AIzaSyASrQKxwyM07u1yA70ubdCyzXmZeL2IEvQ"
#define KEY2 @"AIzaSyBRhACru2HT9Bot9TY57KtMfPdzvBpBJy8"

#pragma mark ViewController Methods

-(void) viewDidLoad {
    [super viewDidLoad];
    
    self.markersNSSet = [[NSMutableSet alloc] init];
    self.markerArray = [[NSMutableArray alloc]init];
    
    [self getUsersCurrentLocation];
    
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:  self.location.coordinate.latitude longitude: self.location.coordinate.longitude zoom:16.5];
    
    self.mapView.camera = camera;
   [self.mapView addObserver:self forKeyPath:@"myLocation" options:0 context:nil];

    self.searchBar.delegate = self;
    self.mapView.delegate = self;
    self.mapView.myLocationEnabled = YES;
    
    self.mapView.settings.myLocationButton = YES;
    [self.mapView setMinZoom:5 maxZoom:25];
    self.mapView.settings.compassButton = YES;
    
    self.mapView.mapType = kGMSTypeNormal;
    
    //adds TurnToTech marker on map
    //[self initializeMapWithMyMarkers];
    
}

#pragma mark Location Methods

-(void) getUsersCurrentLocation {
    
    //get user's current location
    self.locationManager = [[CLLocationManager alloc] init];
    [self.locationManager requestWhenInUseAuthorization];
    [self.locationManager setDelegate:self];
    [self.locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
    [self.locationManager startUpdatingLocation];
    self.location = [[CLLocation alloc] initWithLatitude:self.locationManager.location.coordinate.latitude longitude:self.locationManager.location.coordinate.longitude];
    
}


-(void) locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    self.location = [locations lastObject];
}

-(void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    
/*  
     //helper method that works with didUpdateLocations method
     //when uncommented, map will keep zooming to your location even when you explore markers
     //outside of view of user location - 
     //-it becomes annoying when there are many markers
 
    if([keyPath isEqualToString:@"myLocation"]) {
        CLLocation *location = [object myLocation];
        
        CLLocationCoordinate2D target = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude);
        
        [self.mapView animateToLocation:target];
        [self.mapView animateToZoom:16.5];
    }
*/
}


#pragma mark Search Bar Tapped Methods

-(void) searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    
    //hide keyboard after typing search in search bar
    [searchBar resignFirstResponder];
    
    //clear nsset array
    [self.markersNSSet removeAllObjects];
    [self.markerArray removeAllObjects];
    [self.mapView clear];
    
    //create first of 2 queries
    NSString *key = @"AIzaSyASrQKxwyM07u1yA70ubdCyzXmZeL2IEvQ";
    NSString *convertedSearchString = [self.searchBar.text stringByReplacingOccurrencesOfString:@" " withString:@"%20" ];
    
    //create query string
    NSString *query1 = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/search/json?location=%f,%f&radius=%d&name=%@&sensor=true&key=%@",  self.location.coordinate.latitude, self.location.coordinate.longitude,MY_RADIUS,convertedSearchString,key];
    NSLog(@"query1: %@\n\n",query1);
    
    //create URL request
    NSURL * url  = [[NSURL alloc]initWithString:query1];
    
    NSURLSessionDataTask *downloadTask = [[NSURLSession sharedSession] dataTaskWithURL: url
         completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
             
         [[NSOperationQueue mainQueue] addOperationWithBlock:^{
             
             if (error == nil) {
                 //parse json to dictionary
                 NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                 
                 //create markers for each result in json
                 [self createMarkerObjectsWithJson: json];

                 //create marker pins for data
                 [self setUpAndDrawMarkerData];
             }
         }];
     }];
    [downloadTask resume];
}


#pragma mark Marker Methods

-(void) initializeMapWithMyMarkers {
    
    // initializes TTTech marker and adds to array
    MyGMSMarker *marker = [[MyGMSMarker alloc] init];
    marker.position = CLLocationCoordinate2DMake(40.741434, -73.990039);
    marker.title = @"TurnToTech";
    marker.address = @"NY, New York";
    marker.icon = [UIImage imageNamed:@"tttlogo.png"];
    marker.map = self.mapView;
    marker.appearAnimation = kGMSMarkerAnimationPop;
    
    //add marker to nsarray
    [self.markerArray addObject:marker];
    
    [self setUpAndDrawMarkerData];
}


-(void) createMarkerObjectsWithJson:(NSDictionary *)json {
    
    //loop through json data's results and set marker properties for each of them
    for (NSDictionary *markerData in json[@"results"]) {
        
        MyGMSMarker *newMarker = [[MyGMSMarker alloc]init];
    
        newMarker.position = CLLocationCoordinate2DMake(
            [markerData[@"geometry"][@"location"][@"lat"] doubleValue],
            [markerData[@"geometry"][@"location"][@"lng"] doubleValue]);
        
        UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:markerData[@"icon"]]] scale:2.5];
        
        newMarker.infoWindowIcon = image;
        newMarker.title = markerData[@"name"];
        newMarker.address = markerData[@"vicinity"];
        newMarker.phoneNumber = markerData[@"formatted_phone_number"];
        newMarker.website = markerData[@"website"];
        newMarker.placeID = markerData[@"place_id"];
        newMarker.objectID = markerData[@"id"];
        newMarker.appearAnimation = kGMSMarkerAnimationPop;
        newMarker.map = self.mapView;

        [self.markerArray addObject:newMarker];
    }
    [self setUpAndDrawMarkerData];
}

-(void) setUpAndDrawMarkerData {
    
    //initialize nsset with all the marker objects from json and to eliminate duplicate markers
    self.markersNSSet = [NSMutableSet setWithArray:self.markerArray];
    
    //draw markers onto the map
    for (MyGMSMarker *marker in self.markersNSSet) {
        if (marker.map == nil) {
            marker.map = self.mapView;
        }
    }
}


-(BOOL) mapView:(GMSMapView *)mapView didTapMarker:(MyGMSMarker *)marker {
    
    //create 2nd request with placesID to get website and phoneNumber info
    NSString *query2 = [NSString stringWithFormat: @"https://maps.googleapis.com/maps/api/place/details/json?placeid=%@&key=%@",marker.placeID,KEY1];
    NSLog(@"\nquery2: %@\n",query2);
    
    NSURL *url = [NSURL URLWithString:query2];
    
    NSURLSessionDataTask *dataTask = [[NSURLSession sharedSession] dataTaskWithURL: url completionHandler: ^(NSData *data, NSURLResponse *response, NSError *error ) {
        
        [[NSOperationQueue mainQueue] addOperationWithBlock:^ {
            
            if (error == nil) {
                // json to dictionary
                NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                // parse json for more info
                
                //populate infoWindow with placeID details
                marker.phoneNumber = json[@"result"][@"formatted_phone_number"];
                marker.website = json[@"result"][@"website"];
                
                CustomInfoWindow *infoWindow =  [[[NSBundle mainBundle] loadNibNamed:@"CustomInfoWindow" owner:self options:nil] objectAtIndex:0];
                
                //update infoWindow with new marker info
                infoWindow.name.text = marker.title;
                infoWindow.address.text = marker.address;
                infoWindow.phoneNumber.text = marker.phoneNumber;
                infoWindow.iconView.image = marker.infoWindowIcon;
                
                //updates the info window with the new marker info
                if (self.mapView.selectedMarker != nil) {
                    if (self.mapView.selectedMarker == marker) {
                        self.mapView.selectedMarker = nil;
                        self.mapView.selectedMarker =  marker;
                    }
                }
            }
        }];
    }];
    [dataTask resume];
    
    return NO;
}



#pragma mark InfoWindow Methods

-(UIView *) mapView:(GMSMapView *)mapView markerInfoWindow:(MyGMSMarker *)marker {
    //delegate method to setup infoWindow from marker info
    CustomInfoWindow *infoWindow =  [[[NSBundle mainBundle] loadNibNamed:@"CustomInfoWindow" owner:self options:nil] objectAtIndex:0];
    
    infoWindow.name.text = marker.title;
    infoWindow.address.text = marker.address;
    infoWindow.phoneNumber.text = marker.phoneNumber;
    infoWindow.iconView.image = marker.infoWindowIcon;
    marker.tracksInfoWindowChanges = YES;

    return infoWindow;
}


-(void) mapView:(GMSMapView *)mapView didTapInfoWindowOfMarker:(MyGMSMarker *)marker {

    //delegate method that goes to the web view controller and displays webpage when infoWindow is tapped
    self.webVC = [[WebViewController alloc]init];
    self.webVC.displayURL =   marker.website;
    self.webVC.title = marker.title;
    [self.navigationController pushViewController: self.webVC animated:YES];
}


#pragma mark Map Type Method

-(IBAction) mapTypeTapped:(UISegmentedControl *)sender {
    
    //changes map type to normal, hybrid or satellite
    switch (sender.selectedSegmentIndex) {
        case 0:
                self.mapView.mapType = kGMSTypeNormal;
                break;
        case 1:
                self.mapView.mapType = kGMSTypeTerrain;
                break;
        case 2:
                self.mapView.mapType = kGMSTypeSatellite;
                break;
            
        default:
            break;
    }

}

#pragma mark Misc Methods
-(BOOL) prefersStatusBarHidden {
    return YES;
}

-(void) didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end


