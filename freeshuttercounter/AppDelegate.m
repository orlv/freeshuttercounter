//
//  AppDelegate.m
//  freeshuttercounter
//
//  Created by oleg on 20.03.16.
//  Copyright © 2016 Oleg Orlov. All rights reserved.
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
