//
//  UIImageView+TXSDImage.m
//  TXChatTeacher
//
//  Created by lyt on 15/12/31.
//  Copyright © 2015年 lingiqngwan. All rights reserved.
//

#import "UIImageView+TXSDImage.h"


@implementation UIImageView (TXSDImage)

- (void)TX_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder
{
    SDWebImageOptions option = SDWebImageRetryFailed | SDWebImageContinueInBackground;
    [self sd_setImageWithURL:url placeholderImage:placeholder options:option];
}

- (void)TX_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder completed:(SDWebImageCompletionBlock)completedBlock
{
    SDWebImageOptions option = SDWebImageRetryFailed | SDWebImageContinueInBackground;
    [self sd_setImageWithURL:url placeholderImage:placeholder options:option completed:completedBlock];
}

- (void)TXFeed_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder
{
    NSArray *arr = [url.absoluteString componentsSeparatedByString:@"?"];
    if (arr && arr.count > 1) {
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            NSString *newUrl = [NSURL URLWithString:arr[0]].absoluteString;
            UIImage *image = [[SDWebImageManager sharedManager].imageCache imageFromMemoryCacheForKey:[NSString stringWithFormat:@"%@_cache",newUrl]];
            UIImage *image1 = [[SDWebImageManager sharedManager].imageCache imageFromDiskCacheForKey:[NSString stringWithFormat:@"%@_cache",newUrl]];
            if (image) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self setImage:image];
                });
            }else if (image1){
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self setImage:image1];
                });
            }else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self sd_setImageWithURL:url placeholderImage:placeholder];
                });
            }
        });
    }else{
        [self sd_setImageWithURL:url placeholderImage:placeholder];
    }

}

- (void)TXFeed_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder completed:(SDWebImageCompletionBlock)completedBlock
{
    NSArray *arr = [url.absoluteString componentsSeparatedByString:@"?"];
    if (arr && arr.count > 1) {
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            NSString *newUrl = [NSURL URLWithString:arr[0]].absoluteString;
            UIImage *image = [[SDWebImageManager sharedManager].imageCache imageFromMemoryCacheForKey:[NSString stringWithFormat:@"%@_cache",newUrl]];
            UIImage *image1 = [[SDWebImageManager sharedManager].imageCache imageFromDiskCacheForKey:[NSString stringWithFormat:@"%@_cache",newUrl]];
            if (image) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self setImage:image];
                });
            }else if (image1){
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self setImage:image1];
                });
            }else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self sd_setImageWithURL:url placeholderImage:placeholder completed:completedBlock];
                });
            }
        });
    }else{
        [self sd_setImageWithURL:url placeholderImage:placeholder completed:completedBlock];
    }

}



@end
