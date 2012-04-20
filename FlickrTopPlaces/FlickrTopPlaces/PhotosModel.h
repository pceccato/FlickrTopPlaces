//
//  PhotosModel.h
//  FlickrTopPlaces
//
//  Created by Paul Ceccato on 5/04/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PhotoInfo : NSObject
@property (nonatomic,strong) NSString* title;
@property (nonatomic, strong) NSString* description;
@property (nonatomic, strong) NSString* photo_id;

@end

@interface PhotosModel : NSObject

@end


