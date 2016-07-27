//
//  UIImageView+TXSDImage.h
//  TXChatTeacher
//
//  Created by lyt on 15/12/31.
//  Copyright © 2015年 lingiqngwan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UIImageView+WebCache.h>

@interface UIImageView (TXSDImage)

- (void)TX_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder;

- (void)TX_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder completed:(SDWebImageCompletionBlock)completedBlock;
- (void)TXFeed_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder;
- (void)TXFeed_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder completed:(SDWebImageCompletionBlock)completedBlock;

@end
