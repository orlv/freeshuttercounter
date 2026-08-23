//
//  freeshuttercounter.c
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

#import <Foundation/Foundation.h>
#import <Appkit/NSRunningApplication.h>
#include <gphoto2/gphoto2-camera.h>
#include <gphoto2/gphoto2-abilities-list.h>
#include <gphoto2/gphoto2-port-info-list.h>
#include <gphoto2/gphoto2-list.h>


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

int init_camera_with_fallback(Camera **camera, GPContext *context)
{
	gp_camera_new(camera);
	int ret = gp_camera_init(*camera, context);
	if (ret >= GP_OK) {
		return ret;
	}
	
	gp_camera_free(*camera);
	*camera = NULL;
	
	GPPortInfoList *portinfolist = NULL;
	gp_port_info_list_new(&portinfolist);
	gp_port_info_list_load(portinfolist);
	
	CameraAbilitiesList *abilities = NULL;
	gp_abilities_list_new(&abilities);
	gp_abilities_list_load(abilities, context);
	
	CameraList *list = NULL;
	gp_list_new(&list);
	
	gp_abilities_list_detect(abilities, portinfolist, list, context);
	int count = gp_list_count(list);
	BOOL success = NO;
	
	for (int i = 0; i < count; i++) {
		const char *model = NULL;
		const char *port = NULL;
		gp_list_get_name(list, i, &model);
		gp_list_get_value(list, i, &port);
		
		if (strcmp(model, "USB PTP Class Camera") == 0) {
			int port_idx = gp_port_info_list_lookup_path(portinfolist, port);
			int ab_idx = gp_abilities_list_lookup_model(abilities, "USB PTP Class Camera");
			if (port_idx >= 0 && ab_idx >= 0) {
				GPPortInfo pi;
				CameraAbilities a;
				gp_port_info_list_get_info(portinfolist, port_idx, &pi);
				gp_abilities_list_get_abilities(abilities, ab_idx, &a);
				
				Camera *tmp_camera = NULL;
				gp_camera_new(&tmp_camera);
				gp_camera_set_port_info(tmp_camera, pi);
				gp_camera_set_abilities(tmp_camera, a);
				
				if (gp_camera_init(tmp_camera, context) >= GP_OK) {
					NSString *cam_model = camera_get_config(tmp_camera, context, "cameramodel");
					BOOL is_canon = NO;
					if (cam_model && ![cam_model hasPrefix:@"gp_"] && ![cam_model hasPrefix:@"widget "]) {
						if ([cam_model rangeOfString:@"Canon" options:NSCaseInsensitiveSearch].location != NSNotFound ||
							[cam_model rangeOfString:@"EOS" options:NSCaseInsensitiveSearch].location != NSNotFound) {
							is_canon = YES;
						}
					}
					if (!is_canon) {
						CameraText summary;
						if (gp_camera_get_summary(tmp_camera, &summary, context) >= GP_OK) {
							NSString *sum_str = [NSString stringWithUTF8String:summary.text];
							if ([sum_str rangeOfString:@"Canon" options:NSCaseInsensitiveSearch].location != NSNotFound ||
								[sum_str rangeOfString:@"EOS" options:NSCaseInsensitiveSearch].location != NSNotFound) {
								is_canon = YES;
							}
						}
					}
					
					if (is_canon) {
						gp_camera_exit(tmp_camera, context);
						gp_camera_free(tmp_camera);
						
						int canon_ab_idx = gp_abilities_list_lookup_model(abilities, "Canon EOS 1300D");
						if (canon_ab_idx >= 0) {
							CameraAbilities canon_a;
							gp_abilities_list_get_abilities(abilities, canon_ab_idx, &canon_a);
							
							gp_camera_new(camera);
							gp_camera_set_port_info(*camera, pi);
							gp_camera_set_abilities(*camera, canon_a);
							
							if (gp_camera_init(*camera, context) >= GP_OK) {
								success = YES;
								break;
							} else {
								gp_camera_free(*camera);
								*camera = NULL;
							}
						}
					} else {
						gp_camera_exit(tmp_camera, context);
						gp_camera_free(tmp_camera);
					}
				} else {
					gp_camera_free(tmp_camera);
				}
			}
		}
	}
	
	gp_list_free(list);
	gp_abilities_list_free(abilities);
	gp_port_info_list_free(portinfolist);
	
	if (success) {
		return GP_OK;
	}
	return ret;
}

NSString * camera_get_info()
{
	Camera		*camera;
	GPContext	*context;
	
	NSMutableString *output = [[NSMutableString alloc] initWithString:@""];
	
	kill_PTPCamera();
	
	context = gp_context_new();
	
	if(init_camera_with_fallback(&camera, context) < GP_OK) {
		[output appendString:@"No camera detected.\nTry again."];
		gp_context_unref(context);
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