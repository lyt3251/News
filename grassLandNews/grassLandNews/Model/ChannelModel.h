//
//  ChannelModel.h
//  grassLandNews
//
//  Created by liuyuantao on 16/8/21.
//  Copyright © 2016年 liuyuantao. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface ChannelModel : MTLModel<MTLJSONSerializing>
@property(nonatomic, strong)NSString *nodeId;
@property(nonatomic, strong)NSString *nodeName;
@property(nonatomic, strong)NSString *childChannels;
@property(nonatomic, assign)int64_t parentId;
@property(nonatomic, assign)int32_t depth;
@end
