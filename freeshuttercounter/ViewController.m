//
//  ViewController.m
//  freeshuttercounter
//
//  Created by oleg on 20.03.16.
//  Copyright © 2016 Oleg Orlov. All rights reserved.
//
//	This program is free software: you can redistribute it and/or modify
//	it under the terms of the GNU General Public License as published by
//	the Free Software Foundation, either version 3 of the License, or
//	(at your option) any later version.
//
//	This program is distributed in the hope that it will be useful,
//	but WITHOUT ANY WARRANTY; without even the implied warranty of
//	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//	GNU General Public License for more details.
//
//	You should have received a copy of the GNU General Public License
//	along with this program.  If not, see <http:www.gnu.org/licenses/>.
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
