//
//  ViewController.m
//  freeshuttercounter
//
//  Created by oleg on 20.03.16.
//  Copyright © 2016 Oleg Orlov. All rights reserved.
//

#import "ViewController.h"
#import <Appkit/NSAlert.h>

@implementation ViewController

NSString * camera_get_info();

- (IBAction)button_get_camera_data:(id)sender {
    [self.output setStringValue:camera_get_info()];

	[self.output selectText:self];
	[[self.output currentEditor] setSelectedRange:NSMakeRange([[self.output stringValue] length], 0)];
}

- (IBAction)button_homepage:(id)sender {
    NSURL *url = [NSURL URLWithString:@"http://freeshuttercounter.oleg-orlov.com"];
    [[NSWorkspace sharedWorkspace] openURL:url];
}


- (void)viewDidLoad {
    [super viewDidLoad];

}


- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}



@end
