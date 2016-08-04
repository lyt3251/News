//
//  ShareActionManager.h
//  UMengShare
//
//  Created by shengxin on 16/6/1.
//  Copyright © 2016年 shengxin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ShareModelHelper.h"
#import "ShareActionModel.h"
#import "SharePicModel.h"

@interface ShareActionManager : NSObject

+ (instancetype)shareInstance;

- (void)htmlShareToPlatformType:(kSharePlatformType)shareType
         FromViewController:(UIViewController*)vc
          andPostShareModel:(ShareActionModel*)shareModel;


- (void)picShareToPlatformType:(kSharePlatformType)shareType
            FromViewController:(UIViewController*)vc
             andPostShareModel:(SharePicModel*)shareModel;
@end
