//
//  CallOutDetailViewController.m
//  GetOnThatBus
//
//  Created by Jared Friedman on 1/21/14.
//  Copyright (c) 2014 Jared Friedman. All rights reserved.
//

#import "CallOutDetailViewController.h"

@interface CallOutDetailViewController ()
{
    __weak IBOutlet UILabel *addressLabel;
    __weak IBOutlet UILabel *busRouteLabel;
    __weak IBOutlet UILabel *intermodalLabel;
}

@end

@implementation CallOutDetailViewController
@synthesize receivedAnnotation, recievedStops;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = receivedAnnotation.title;
    busRouteLabel.text = receivedAnnotation.myDictionary[@"routes"];

    if (receivedAnnotation.myDictionary[@"inter_modal"]) {
        intermodalLabel.text = receivedAnnotation.myDictionary[@"inter_modal"];
    } else {
        intermodalLabel.text = @"N/A";
    }
    
    CLGeocoder*  geoCoder = [CLGeocoder new];
    CLLocation* location = [[CLLocation alloc] initWithLatitude:receivedAnnotation.coordinate.latitude longitude:receivedAnnotation.coordinate.longitude];

    [geoCoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
        if (error) {
            NSLog(@"%@", error);
        } else {
            CLPlacemark *placemark;
            placemark = placemarks[0];
            addressLabel.text = [NSString stringWithFormat:@"%@", [placemark name]];
        }
    }];
    
    
       

}

@end
