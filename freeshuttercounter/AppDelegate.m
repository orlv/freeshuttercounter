//
//	AppDelegate.m
//	freeshuttercounter
//
//	Created by oleg on 20.03.16.
//	Copyright © 2016 Oleg Orlov. All rights reserved.
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


#import "AppDelegate.h"
#import <Appkit/NSAlert.h>

@interface AppDelegate ()

@end

@implementation AppDelegate


/* 	check if we in /Applications folder */
bool check_installed()
{
	if(![[[[NSBundle mainBundle] bundlePath] stringByDeletingLastPathComponent]  isEqual: @"/Applications"])
		return false;
	return true;
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application
	if(!check_installed()){
		NSAlert *alert = [[NSAlert alloc] init];
		[alert addButtonWithTitle:@"Quit"];
		[alert setMessageText:@"Warning"];
		[alert setInformativeText:@"Please copy this app into the /Applications folder."];
		[alert setAlertStyle:NSWarningAlertStyle];
		[alert runModal];
		
		[[NSApplication sharedApplication] terminate:nil];
	}
}



-(BOOL) applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)app {
    return YES;
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}

@end
