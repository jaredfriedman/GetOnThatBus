//
//  ViewController.m
//  GetOnThatBus
//
//  Created by Jared Friedman on 1/21/14.
//  Copyright (c) 2014 Jared Friedman. All rights reserved.
//

#import "ViewController.h"
#import <MapKit/MapKit.h>
#import "CallOutDetailViewController.h"
#import "BusPointAnnotation.h"


@interface ViewController () <MKMapViewDelegate>
{
    __weak IBOutlet MKMapView *myMapView;
    
    NSDictionary* ctaBuses;
    NSArray* stops;
}

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    NSURL* url = [NSURL URLWithString:@"http://dev.mobilemakers.co/lib/bus.json"];
    NSURLRequest* request = [NSURLRequest requestWithURL:url];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        ctaBuses = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&connectionError];
        stops = ctaBuses[@"row"];
    }];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    for (int i = 0; i < stops.count; i++) {
        BusPointAnnotation* annotation = [BusPointAnnotation new];
        NSDictionary* tempDictionary = stops[i];
        annotation.myDictionary = tempDictionary;
        annotation.title = annotation.myDictionary[@"cta_stop_name"];
        annotation.subtitle = annotation.myDictionary[@"routes"];
        annotation.coordinate = CLLocationCoordinate2DMake([annotation.myDictionary[@"latitude"] doubleValue], [annotation.myDictionary[@"longitude"] doubleValue]);
        
        [myMapView addAnnotation:annotation];
    }
}

-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(BusPointAnnotation *)annotation
{
    NSString *CustomAnnotationID;
   
    if ([annotation.myDictionary[@"inter_modal"] isEqualToString:@"Metra"]) {
        CustomAnnotationID = @"MetraAnnotationID";
    } else if ([annotation.myDictionary[@"inter_modal"] isEqualToString:@"Pace"]) {
        CustomAnnotationID = @"PaceAnnotationID";
    } else {
        CustomAnnotationID = @"AnnotationID";
    }
    

    MKAnnotationView* annotationView = [mapView dequeueReusableAnnotationViewWithIdentifier:CustomAnnotationID];
    
    if (annotationView == nil) {
        annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:CustomAnnotationID];
    } else{
        annotationView.annotation = annotation;
    }
    
    
    if ([annotationView.reuseIdentifier isEqualToString:@"AnnotationID"]) {
        annotationView.canShowCallout = YES;
        UIButton *accessoryViewButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        annotationView.rightCalloutAccessoryView = accessoryViewButton;
    }
    if ([annotationView.reuseIdentifier isEqualToString:@"PaceAnnotationID"]) {
        annotationView.canShowCallout = YES;
        UIButton *accessoryViewButton = [UIButton buttonWithType:UIButtonTypeContactAdd];
        annotationView.rightCalloutAccessoryView = accessoryViewButton;
    }
    if ([annotationView.reuseIdentifier isEqualToString:@"MetraAnnotationID"]) {
        annotationView.canShowCallout = YES;
        UIButton *accessoryViewButton = [UIButton buttonWithType:UIButtonTypeInfoLight];
        annotationView.rightCalloutAccessoryView = accessoryViewButton;
    }
    
    return annotationView;
}

-(void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    [self performSegueWithIdentifier:@"CallOutDetailID" sender:view];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(MKAnnotationView*)sender
{
    if ([segue.identifier isEqualToString:@"CallOutDetailID"])
    {
        CallOutDetailViewController* destinationViewController = segue.destinationViewController;
        destinationViewController.receivedAnnotation = sender.annotation;
        destinationViewController.recievedStops = stops;
    }
}

@end
