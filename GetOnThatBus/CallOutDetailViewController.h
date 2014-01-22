//
//  CallOutDetailViewController.h
//  GetOnThatBus
//
//  Created by Jared Friedman on 1/21/14.
//  Copyright (c) 2014 Jared Friedman. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "BusPointAnnotation.h"


@interface CallOutDetailViewController : UIViewController
@property BusPointAnnotation* receivedAnnotation;
@property NSArray *recievedStops;

@end
