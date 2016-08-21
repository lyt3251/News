//
//  NewsModel.h
//  grassLandNews
//
//  Created by liuyuantao on 16/8/21.
//  Copyright © 2016年 liuyuantao. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface NewsModel : MTLModel<MTLJSONSerializing>
@property(nonatomic, assign)int64_t GeneralID;
@property(nonatomic, assign)int64_t nodeId;
@property(nonatomic, strong)NSString *nodeName;
@property(nonatomic, strong)NSString *title;
@property(nonatomic, strong)NSString *DefaultPicUrl;
@end
