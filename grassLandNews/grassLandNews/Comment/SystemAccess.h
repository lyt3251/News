//
//  SystemAccess.h
//  TXDemo
//
//  Created by frank on 16/6/6.
//  Copyright © 2016年 frank. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <MobileCoreServices/MobileCoreServices.h>

@interface SystemAccess : NSObject

+ (instancetype)shareSystem;
- (BOOL) isCameraAvailable;
- (BOOL) isRearCameraAvailable;
- (BOOL) isFrontCameraAvailable;
- (BOOL) doesCameraSupportTakingPhotos;
- (BOOL) isPhotoLibraryAvailable;

@end
