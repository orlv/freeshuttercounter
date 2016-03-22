//
//  freeshuttercounter.c
//  freeshuttercounter
//
//  Created by oleg on 20.03.16.
//  Copyright © 2016 Oleg Orlov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Appkit/NSRunningApplication.h>
#include <gphoto2/gphoto2-camera.h>


NSString *camera_get_config(Camera *camera, GPContext *context, const char *key)
{
	CameraWidget *widget = NULL;
	CameraWidget *child = NULL;
	CameraWidgetType type;
	char *value;
	
	if (gp_camera_get_config(camera, &widget, context) < GP_OK)
		return @"gp_camera_get_config failed.\n";
	
	if ((gp_widget_get_child_by_name(widget, key, &child) < GP_OK) && (gp_widget_get_child_by_label(widget, key, &child) < GP_OK)) {
		gp_widget_free(widget);
		return @"gp_widget_get_child failed.\n";
	}
	
	if (gp_widget_get_type(child, &type) < GP_OK) {
		gp_widget_free(widget);
		return @"gp_widget_get_type failed.\n";
	}
	
	switch (type) {
		case GP_WIDGET_MENU:
		case GP_WIDGET_TEXT:
		case GP_WIDGET_RADIO:
			break;
		default:
			gp_widget_free(widget);
			return @"widget has bad type.\n";
	}
	
	if (gp_widget_get_value(child, &value) < GP_OK) {
		gp_widget_free(widget);
		return @"gp_widget_get_value failed.\n";
	}

	NSString *out = [NSString stringWithUTF8String:value];
	gp_widget_free(widget);
	return out;
}



/* Kill the process PTPCamera  */
void kill_PTPCamera()
{
	if ([NSRunningApplication respondsToSelector:@selector(runningApplicationsWithBundleIdentifier:)]) {
		for (NSRunningApplication *app in [NSRunningApplication runningApplicationsWithBundleIdentifier:@"com.apple.PTPCamera"]) {
			[app forceTerminate];
		}
	}
}

NSString * camera_get_info()
{
	Camera		*camera;
	GPContext	*context;
	
	NSMutableString *output = [[NSMutableString alloc] initWithString:@""];
		
	kill_PTPCamera();
	
	context = gp_context_new();
	gp_camera_new(&camera);
	
	if(gp_camera_init(camera, context) < GP_OK) {
		[output appendString:@"No camera detected.\nTry again."];
		gp_camera_free(camera);
		return output;
	}
	
	[output appendFormat:@"%@ \n", camera_get_config(camera, context, "cameramodel")];
	//[output appendFormat:@"Version: %@\n", camera_get_config(camera, context, "deviceversion")];
	[output appendFormat:@"Shutter count: %@", camera_get_config(camera, context, "shuttercounter")];
	
	gp_camera_exit(camera, context);
	gp_camera_free(camera);
	gp_context_unref(context);
	
	return output;
}